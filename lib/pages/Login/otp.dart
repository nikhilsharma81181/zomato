import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/Homepage/homepage.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKeyOTP = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _field1 = TextEditingController();
  final TextEditingController _field2 = TextEditingController();
  final TextEditingController _field3 = TextEditingController();
  final TextEditingController _field4 = TextEditingController();
  final TextEditingController _field5 = TextEditingController();
  final TextEditingController _field6 = TextEditingController();

  int start = 30;
  bool wait = false;

  var verificationCode = '';

  @override
  void initState() {
    super.initState();
    signUp();
  }

  Future signUp() async {
    startTimer();
    var _phoneNumber = '+91' + widget.phoneNumber.trim();
    var verifyPhoneNumber = auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        verificationCompleted: (PhoneAuthCredential) {
          auth.signInWithCredential(PhoneAuthCredential).then((users) async => {
                await _firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .set({
                  'phoneNumber':
                      context.watch<Country>().phoneNumber.text.trim(),
                  'useruid': auth.currentUser!.uid,
                }, SetOptions(merge: true)).then((value) => {
                          setState(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Homepage()),
                              (route) => false,
                            );
                          })
                        })
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          setState(() {
            // ignore: avoid_print
            print(error);
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: const Duration(seconds: 60));
    await verifyPhoneNumber;
  }

  otp() async {
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode,
              smsCode: (_field1.text +
                      _field2.text +
                      _field3.text +
                      _field4.text +
                      _field5.text +
                      _field6.text)
                  .toString()))
          .then((user) async => {
                //sign in was success

                await _firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .set({
                  'phonenumber':
                      widget.phoneNumber.trim(),
                }, SetOptions(merge: true)).then((value) => {
                          //then move to authorised area
                        }),
                setState(() {}),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Homepage(),
                  ),
                  (route) => false,
                )
              });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String phoneNumber = context.watch<Country>().phoneNumber.text;
    String countryCode = context.watch<Country>().countryCode;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  'Enter Verification Code',
                  style: TextStyle(fontSize: width * 0.05),
                ),
              ],
            ),
            SizedBox(height: height * 0.025),
            Container(
              width: width,
              alignment: Alignment.center,
              child: Form(
                key: _formKeyOTP,
                child: Column(
                  children: [
                    Text(
                      'We have sent a verification code to',
                      style: TextStyle(
                        fontSize: width * 0.0385,
                      ),
                    ),
                    SizedBox(height: height * 0.006),
                    Text(
                      '+$countryCode $phoneNumber',
                      style: TextStyle(
                        fontSize: width * 0.041,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.055),
            SizedBox(
              height: width * 0.155,
              width: width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _textFieldOTP(first: true, last: false, controller: _field1),
                  _textFieldOTP(first: false, last: false, controller: _field2),
                  _textFieldOTP(first: false, last: false, controller: _field3),
                  _textFieldOTP(first: false, last: false, controller: _field4),
                  _textFieldOTP(first: false, last: false, controller: _field5),
                  _textFieldOTP(first: false, last: true, controller: _field6),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: width,
        height: height * 0.1,
        child: Column(children: [
          Text(
            '0:$start',
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Didn\'t receive the code?  ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.036,
                ),
              ),
              GestureDetector(
                onTap: () {
                  startTimer();
                },
                child: Text(
                  'Resend now',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: width * 0.036,
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget _textFieldOTP({bool? first, last, var controller}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.125,
      child: TextFormField(
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
          if (_field1.text.length +
                  _field2.text.length +
                  _field3.text.length +
                  _field4.text.length +
                  _field5.text.length +
                  _field6.text.length ==
              6) {
            otp();
          }
        },
        showCursor: false,
        cursorHeight: MediaQuery.of(context).size.width * 0.055,
        controller: controller,
        readOnly: false,
        textAlign: TextAlign.center,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w500),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.2, color: Colors.black12),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.2, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 30;

          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
}
