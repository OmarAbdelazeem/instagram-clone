const functions = require("firebase-functions");

const admin = require('firebase-admin');

admin.initializeApp();

const storage = admin.storage();

const fcm = admin.messaging();

//1) when following someone

exports.onFollowingSomeone = functions.firestore
    .document("/usersFollowing/{senderId}/usersFollowing/{receiverId}")
    .onCreate(async (snapshot, context) => {

        // senderId
        const senderId = context.params.senderId;
        // receiverId
        const receiverId = context.params.receiverId;

        var followData = snapshot.data();

        //sender data
        var senderData = (await admin
            .firestore()
            .collection("users")
            .doc(senderId).get()).data();

        //reciever data
        var recieverData = (await admin
            .firestore()
            .collection("users")
            .doc(receiverId).get()).data();


        //1) increase sender following count

        admin
            .firestore()
            .collection("users").doc(senderId)
            .update({ "followingCount": admin.firestore.FieldValue.increment(1) });


        //2) increase receiver followers count
        admin
            .firestore()
            .collection("users")
            .doc(receiverId).update({ "followersCount": admin.firestore.FieldValue.increment(1) });

        //3) Add senderId to receiver followers collection

        admin.firestore().collection("usersFollowers").doc(receiverId).collection("usersFollowers")
            .doc(senderId).set({});

        //4) trnasfer the first two posts ids of receiver to sender timeline

        var lastReceiverPosts = await admin.firestore().collection("posts").where("publisherId", "==", receiverId)
            .orderBy("timestamp", "desc").limit(2).get();

        var senderTimelineDocRef = admin.firestore().collection("timeline").doc(senderId);

        lastReceiverPosts.docs.forEach(async doc => {
            await senderTimelineDocRef.collection("timeline").doc(doc.id).set({});
        });



        //7) send notification

        admin.firestore().collection("notifications").doc(receiverId)
            .collection("notifications").doc().set({
                'userId': senderId,
                'type': "1",
                "postId": null,
                "postPhotoUrl": null,
                "timestamp": followData["timestamp"]

            });

        payload = {
            notification: {
                'title': senderData["userName"],
                'body': "Started following you ."
            },
            data: {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                'id': senderData["id"],
                'type': "1",
                'postId': null
            }
        }

        fcm.sendToDevice(recieverData["token"], payload)

    });


//2) when unfollowing someone
exports.onUnfollowingSomeone = functions.firestore.document("/usersFollowing/{senderId}/usersFollowing/{receiverId}")
    .onDelete(async (snapshot, context) => {


        // senderId
        const senderId = context.params.senderId;
        // receiverId
        const receiverId = context.params.receiverId;

        //1) decrease sender following count

        admin
            .firestore()
            .collection("users").doc(senderId)
            .update({ "followingCount": admin.firestore.FieldValue.increment(-1) });


        //2) increase receiver followers count
        admin
            .firestore()
            .collection("users")
            .doc(receiverId).update({ "followersCount": admin.firestore.FieldValue.increment(-1) });

        //3) Remove senderId from receiver followers collection

        admin.firestore().collection("usersFollowers").doc(receiverId).collection("usersFollowers")
            .doc(senderId).delete();

        //4) Delete posts ids of receiver from sender timeline

        var senderTimelineDocRef = admin.firestore().collection("timeline").doc(senderId);

        var receiverPosts = await senderTimelineDocRef.collection("timeline").where("publisherId", "==", receiverId).get();


        receiverPosts.docs.forEach(async doc => {
            await senderTimeRef.doc(doc.id).delete();
        });


    })




//4) when creating new post

exports.onCreatingNewPost = functions.firestore
    .document("/posts/{postId}")
    .onCreate(async (snapshot, context) => {


        // post data
        var postData = snapshot.data();
        // postId
        const postId = context.params.postId;


        //1) increase publisher's postsCount 

        admin.firestore().collection("users").doc(postData["publisherId"])
            .update({ "postsCount": admin.firestore.FieldValue.increment(1) });



        //2) Add post id to publisher followers timeline

        var publisherFollowers = await admin.firestore().collection("usersFollowers")
            .doc(postData["publisherId"]).collection("usersFollowers").get();

        var timelineCollectionRef = admin.firestore().collection("timeline");

        publisherFollowers.docs.forEach(async doc => {

            await timelineCollectionRef.doc(doc.id).collection("timeline").doc(postId).set({ "timestamp": postData["timestamp"] });

        });


        //3) Add post id to publisher timeline
        await timelineCollectionRef.doc(postData["publisherId"])
            .collection("timeline").doc(postId).set({ "timestamp": postData["timestamp"] });




    });

//5) when deleting post

