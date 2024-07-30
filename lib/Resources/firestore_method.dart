import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sm/Models/post.dart';
import 'package:sm/Resources/storage_method.dart';
import 'package:sm/utils/toastMessage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//UPLOAD POST
  Future<String> uploadPost(
    String caption,
    Uint8List file,
    String uid,
    String username,
    String profpick,
  ) async {
    String result = "Error";

    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage("Posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        caption: caption,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        username: username,
        profpick: profpick,
        postUrl: photoURL,
        likes: [],
      );

/*FIRESTORE METHOD WHERE WE STORE OUR POST INTO POST REFERENSE THEN WE CREATE 
BRANCH OF POSTID AND THEN WE SAVE OUR POST ELEMENTS*/
      _firestore.collection("posts").doc(postId).set(
            post.toJson(), // <- THIS LINE HELPS IN COLLECTING ALL DATA FOR POST (TOJSON)
          );

      Utils.toastmessage("Post Succesfully");
      result = "success";
    } catch (error) {
      Utils.toastmessage(error.toString());
    }

    return result;
  }

//UPDATING LIKES
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      /** IF LIKES ALREADY CONTAIN ANY UID THEN WE DESLIKE IT MEANS THAT WE 
       * REMOVE OUR UID FROM POST*/

      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      }

      /** AND IF THERE IS NO UID IN LIKES ARRAY THEN WE WILL ADD UID AND 
       * CONSIDER IT AS A LIKE*/

      else {
        await _firestore.collection("posts").doc(postId).update(
          {
            "likes": FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
  }

//STORING COMMENTS
  Future<void> PostComment(
    String postId,
    String text,
    String name,
    String profilePic,
    String uid,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "commentId": commentId,
          "datePublished": DateTime.now(),
          "comment": text
        });
      } else {
        Utils.toastmessage("Caption Is empty");
      }
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
  }

//DELETE A POST

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
  }

//FOLLOW FUNCTIONALITY
  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

/**SINCE WE HAVE ONLY ONE BUTTON FOR WHAT WE APPLY CONDITIONAL STATEMENT SO 
 * IF WE DONT FOLLOW HIM THAT WE CAN SEE FOLLOW BUTTON AND OUR IT WILL SHOW IN
 *  FOLLOWING LIST OTHERWISE WE WILL UNFOLLOW HIM AND OUR ID WILL REMOVE  */
      if (following.contains(followId)) {
        //REMOVING UID FROM FOLLOWERLIST
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });
        //REMOVING UID FROM OTHER USERS FOLLWING LIST
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        //ADDING UID FROM FOLLOWERLIST
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });

        //ADDING UID FROM OTHER USERS FOLLWING LIST
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
  }
}
