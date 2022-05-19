const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");
const geofire = require("geofire-common");
const { parsePoint } = require("./utils");

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
    const floor = req.body.location || 0;

    const bounds = geofire.geohashQueryBounds([
        locationRaw.latitude,
        locationRaw.longitude,
    ], 1000);

    const promises = [];

    // for (const b of bounds) {
    //     const q = point
    //       .orderBy('geohash')
    //       .startAt(b[0])
    //       .endAt(b[1]);
      
    //     promises.push(q.get());
    // }
      
    
    const groupsData = await groupsCollection.get();
    
    let pointsData = await pointsCollection
        .where("floor", "!=", null)
        .get();

    const groups = await Promise.all(groupsData.docs.map(async (obj) => {
        const data = obj.data();
        const points = await Promise.all(data.points.map(async (pointRef) => {
            const data = (await pointRef.get()).data();
            console.log(pointRef, data)
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

    const points = pointsData.docs.map((obj) => {
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

app.get("/point/:id/alerts", async (req, res) => {
    const point = (await pointsCollection.doc(req.params.id).get()).data();
    const alerts = await Promise.all(point.alerts.map(async (alertRef) => {
        const alert = (await alertRef.get()).data();
        console.log(alert)
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
