const functions = require("firebase-functions");

 const admin = require('firebase-admin');

 admin.initializeApp();


  //1) when usersFollowing collection incremented
     exports.onCreateSubCategory = functions.firestore
         .document("/usersFollowing/{senderId}/usersFollowing/{receiverId}")
         .onCreate(async (snapshot, context) => {

             const senderId = context.params.senderId;
             const receiverId = context.params.receiverId;


             admin
                 .firestore()
                 .collection("usersFollowers").doc(receiverId).collection("usersFollowers")
                 .doc(senderId).set({});

         });


         //3) when usersFollowing collection decremented
            exports.onDeleteSubCategory = functions.firestore.document("/usersFollowing/{senderId}/usersFollowing/{receiverId}").onDelete(async (snapshot, context) => {

                    const senderId = context.params.senderId;
                    const receiverId = context.params.receiverId;

              admin
                             .firestore()
                             .collection("usersFollowers").doc(receiverId).collection("usersFollowers")
                             .doc(senderId).delete();



            })

