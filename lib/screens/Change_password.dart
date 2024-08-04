import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/screens/edit_profile.dart';
import 'package:sm/screens/forgot_pass.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/toastMessage.dart';

class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var currUser = FirebaseAuth.instance.currentUser!.uid;

  void changePass() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      final cred = EmailAuthProvider.credential(
        email: _emailController.text.toString(),
        password: _PasswordController.text.toString(),
      );
      user!.reauthenticateWithCredential(cred).then(
        (value) {
          user
              .updatePassword(
            _newPassController.text.toString(),
          )
              .then(
            (_) {
              Utils.toastmessage("Your Password has been Changed ");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(
                    uid: currUser,
                  ),
                ),
              );
              setState(() {
                isLoading = false;
              });
            },
          ).catchError(
            (e) {
              Utils.toastmessage(e.toString());
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _PasswordController.dispose();
    _newPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).padding * 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Password Recovery!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please Enter Your Current Password!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: getTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // EMAIL TEXTFIELD
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      hintText: "Enter Your Email",
                      hintStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: getTextColor(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // PASSWORD TEXTFIELD
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _PasswordController,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      labelStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      hintText: "Enter Your Password",
                      hintStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.password_outlined,
                        color: getTextColor(context),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // NEW PASSWORD
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _newPassController,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      hintText: "Enter Your New Password",
                      hintStyle: TextStyle(
                        color: getTextColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.password_outlined,
                        color: getTextColor(context),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPass(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: blueColor, fontSize: 18),
                      ),
                    ),
                  ),

                  // CHANGE PASSWORD
                  Padding(
                    padding: MediaQuery.of(context).padding * 7,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 45,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: blueColor,
                        ),
                        child: TextButton(
                          onPressed: () {
                            changePass();
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: primaryColor,
                                )
                              : Text(
                                  "Change Password",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: getTextColor(context)),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
