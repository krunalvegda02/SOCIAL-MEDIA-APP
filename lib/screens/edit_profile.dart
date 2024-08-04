import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/Models/user.dart' as model;
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/screens/Change_password.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/toastMessage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required String uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var currUser = FirebaseAuth.instance.currentUser!.uid;

//ALL CONTROLLERS

  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool userChanged = false;
  bool bioChanged = false;

//DISPOSE ALL CONTROLLERS
  @override
  void dispose() {
    _emailController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

//CHANGE USERNAME METHOD
  void changeUserName() {
    try {
      setState(() {
        _isLoading = true;
        userChanged = false;
      });
      FirebaseFirestore.instance
          .collection("users")
          .doc(currUser)
          .update({"username": _usernameController.text.toString()}).then((_) {
        setState(() {
          userChanged = true;
        });
        Utils.toastmessage(" updated successfully");
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        userChanged = false;
      });
      Utils.toastmessage(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
        //_bioController.clear();
      });
    }
  }

//CHANGE BIo METHOD
  void changeBio() {
    try {
      setState(() {
        _isLoading = true;
        bioChanged = false;
      });
      FirebaseFirestore.instance
          .collection("users")
          .doc(currUser)
          .update({"bio": _bioController.text.toString()}).then((_) {
        setState(() {
          bioChanged = true;
        });
        Utils.toastmessage(" updated successfully");
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        bioChanged = false;
      });
      Utils.toastmessage(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
        //_bioController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
//APPBAR
              "Edit Your Profile",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: getTextColor(context),
                  fontSize: 25),
            ),
          ],
        ),
      ),
//BODY
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Add top padding

// CIRCLE AVATAR
                CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(user.profpick),
                ),

                const SizedBox(height: 30),

//USERNAME
                TextFormField(
                  maxLines: 1,
                  cursorColor: getTextColor(context),
                  keyboardType: TextInputType.name,
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      filled: true,
                      contentPadding: const EdgeInsets.all(9),
                      hintText: "Enter New Username",
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.done_outline_rounded,
                          color: blueColor,
                        ),
                        onPressed: () {
                          changeUserName();
                        },
                      )),
                ),
                const SizedBox(height: 24),
//BIO
                TextFormField(
                  maxLines: null,
                  cursorColor: getTextColor(context),
                  maxLength: 200,
                  keyboardType: TextInputType.multiline,
                  controller: _bioController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      filled: true,
                      contentPadding: const EdgeInsets.all(9),
                      hintText: "Change Your Bio",
                      suffixIcon: _isLoading
                          ? const SizedBox(
                              // width: 24,
                              // height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              icon: bioChanged
                                  ? const Icon(
                                      Icons.done_outline_rounded,
                                      color: Color.fromARGB(255, 13, 214, 67),
                                    )
                                  : const Icon(
                                      Icons.done_outline_rounded,
                                      color: blueColor,
                                    ),
                              onPressed: () {
                                changeBio();
                              },
                            )),
                ),

//PASWWORD TEXTBUTTON
                TextButton(
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Change Password ?",
                      style: TextStyle(color: blueColor, fontSize: 18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPasword()));
                  },
                ),

//SAVE PROFILE BUTTON
                Padding(
                  padding: const EdgeInsets.only(top: 255.0),
                  child: InkWell(
                    /*ONTAP EVENT*/
                    onTap: () {},
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 45,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: blueColor,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : const Text(
                                "Save Profile",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
