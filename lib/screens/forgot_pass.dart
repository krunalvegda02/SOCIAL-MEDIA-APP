import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/toastMessage.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _EmailController = TextEditingController();

  bool loading = false;

  void forgotPass() async {
    await _auth
        .sendPasswordResetEmail(
      email: _EmailController.text.toString(),
    )
        .then((value) {
      Utils.toastmessage(
          "We will sent you Email link to Recover your Password, Please check Your email ");
      setState(() {
        loading = false;
      });
    }).onError((error, StackTrace) {
      Utils.toastmessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password !"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Password Recovery !",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
                "Enter your Recovery email to get password recovery link!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _EmailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: getTextColor(context)),
                hintText: "Enter Your Email",
                prefixIcon: Icon(
                  Icons.email,
                  color: getTextColor(context),
                ),
              ),
              onChanged: (String value) {},
              validator: (value) {
                return value!.isEmpty ? 'Please Enter Email' : null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: blueColor,
                ),
                child: TextButton(
                    onPressed: () {
                      forgotPass();
                      setState(() {
                        loading = true;
                      });
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 20,
                        color: getTextColor(context),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
