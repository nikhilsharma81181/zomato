import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/Cart&Order/cart.dart';

var _firestore = FirebaseFirestore.instance;

class VarificationCode extends StatefulWidget {
  final String phoneNumber;
  const VarificationCode({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _VarificationCodeState createState() => _VarificationCodeState();
}

class _VarificationCodeState extends State<VarificationCode> {
  TextEditingController otpController = TextEditingController();

  int start = 30;
  bool wait = false;

  var verificationCode = '';

  @override
  void initState() {
    super.initState();
    signUp();
  }

  Future signUp() async {
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
                                      const Cart()),
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
    print('sign up');
  }

  otp() async {
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode, smsCode: otpController.text))
          .then((user) async => {
                await _firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .set({
                  'phonenumber': widget.phoneNumber.trim(),
                }, SetOptions(merge: true)).then((value) => {
                          //then move to authorised area
                        }),
                setState(() {}),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Cart(),
                  ),
                  (route) => false,
                )
              });
      print('otpdfdsfdsfsd');
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: width * 0.055),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Enter the 4-digit verification code sent to $phoneNumber',
              style: TextStyle(
                  fontSize: width * 0.035, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: height * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.15,
                  child: TextFormField(
                    cursorColor: Colors.red.shade300,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      if (otpController.text.length == 6) {
                        setState(() {
                          otp();
                        });
                      }
                    },
                    style: TextStyle(fontSize: width * 0.047),
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '- - - -',
                      hintStyle: TextStyle(fontSize: width * 0.057),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.06),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.45,
                  height: width * 0.135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 2,
                      color: Colors.red.shade300,
                    ),
                  ),
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.45,
                  height: width * 0.135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 2,
                      color: Colors.red.shade300,
                    ),
                  ),
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: Text(
                      'Call me',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
