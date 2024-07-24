import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm/Resources/auth_method.dart';
import 'package:sm/responsive_layout/mobile_screen.dart';
import 'package:sm/responsive_layout/responsive_layout_screen.dart';
import 'package:sm/responsive_layout/web_screen.dart';
import 'package:sm/screens/login_screen.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/imagePick.dart';
import 'package:sm/utils/text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _Pass = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _username = TextEditingController();
  Uint8List? _img;
  bool isloading = false;

  void signUpUser() async {
    setState(() {
      isloading = true;
    });

    String result = await AuthMethod().SignUp(
        bio: _bio.text,
        email: _email.text,
        password: _Pass.text,
        username: _username.text,
        file: _img!);

    if (result == "Success") {
//NAVIGATING TO POST SCREEN
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayoutScreen(
                mobileScreenlayout: MobileScreenLayout(),
                webScreenlayout: WebScreenlayout(),
              )));
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _Pass.dispose();
    _bio.dispose();
    _username.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _img = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                Flexible(flex: 3, child: Container()),
//MEMORIES SVG IMAGE
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(
                  height: 50,
                ),

//CIRCLE AVATAR
                Stack(
                  children: [
                    _img != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_img!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://i.pinimg.com/474x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo)))
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),
//USERNAME
                text_form_field(
                    textEditingController: _username,
                    hintText: "Enter Your Username",
                    textInputType: TextInputType.text),

                const SizedBox(
                  height: 24,
                ),

//BIO
                text_form_field(
                    textEditingController: _bio,
                    hintText: "Enter Your Bio",
                    textInputType: TextInputType.text),

                const SizedBox(
                  height: 24,
                ),
//EMAIL TEXTFIELD
                text_form_field(
                    textEditingController: _email,
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.text),

                const SizedBox(
                  height: 24,
                ),

//PASSWORD TEXTFIELD
                text_form_field(
                    textEditingController: _Pass,
                    hintText: "Enter Your Password",
                    textInputType: TextInputType.text,
                    isPassword: true),

                const SizedBox(
                  height: 24,
                ),
//SIGN UP BUTTON
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: blueColor,
                    ),
                    child: isloading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : const Text(
                            "Sign UP",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                Flexible(flex: 3, child: Container()),
//TRANSITION TO SIGNIG UP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already Have An Account?",
                          style: TextStyle(fontSize: 15)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: blueColor),
                        ),
                      ),
                    )
                  ],
                ),

//FORGOT PASSWORD
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
