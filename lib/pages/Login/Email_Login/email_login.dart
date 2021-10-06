import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/Homepage/homepage.dart';
import 'package:zomato/pages/Login/Email_Login/email_welcome.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _registerAccount() async {
    final User? user = (await auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;

    if (user != null) {
      await _firestore.collection('users').doc(auth.currentUser!.uid).set({
        'email': emailController.text.trim(),
      });
      if (!user.emailVerified) {
        user.sendEmailVerification();
      }
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            SizedBox(
              width: width,
              height: width * 0.17,
              child: TextFormField(
                controller: emailController,
                onChanged: (_) {
                  context
                      .read<Country>()
                      .getEmail(emailController, passwordController);
                },
                cursorColor: Colors.red.shade400,
                cursorWidth: 1.8,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: width * 0.051),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: width * 0.022),
                  labelText: 'Email address',
                  labelStyle: TextStyle(
                    fontSize: width * 0.048,
                    color: Colors.grey,
                  ),
                  floatingLabelStyle:
                      TextStyle(fontSize: width * 0.042, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red.shade400,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width,
              height: width * 0.17,
              child: TextFormField(
                controller: passwordController,
                onChanged: (_) {
                  context
                      .read<Country>()
                      .getEmail(emailController, passwordController);
                },
                cursorColor: Colors.red.shade400,
                cursorWidth: 1.8,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: width * 0.051),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: width * 0.022),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: width * 0.048,
                    color: Colors.grey,
                  ),
                  floatingLabelStyle:
                      TextStyle(fontSize: width * 0.042, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.red.shade400,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            Container(
              width: width,
              height: width * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.shade300,
              ),
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const EmailWelcome()));

                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    _registerAccount();
                  }
                },
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      title: const Text('Continue with Email'),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: width * 0.05,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
