import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sm/Resources/storage_method.dart';

import 'package:sm/Models/user.dart' as model;
import 'package:sm/utils/toastMessage.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//PROVIDER
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

//SIGNUP METHOD
  Future<String> SignUp({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String result = "Some Error Occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
//REGIsTER USER
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profURL = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

// ADD USER TO FIRESTORE DATABASE

        model.User User = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          profpick: profURL,
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(User.toJson());
        result = "Success";
        Utils.toastmessage(
          _auth.currentUser!.email.toString(),
        );
      }
    } catch (error) {
      result = error.toString();
      Utils.toastmessage(error.toString());
    }
    return result;
  }

//LOGINMETHOD
  Future<String> LoginUser({
    required String email,
    required String password,
  }) async {
    String result = "Some Error Occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        result = "Success";
        Utils.toastmessage(
            _auth.currentUser!.email.toString()); //login succesfull
      } else {
        Utils.toastmessage("Please Enter all Fields");
      }
    }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'wrong-password') {
    //     Utils.toastmessage("Wrong-Password");
    //   } else if (e.code == 'user-not-found') {
    //     Utils.toastmessage("User Not Found");
    //   }}
    catch (error) {
      result = error.toString();
      Utils.toastmessage(error.toString());
    }
    return result;
  }
}
