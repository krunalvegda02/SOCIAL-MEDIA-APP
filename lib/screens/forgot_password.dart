import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/utils/toastMessage.dart';


class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
  final _auth = FirebaseAuth.instance;
  TextEditingController forgotpass = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             
            
              const Text(
                "Password Recovery",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  "Enter your Recovery email to get password recovery link!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: forgotpass,
                decoration: const InputDecoration(
                  labelText: "Email",
                  // helperText: "enter email: e.g. xyz12@gmail.com",
                  hintText: "enter your email",
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (String value) {},
                validator: (value) {
                  return value!.isEmpty ? 'please enter E-mail' : null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _auth
                          .sendPasswordResetEmail(
                              email: forgotpass.text.toString())
                          .then((value) {
                        Utils.toastmessage(
                            "We will sent you email to recover password, Please check email ");
                      }).onError((error, StackTrace) {
                        Utils.toastmessage(error.toString());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 234, 159),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}
