const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");
const geofire = require("geofire-common");
<<<<<<< HEAD
=======
const { parsePoint } = require("./utils");
>>>>>>> main
const { firestore } = require("firebase-admin");

const RADIUS_METERS = 1000;
const DEFAULT_POSITION = {
    latitude: 41.177787,
    longitude: -8.595922,
}
<<<<<<< HEAD
const ALERT_TIME_REDUCE_SECONDS = 120;
const ALERT_ADD_TIME_REDUCE_SECONDS = 60;
const SPONTANEOUS_LIFETIME = 300;

=======
const GROUP_MAX_DIST = 0.02; // KILOMETERS
const FLOOR_LIMITS = [-1, 4];
>>>>>>> main

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
<<<<<<< HEAD
//     admin.firestore, 
=======
//     db, 
>>>>>>> main
//     pointsCollection, 
//     alertsCollection, 
//     alertTypeCollection, 
//     spontaneousCollection,
//     groupsCollection);

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

app.get("/points/limits", async (req, res) => {
    return res.json({
        data: FLOOR_LIMITS
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
<<<<<<< HEAD
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
=======
    const point = (await pointsCollection.doc(req.params.id).get()).data();
    const alerts = await Promise.all(point.alerts.map(async (alertRef) => {
        const alert = (await alertRef.get()).data();
        const type = (await alert.type.get()).data();
        return {
            ...alert,
            type,
>>>>>>> main
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
