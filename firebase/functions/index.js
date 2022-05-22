const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");
const geofire = require("geofire-common");
const { firestore } = require("firebase-admin");

const RADIUS_METERS = 1000;
const DEFAULT_POSITION = {
    latitude: 41.177787,
    longitude: -8.595922,
}
const ALERT_TIME_REDUCE_SECONDS = 120;
const ALERT_ADD_TIME_REDUCE_SECONDS = 60;
const SPONTANEOUS_LIFETIME = 300;


const app = express();
app.use(express.json());

admin.initializeApp();
const db = admin.firestore();

const pointsCollection = db.collection("points");
const alertsCollection = db.collection("alerts");
const alertTypeCollection = db.collection("alert-type");
const spontaneousCollection = db.collection("spontaneous");
const groupsCollection = db.collection("groups");

// seed(
//     admin.firestore, 
//     pointsCollection, 
//     alertsCollection, 
//     alertTypeCollection, 
//     spontaneousCollection,
//     groupsCollection);

exports.pointsOfInterest = functions.https.onRequest(async (_, response) => {
  let data = await pointsCollection.get();

  const result = await Promise.all(data.docs.map(async (obj) =>  {
      const data = obj.data();

      const alerts = await Promise.all(data.alerts.map(async (alertRef) => {
        const alert = (await alertRef.get()).data();
        return alert;
      }));
    
      return {
          ...data,
          alerts,
          id: obj.id
      }
    }));

  response.send(JSON.stringify({
      data: result
  }));
});

app.get("/point/:id/alerts", async (req, res) => {
    const pointRef = pointsCollection.doc(req.params.id);
    const pointSnapshot = await pointRef.get();
    if (!pointSnapshot.exists) {
        return res.status(401).json({error: "Not found"});
    }

    const point = pointSnapshot.data();
    const alerts = await point.alerts.reduce(async (result, alertRef) => {
        const alertSnapshot = await alertRef.get();
        const alert = alertSnapshot.data();

        if (alert["start-time"].toDate() > new Date()) {
            return result;
        }

        if (alert["finish-time"].toDate() < new Date()) {
            await pointRef.update({
                alerts: firestore.FieldValue.arrayRemove(alertRef),
            })
            return result;
        }

        const type = {
            ...(await alert.type.get()).data(),
            id: alert.type.id
        };
        result.push({
            ...alert,
            id: alertRef.id,
            type,
        });

        return result;
    }, []);

    return res.json({
        data: alerts
    })
});

app.post("/alerts/:id/reject", async (req, res) => {
    const alertSnapshot = await alertsCollection.doc(req.params.id).get();
    
    if (!alertSnapshot.exists) {
        return res.status(401).json({error: "Not found"})
    }

    const alert = alertSnapshot.data();
    
    const currentFinish = alert["finish-time"].toDate();

    if (currentFinish < Date.now()) {
        return res.status(401).json({error: "Not found"});
    }

    const newTimestamp = new Date(currentFinish - ALERT_TIME_REDUCE_SECONDS * 1000);

    await alertSnapshot.ref.update({
        "finish-time": firestore.Timestamp.fromDate(newTimestamp),
    });

    const deleted = newTimestamp < Date.now();

    return res.json({
        deleted,
    });
});

app.post("/alerts/:id/accept", async (req, res) => {
    const alertSnapshot = await alertsCollection.doc(req.params.id).get();
    
    if (!alertSnapshot.exists) {
        return res.status(401).json({error: "Not found"})
    }

    const alert = alertSnapshot.data();
    
    const currentFinish = alert["finish-time"].toDate();

    if (currentFinish < Date.now()) {
        return res.status(401).json({error: "Not found"});
    }

    await alertSnapshot.ref.update({
        "finish-time": firestore.Timestamp.fromDate(new Date(currentFinish + ALERT_ADD_TIME_REDUCE_SECONDS * 1000)),
    });

    return res.json("");
});

