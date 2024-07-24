import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sm/Resources/auth_method.dart';
import 'package:sm/responsive_layout/mobile_screen.dart';
import 'package:sm/responsive_layout/responsive_layout_screen.dart';
import 'package:sm/responsive_layout/web_screen.dart';
import 'package:sm/screens/sign_up.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _Pass = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _Pass.dispose();
  }

  void LoginUser() async {
    setState(() {
      isloading = true;
    });

    String result = await AuthMethod().LoginUser(
      email: _email.text,
      password: _Pass.text,
    );

    if (result == "Success") {
//NAVIGATING SCREEN TO HOMESCREEN
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

//LOGIN BUTTON
                InkWell(
                  onTap: LoginUser,
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
                            "Log in",
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
                      child: const Text("Don't Have An Account?",
                          style: TextStyle(fontSize: 15)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: blueColor),
                        ),
                      ),
                    )
                  ],
                ),
//Flexible(flex: 1, child: Container()),

//FORGOT PASSWORD
              ],
            ),
          ),
        ),
      ),
    );
  }
}