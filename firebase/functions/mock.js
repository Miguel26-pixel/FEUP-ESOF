const {firestore} = require("firebase-admin");
const geofire = require("geofire-common");

const deleteCollection = (firestore, collection, batchSize=400) => {
  return collection.listDocuments()
      .then((docs) => {
        const batch = firestore.batch();

        if (docs.length <= batchSize) {
          docs.map( (doc) => {
            batch.delete(doc);
          });
          batch.commit();
          return true;
        } else {
          for (let i = 0; i < batchSize; i++) {
            batch.delete(docs[i]);
          }
          batch.commit();
          return false;
        }
      })
      .then( function(batchStatus) {
        return batchStatus ? true :
            deleteCollection(collection, batchSize, "");
      })
      .catch( function(error) {
        console.error(`Error clearing collections (${error})`);
        return false;
      });
};

/**
 *
 * @param {admin.firestore.Firestore} db
 * @param {admin.firestore.CollectionReference} pointsCollection
 * @param {admin.firestore.CollectionReference} alertsCollection
 * @param {admin.firestore.CollectionReference} alertTypeCollection
 * @param {admin.firestore.CollectionReference} spontaneousCollection
 * @param {admin.firestore.CollectionReference} groupsCollection
 */
const dropAll = async (
    db,
    pointsCollection,
    alertsCollection,
    alertTypeCollection,
    spontaneousCollection,
    groupsCollection,
) => Promise.all([
  deleteCollection(db, pointsCollection),
  deleteCollection(db, alertsCollection),
  deleteCollection(db, alertTypeCollection),
  deleteCollection(db, spontaneousCollection),
  deleteCollection(db, groupsCollection),
]);

/**
 *
 * @param {admin.firestore} db
 * @param {admin.firestore.CollectionReference} pointsCollection
 * @param {admin.firestore.CollectionReference} alertsCollection
 * @param {admin.firestore.CollectionReference} alertTypeCollection
 * @param {admin.firestore.CollectionReference} spontaneousCollection
 * @param {admin.firestore.CollectionReference} groupsCollection
 */
exports.seed = async (
    db,
    pointsCollection,
    alertsCollection,
    alertTypeCollection,
    spontaneousCollection,
    groupsCollection,
) => {
  await dropAll(
      db,
      pointsCollection,
      alertsCollection,
      alertTypeCollection,
      spontaneousCollection,
      groupsCollection,
  );

  const alertType0 = await alertTypeCollection.add({
    "base-duration-seconds": 600,
    "message": "This location is full",
    "name": "Full",
    "icon": "58094",
  });

  const alertType1 = await alertTypeCollection.add({
    "base-duration-seconds": 600,
    "message": "This location is empty",
    "name": "Empty",
    "icon": "58513",
  });

  const alertType2 = await alertTypeCollection.add({
    "base-duration-seconds": 600,
    "message": "This location is not working properly",
    "name": "Broken",
    "icon": "58666",
  });

  const alert0 = await alertsCollection.add({
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2023 12:00:00 UTC+1")),
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "type": alertType0,
  });

  const alert1 = await alertsCollection.add({
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2023 12:00:00 UTC+1")),
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "type": alertType1,
  });

  const alert3 = await alertsCollection.add({
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2023 12:00:00 UTC+1")),
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "type": alertType2,
  });

  await pointsCollection.add({
    name: "Bar da Biblioteca",
    floor: 0,
    position: new firestore.GeoPoint(41.1774666, -8.5950153),
    geohash: geofire.geohashForLocation([41.1774666, -8.5950153]),
    alerts: [
      alert0,
    ],
  });

  const groupPoint1 = await pointsCollection.add({
    name: "Máquina de café",
    alerts: [
      alert3,
    ],
  });

  const groupPoint2 = await pointsCollection.add({
    name: "Vending",
    alerts: [],
  });


  await groupsCollection.add({
    position: new firestore.GeoPoint(41.17727714163054, -8.595256805419924),
    geohash: geofire.geohashForLocation(
        [41.17727714163054, -8.595256805419924]),
    floor: 1,
    points: [
      groupPoint1,
      groupPoint2,
    ],
  });

  pointsCollection.add({
    name: "Máquina de Café",
    floor: 2,
    position: new firestore.GeoPoint(41.1774666, -8.5950153),
    geohash: geofire.geohashForLocation([41.1774666, -8.5950153]),
    alerts: [
      alert0,
    ],
  });

  await pointsCollection.add({
    name: "Cantina da Faculdade de Engenharia",
    floor: 0,
    position: new firestore.GeoPoint(41.176243, -8.595501),
    geohash: geofire.geohashForLocation([41.176243, -8.595501]),
    alerts: [
      alert1,
    ],
  });

  await spontaneousCollection.add({
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2022 12:00:00 UTC+1")),
    "message": "Spilt Cofee",
    "position": new firestore.GeoPoint(41.1775666, -8.5955153),
    "geohash": geofire.geohashForLocation([41.1775666, -8.5955153]),
    "floor": 0,
  });


  await spontaneousCollection.add({
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2022 12:00:00 UTC+1")),
    "message": "Spilt Cofee",
    "position": new firestore.GeoPoint(41.1775666, -8.5955153),
    "geohash": geofire.geohashForLocation([41.1775666, -8.5955153]),
    "floor": 1,
  });

  await spontaneousCollection.add({
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2022 12:00:00 UTC+1")),
    "message": "Spot in constructions",
    "position": new firestore.GeoPoint(41.1779666, -8.5955153),
    "geohash": geofire.geohashForLocation([41.1779666, -8.5955153]),
    "floor": 0,
  });

  await spontaneousCollection.add({
    "start-time": firestore.Timestamp.fromDate(
        new Date("11 May 2022 12:00:00 UTC+1")),
    "finish-time": firestore.Timestamp.fromDate(
        new Date("25 May 2022 12:00:00 UTC+1")),
    "message": "Flooded street",
    "position": new firestore.GeoPoint(41.021195, -8.563309),
    "geohash": geofire.geohashForLocation([41.021195, -8.563309]),
    "floor": 0,
  });
};
