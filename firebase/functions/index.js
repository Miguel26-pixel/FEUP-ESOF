const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");
const { firestore } = require("firebase-admin");

const RADIUS_METERS = 1000;
const DEFAULT_POSITION = {
    latitude: 41.177787,
    longitude: -8.595922,
}


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

        const type = (await alert.type.get()).data();
        result.push({
            ...alert,
            type,
        });

        return result;
    }, []);

    return res.json({
        data: alerts
    })
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

    const pointsQueries = [];
    const groupsQueries = [];

    for (const bound of bounds) {
        const pointQuery = pointsCollection
            .where("geohash", "!=", null)
            .orderBy("geohash")
            .where("floor", "=", floor)
            .startAt(bound[0])
            .endAt(bound[1])
            .get();

        pointsQueries.push(pointQuery);
        groupsQueries.push(groupQuery);
    }
    

    let pointsData = (await Promise.all(pointsQueries)).map(q => q.docs).flat();
    let groupsData = (await Promise.all(groupsQueries)).map(q => q.docs).flat();

    const groups = await Promise.all(groupsData.map(async (obj) => {
        const data = obj.data();

        const points = await Promise.all(data.points.map(async (pointRef) => {
            const data = (await pointRef.get()).data();
            const alerts = data.alerts.map((alertRef) => alertRef.id);
    
            return {
                ...data,
                alerts,
                id: obj.id
            }
        }));

        return {
            ...data,
            points,
        }
    }))

    const points = pointsData.map((obj) => {
        const data = obj.data();
        const alerts = data.alerts.map((alertRef) => alertRef.id);
    
        return {
            ...data,
            alerts,
            id: obj.id
        }
    });
  
    res.json({
        points,
        groups,
    })
})

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
