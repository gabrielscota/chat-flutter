const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

exports.createMsg = functions.firestore
    .document('chat/{msgId}')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('chat', {
            notification: {
                title: snap.data().userName,
                body: snap.data().text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            }
        })
    })