exports.onDeletingPost = functions.firestore
    .document("/posts/{postId}")
    .onDelete(async (snapshot, context) => {


        // post data
        var postData = snapshot.data();
        // postId
        const postId = context.params.postId;

        const publisherId = postData["publisherId"];


        //1) decrease publisher's postsCount 

        admin.firestore().collection("users").doc(publisherId)
            .update({ "postsCount": admin.firestore.FieldValue.increment(-1) });


        //2) remove post id from publisher followers

        var publisherFollowers = await admin.firestore().collection("usersFollowers")
            .doc(publisherId).collection("usersFollowers").get();

        var timelineCollectionRef = admin.firestore().collection("timeline");

        publisherFollowers.docs.forEach(async doc => {

            await timelineCollectionRef.doc(doc.id).collection("timeline").doc(postId).delete({});

        });


        //3) delete post image from strorage
        const bucket = storage.bucket();
        const path = "posts/" + publisherId + "/" + postId;
        await bucket.file(path).delete();

        //4) delete post comments 
        await admin.firestore().collection("postComments").doc(postId).delete();

        //5) delete post likes

        await admin.firestore().collection("postLikes").doc(postId).delete();


    });


//6) when liking post

exports.onLikingPost = functions.firestore
    .document("/postsLikes/{postId}/postsLikes/{likeOwnerId}")
    .onCreate(async (snapshot, context) => {

        // postId
        const postId = context.params.postId;

        // likeOwnerId
        const likeOwnerId = context.params.likeOwnerId;

        var likeData = snapshot.data();

        var likeOwnerData = (await admin.firestore().collection("users").doc(likeOwnerId).get()).data();

        // postData
        var postData = (await admin.firestore().collection("posts").doc(postId).get()).data();

        // recieverData
        var recieverData = (await admin.firestore().collection("users").doc(postData["publisherId"]).get()).data();


        //1) increase likes count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "likesCount": admin.firestore.FieldValue.increment(1) });




        //2) send notification
        // check if it is the logged in user
        if(recieverData["id"] != likeOwnerId){

            admin.firestore().collection("notifications").doc(recieverData["id"])
            .collection("notifications").doc().set({
                'userId': likeOwnerId,
                'type': "2",
                "postId": postId,
                "postPhotoUrl": postData["photoUrl"],
                "timestamp": likeData["timestamp"]
            });

        payload = {
            notification: {
                'title': likeOwnerData["userName"],
                'body': "Likes your post"
            },
            data: {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                'id': likeOwnerData["id"],
                'type': "2",
                "postId": postId
            }
        }

        fcm.sendToDevice(recieverData["token"], payload)
        }

      



    });


//7) when unliking post

exports.onUnlikingPost = functions.firestore
    .document("/postsLikes/{postId}/postsLikes/{publisherId}")
    .onDelete(async (snapshot, context) => {

        // postId
        const postId = context.params.postId;

        //1) decrease likes count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "likesCount": admin.firestore.FieldValue.increment(-1) });



    });


//8) when adding comment

exports.onAddingComment = functions.firestore
    .document("/postsComments/{postId}/postsComments/{commentId}")
    .onCreate(async (snapshot, context) => {

        // postId
        const postId = context.params.postId;

        //comment Data
        var commentData = snapshot.data();

        // comment Owner Data
        var commentOwnerData = (await admin
            .firestore()
            .collection("users")
            .doc(commentData["publisherId"]).get()).data();


        var recieverData = (await admin.firestore().collection("users")
            .doc(commentData["postPublisherId"]).get()).data();


        //1) increase comments count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "commentsCount": admin.firestore.FieldValue.increment(1) });



        //5) send notification
        // check if it is the logged in user 

        if(commentData["publisherId"] != recieverData["id"]){
            admin.firestore().collection("notifications").doc(recieverData["id"])
            .collection("notifications").doc().set({
                'userId': commentData["publisherId"],
                'type': "3",
                "postId": postId,
                "postPhotoUrl": commentData["postPhotoUrl"],
                "timestamp": commentData["timestamp"]

            });

        payload = {
            notification: {
                'title': commentOwnerData["userName"],
                'body': "Commented on your post"
            },
            data: {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                'id': commentOwnerData["id"],
                'type': "3",
                "postId": postId
            }
        }

        fcm.sendToDevice(recieverData["token"], payload)
        }
      


    });


//9) when deleting comment

exports.onDeletingComment = functions.firestore
    .document("/postsComments/{postId}/postsComments/{commentId}")
    .onDelete(async (snapshot, context) => {

        // postId
        const postId = context.params.postId;

        //1) decrease comments count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "commentsCount": admin.firestore.FieldValue.increment(-1) });



    });

//10) when delete user 

exports.onDeleteUser = functions.firestore
    .document("/users/{userId}")
    .onDelete(async (snapshot, context) => {

        // userId
        const userId = context.params.userId;

        var postsRef = admin.firestore().collection("posts");

        //1) delete all posts

        var usersPosts = await postsRef.where("publisherId", "==", userId).get();

        usersPosts.docs.forEach(async doc => {
            await postsRef.doc(doc.id).delete();
        });


        //2) delete timeline 

        await admin.firestore().collection("timeline").doc(userId).delete();

    });