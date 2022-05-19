const admin = require("firebase-admin");

/**
 * 
 * @param {admin.firestore} firestore
 * @param {admin.firestore.CollectionReference} pointsCollection 
 * @param {admin.firestore.CollectionReference} alertsCollection 
 * @param {admin.firestore.CollectionReference} alertTypeCollection 
 * @param {admin.firestore.CollectionReference} groupsCollection 
 */
exports.seed = async (
    firestore, 
    pointsCollection,
    alertsCollection, 
    alertTypeCollection, 
    spontaneousCollection, 
    groupsCollection
    ) => {
    
    const alertType0 = await alertTypeCollection.add({
        "base-duration-seconds": 600,
        message: "This location is full",
        name: "Full"
    });

    const alertType1 = await alertTypeCollection.add({
        "base-duration-seconds": 600,
        message: "This location is empty",
        name: "Empty"
    });

    const alertType2 = await alertTypeCollection.add({
        "base-duration-seconds": 600,
        message: "This location is not working properly",
        name: "Broken"
    });

    const alert0 = await alertsCollection.add({
        "finish-time": firestore.Timestamp.fromDate(new Date("25 May 2022 12:00:00 UTC+1")),
        "start-time": firestore.Timestamp.fromDate(new Date("11 May 2022 12:00:00 UTC+1")),
        "type": alertType0
    });

    const alert1 = await alertsCollection.add({
        "finish-time": firestore.Timestamp.fromDate(new Date("25 May 2022 12:00:00 UTC+1")),
        "start-time": firestore.Timestamp.fromDate(new Date("11 May 2022 12:00:00 UTC+1")),
        "type": alertType1
    });

    const alert3 = await alertsCollection.add({
        "finish-time": firestore.Timestamp.fromDate(new Date("25 May 2022 12:00:00 UTC+1")),
        "start-time": firestore.Timestamp.fromDate(new Date("11 May 2022 12:00:00 UTC+1")),
        "type": alertType2
    });

    await pointsCollection.add({
        name: "Bar da Biblioteca",
        floor: 0,
        position: new firestore.GeoPoint(41.1774666, -8.5950153),
        alerts: [
            alert0
        ]
    });

    const groupPoint1 = await pointsCollection.add({
        name: "Máquina de café",
        alerts: [
            alert3
        ]
    });

    const groupPoint2 = await pointsCollection.add({
        name: "Vending",
        alerts: []
    });


    await groupsCollection.add({
        position: new firestore.GeoPoint(41.17727714163054, -8.595256805419924),
        floor: 1,
        points: [
            groupPoint1,
            groupPoint2,
        ]
    })

    pointsCollection.add({
        name: "Máquina de Café",
        floor: 2,
        position: new firestore.GeoPoint(41.1774666, -8.5950153),
        alerts: [
            alert0
        ]
    });

    await pointsCollection.add({
        name: "Cantina da Faculdade de Engenharia",
        floor: 0,
        position: new firestore.GeoPoint(41.176243, -8.595501),
        alerts: [
            alert1
        ]
    });
}