app.post("/points/:id/alerts/new", async (req, res) => {
    const {
        type: typeId,
    } = req.body;

    if (!typeId) {
        return res.status(401).json({error: "Invalid arguments"});
    }

    const type  = await alertTypeCollection.doc(typeId).get();
    const point = await pointsCollection.doc(req.params.id).get();
    
    if (!type.exists || !point.exists) {
        return res.status(401).json({error: "Not found"})
    }

    const typeData = type.data()

    const alert = await alertsCollection.add({
        type: type.ref,
        "start-time": firestore.Timestamp.fromDate(new Date(Date.now())),
        "finish-time": firestore.Timestamp.fromDate(new Date(Date.now() + typeData["base-duration-seconds"] * 1000)),
    });

    await point.ref.update({
        alerts: firestore.FieldValue.arrayUnion(alert)
    })

    return res.json("");
});

app.get("/alerts/spontaneous", async (req, res) => {
    const locationRaw = req.body.location || DEFAULT_POSITION;
    const floor = req.body.floor || 0;

    const bounds = geofire.geohashQueryBounds([
        locationRaw.latitude,
        locationRaw.longitude,
    ], RADIUS_METERS);

    const spontaneousAlertsSnapshots  = [];

    const currentDate = firestore.Timestamp.fromDate(new Date());

    for (const bound of bounds) {
        const docs = (await spontaneousCollection
            .where("geohash", "!=", null)
            .orderBy("geohash")
            .startAt(bound[0])
            .endAt(bound[1])
            .get()).docs;
        const res = 
            docs.filter(doc => ((d) => d.floor === floor && d["finish-time"] > currentDate)(doc.data()));
        spontaneousAlertsSnapshots.push(...res);
    }


    const alerts = await Promise.all(spontaneousAlertsSnapshots.map(async (obj) => {
        const data = obj.data();

        return {
            ...data,
            id: obj.id
        }
    }))

    res.json({
        data: alerts,
    })
})

app.post("/alerts/spontaneous/new", async (req, res) => {
    const {
        floor,
        message,
        location,
    } = req.body;
    
    if (!message || floor === null || !location?.latitude || !location?.longitude) {
        return res.status(401).json({error: "Invalid arguments"});
    }

    await spontaneousCollection.add({
        message,
        floor,
        position: new firestore.GeoPoint(location.latitude, location.longitude),
        geohash: geofire.geohashForLocation([location.latitude, location.longitude]),
        "start-time": firestore.Timestamp.fromDate(new Date(Date.now())),
        "finish-time": firestore.Timestamp.fromDate(new Date(Date.now() + SPONTANEOUS_LIFETIME * 1000)),
    });

    res.json("");
})

app.post("/alerts/spontaneous/:id/reject", async (req, res) => {
    const alertSnapshot = await spontaneousCollection.doc(req.params.id).get();
    
    if (!alertSnapshot.exists) {
        return res.status(401).json({error: "Not found"})
    }

    const alert = alertSnapshot.data();
    
    const currentFinish = alert["finish-time"].toDate();

    if (currentFinish < Date.now()) {
        return res.status(401).json({error: "Not found"});
    }

    const newTimestamp = new Date(currentFinish - ALERT_TIME_REDUCE_SECONDS * 1000);

    await alertSnapshot.ref.update({
        "finish-time": firestore.Timestamp.fromDate(newTimestamp),
    });

    const deleted = newTimestamp < Date.now();

    return res.json({
        deleted,
    });
});

app.post("/alerts/spontaneous/:id/accept", async (req, res) => {
    const alertSnapshot = await spontaneousCollection.doc(req.params.id).get();
    
    if (!alertSnapshot.exists) {
        return res.status(401).json({error: "Not found"})
    }

    const alert = alertSnapshot.data();
    
    const currentFinish = alert["finish-time"].toDate();

    if (currentFinish < Date.now()) {
        return res.status(401).json({error: "Not found"});
    }

    await alertSnapshot.ref.update({
        "finish-time": firestore.Timestamp.fromDate(new Date(currentFinish + ALERT_ADD_TIME_REDUCE_SECONDS * 1000)),
    });

    return res.json("");
});

exports.widgets = functions.https.onRequest(app);

// exports.wtv = {
//     groups: [
//         {
//             position: 2,
//             floor,
//             points: [
//                 {
//                     name: "ola",
//                     id: "asdasd"
//                 }
//             ]
//         }
//     ],
//     points: [
//         {
//             id: "asdasd",
//             name: "ila",

//         }
//     ]
// }
