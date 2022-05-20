const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");
const geofire = require("geofire-common");
const { parsePoint } = require("./utils");
const { firestore } = require("firebase-admin");

const RADIUS_METERS = 1000;
const DEFAULT_POSITION = {
    latitude: 41.177787,
    longitude: -8.595922,
}
const GROUP_MAX_DIST = 0.02; // KILOMETERS

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
//     db, 
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

app.get("/points", async (req, res) => {
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
      
        const groupQuery = groupsCollection
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

// Think in some form of security measure
app.post("/points/new", async (req, res) => {
    const {
        name,
        floor,
        location,
    } = req.body;

    if (!name || floor === null || !location?.latitude || !location?.longitude) {
        return res.status(401).json({error: "Invalid arguments"});
    }

    const bounds = geofire.geohashQueryBounds([
        location.latitude,
        location.longitude,
    ], 50);

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

        const groupQuery = groupsCollection
            .where("geohash", "!=", null)
            .orderBy("geohash")
            .where("floor", "=", floor)
            .startAt(bound[0])
            .endAt(bound[1])
            .get();

        pointsQueries.push(pointQuery);
        groupsQueries.push(groupQuery);
    }
    

    let pointsData = (await Promise.all(pointsQueries))
        .map(q => q.docs)
        .flat()
        .filter(e => ((data) => geofire.distanceBetween(
            [data.position.latitude, data.position.longitude],
            [location.latitude, location.longitude]) < GROUP_MAX_DIST)(e.data()));

    let groupsData = (await Promise.all(groupsQueries))
        .map(q => q.docs)
        .flat()
        .filter(e => ((data) => geofire.distanceBetween(
            [data.position.latitude, data.position.longitude],
            [location.latitude, location.longitude]) < GROUP_MAX_DIST)(e.data()));

    if (groupsData.length > 0) {
        const pointRef = await pointsCollection.add({
            name,
            alerts: [],
        });

        await groupsData[0].ref.update({
            points: firestore.FieldValue.arrayUnion(pointRef)
        });
    } else if (pointsData.length > 0) {
        const pointRef = await pointsCollection.add({
            name,
            alerts: [],
        });
        await groupsCollection.add({
            position: new firestore.GeoPoint(location.latitude, location.longitude),
            geohash: geofire.geohashForLocation([location.latitude, location.longitude]),
            floor,
            points: pointsData.map(point => {
                point.ref.update({
                    geohash: firestore.FieldValue.delete(),
                    position: firestore.FieldValue.delete(),
                    floor: firestore.FieldValue.delete(),
                })
                return point.ref;
            }).concat([pointRef]),
        });
    } else {
        await pointsCollection.add({
            name,
            floor,
            position: new firestore.GeoPoint(location.latitude, location.longitude),
            geohash: geofire.geohashForLocation([location.latitude, location.longitude]),
            alerts: []
        });
    }

    return res.json("");
});

app.get("/point/:id/alerts", async (req, res) => {
    const point = (await pointsCollection.doc(req.params.id).get()).data();
    const alerts = await Promise.all(point.alerts.map(async (alertRef) => {
        const alert = (await alertRef.get()).data();
        const type = (await alert.type.get()).data();
        return {
            ...alert,
            type,
        };
    }));

    return res.json({
        data: alerts
    })
});

exports.widgets = functions.https.onRequest(app);
