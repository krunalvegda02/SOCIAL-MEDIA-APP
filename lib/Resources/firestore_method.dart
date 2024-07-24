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
    String profImage,
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
        //UNKNOWN ERROR IN USERNAME AND PROFIMG
        username: profImage,
        profImage: username,
        //
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
}
