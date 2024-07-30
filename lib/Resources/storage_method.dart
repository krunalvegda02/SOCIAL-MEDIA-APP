import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

//Adding image to firebase Storage

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    //CREATED REFERENCE FOR UPLOADING TO FIRESTORE
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

//IF IT IS POST THEN EVERY POST CONTAINS UNIQE ID

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadurl = await snap.ref.getDownloadURL();

    return downloadurl;
  }
}
