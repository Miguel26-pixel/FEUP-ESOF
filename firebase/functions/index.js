const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const {seed} = require("./mock");

const app = express();
app.use(express.json());

admin.initializeApp();
const db = admin.firestore();

const pointsCollection = db.collection("points");
const alertsCollection = db.collection("alerts");
const alertTypeCollection = db.collection("alert-type");
const spontaneousCollection = db.collection("spontaneous");
const groupsCollection = db.collection("groups");

seed(
    admin.firestore, 
    pointsCollection, 
    alertsCollection, 
    alertTypeCollection, 
    spontaneousCollection,
    groupsCollection);

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
