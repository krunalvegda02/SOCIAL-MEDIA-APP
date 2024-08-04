import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm/resources/auth_methods.dart';
import 'package:sm/responsive_layout/mobile_screen.dart';
import 'package:sm/responsive_layout/responsive_layout_screen.dart';
import 'package:sm/responsive_layout/web_screen.dart';
import 'package:sm/screens/login_screen.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/imagePick.dart';
import 'package:sm/utils/text_form_field.dart';
import 'package:sm/utils/toastMessage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

//ALL CONTROLLERS
class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

//DISPOSE ALL CONTROLLERS
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

//SELECT IMAGE
  Future<void> _selectImage() async {
    final img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

//VALIDATOR CHECK
  Future<void> _signUpUser() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

//SIGNUP METHOD
    final result = await AuthMethod().SignUp(
      bio: _bioController.text,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

//IF WE SUCCESSFULLY SIGN UP..NAVIGATING TO APP INSIDE
    if (result == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayoutScreen(
            mobileScreenlayout: MobileScreenLayout(),
            webScreenlayout: WebScreenlayout(),
          ),
        ),
      );
    } else {
      Utils.toastmessage("Successfully Login");
    }
  }

//VALIDATOR CONDITION
  bool _validateInputs() {
    if (_usernameController.text.isEmpty ||
        _bioController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _image == null) {
      Utils.toastmessage("Please fill in all fields and select an image.");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // Use SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40), // Add top padding
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: getTextColor(context),
                  height: 64,
                ),
                const SizedBox(height: 40),
                Stack(
                  children: [
// CIRCLE AVATAR
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
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
                        onPressed: _selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

//EMAIL
                _buildTextFormField(
                  controller: _emailController,
                  hintText: "Enter Your Email",
                ),
                const SizedBox(height: 24),
//PASWWORD
                _buildTextFormField(
                  controller: _passwordController,
                  hintText: "Enter Your Password",
                  isPassword: true,
                ),
                const SizedBox(height: 24),
//USERNAME
                _buildTextFormField(
                  controller: _usernameController,
                  hintText: "Enter Your Username",
                ),
                const SizedBox(height: 24),

//BIO
                TextField(
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
                    contentPadding: EdgeInsets.all(9),
                    hintText: "Enter Your Bio",
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  /*ONTAP EVENT*/ onTap: _signUpUser,
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

//LOG IN TRANSITIONIGN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Have An Account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return text_form_field(
      textEditingController: controller,
      hintText: hintText,
      textInputType: TextInputType.text,
      isPassword: isPassword,
    );
  }
}
