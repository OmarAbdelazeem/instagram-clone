const functions = require("firebase-functions");

const admin = require('firebase-admin');

admin.initializeApp();

const storage = admin.storage();

//1) when following someone

exports.onFollowingSomeone = functions.firestore
    .document("/usersFollowing/{senderId}/usersFollowing/{receiverId}")
    .onCreate(async (snapshot, context) => {

        // senderId
        const senderId = context.params.senderId;
        // receiverId
        const receiverId = context.params.receiverId;


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
            .doc(receiverId).delete();

        //4) Delete posts ids of receiver from sender timeline

        var senderTimelineDocRef = admin.firestore().collection("timeline").doc(senderId);

        var receiverPosts =await senderTimelineDocRef.collection("timeline").where("publisherId", "==", receiverId).get();


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

            await timelineCollectionRef.doc(doc.id).collection("timeline").doc(postId).set({"timestamp": postData["timestamp"]});

        });


        //3) Add post id to publisher timeline
        await timelineCollectionRef.doc(postData["publisherId"])
        .collection("timeline").doc(postId).set({"timestamp": postData["timestamp"]});




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
    .document("/postsLikes/{postId}/postsLikes/{publisherId}")
    .onCreate(async (snapshot, context) => {

        // postId
        const postId = context.params.postId;

        //1) increase likes count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "likesCount": admin.firestore.FieldValue.increment(1) });



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

        //1) increase comments count

        await admin.firestore().collection("posts").doc(postId)
            .update({ "commentsCount": admin.firestore.FieldValue.increment(1) });



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

       var usersPosts = await postsRef.where("publisherId","==",userId).get();

       usersPosts.docs.forEach(async doc=>{
       await postsRef.doc(doc.id).delete();
       });


       //2) delete timeline 

       await admin.firestore().collection("timeline").doc(userId).delete();

    });