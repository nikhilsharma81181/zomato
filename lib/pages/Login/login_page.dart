import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/Homepage/homepage.dart';
import 'package:zomato/pages/Login/Email_Login/email_login.dart';
import 'package:zomato/pages/Login/otp.dart';

import 'country_option.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.5,
                    child: const Image(
                      image: AssetImage('assets/aa.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: width * 0.1,
                    right: width * 0.07,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 30.0,
                          sigmaY: 30.0,
                        ),
                        child: Container(
                          width: width * 0.17,
                          height: width * 0.09,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black.withOpacity(0.6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                fontSize: width * 0.037, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: width,
                height: height * 0.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFe82542),
                      Color(0xFFdb2366),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    buildTextFeild(),
                    SizedBox(height: height * 0.024),
                    buildSendButton(),
                    SizedBox(height: height * 0.05),
                    buildOr(),
                    SizedBox(height: height * 0.052),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildOther('mail', () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EmailLogin()));
                        }),
                        buildOther2('facebook'),
                        buildOther('google', () {
                          signInWithGoogle(context, const Homepage());
                        }),
                      ],
                    ),
                    SizedBox(height: height * 0.054),
                    Text(
                      'By continuing you agree to our',
                      style: TextStyle(
                        fontSize: width * 0.032,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.0025),
                    Text(
                      'Terms of Service  Privacy Policy  Content Policy',
                      style: TextStyle(
                        fontSize: width * 0.032,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFeild() {
    double width = MediaQuery.of(context).size.width;
    var textController = context.watch<Country>().phoneNumber;
    return Container(
      width: width * 0.87,
      height: width * 0.13,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CountryPage()));
            },
            child: SizedBox(
              width: width * 0.26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width * 0.07,
                    height: width * 0.056,
                    decoration: context.watch<Country>().flag != ''
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image:
                                    NetworkImage(context.watch<Country>().flag),
                                fit: BoxFit.cover))
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                                image: AssetImage('assets/india.png'),
                                fit: BoxFit.cover)),
                  ),
                  SizedBox(width: width * 0.01),
                  Text(
                    '+${context.watch<Country>().countryCode}',
                    style: TextStyle(
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.58,
            child: TextFormField(
              cursorColor: Colors.red.withOpacity(0.8),
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: TextStyle(
                fontSize: width * 0.046,
              ),
              controller: _phoneController,
              onChanged: (_) {
                context.read<Country>().getPhone(_phoneController);
              },
              decoration: InputDecoration(
                  suffixIcon: textController.text.isEmpty
                      ? const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        )
                      : GestureDetector(
                          onTap: () {
                            context.read<Country>().phoneNumber.clear();
                            context.read<Country>().getPhone(_phoneController);
                          },
                          child: Icon(
                            FontAwesomeIcons.solidTimesCircle,
                            color: Colors.black54,
                            size: width * 0.04,
                          ),
                        ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  counterText: '',
                  hintText: 'Enter Phone Number',
                  hintStyle: TextStyle(
                    fontSize: width * 0.042,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOther(String asset, Function() fn) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: fn,
      child: Container(
        padding: EdgeInsets.all(width * 0.037),
        width: width * 0.152,
        height: width * 0.152,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image(image: AssetImage('assets/$asset.png')),
      ),
    );
  }

  Widget buildOther2(String asset) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width * 0.152,
        height: width * 0.152,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image(image: AssetImage('assets/$asset.png')),
      ),
    );
  }

  Widget buildSendButton() {
    String phoneNumber = context.watch<Country>().phoneNumber.text;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.87,
      height: width * 0.135,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          if (phoneNumber.length == 10) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OtpPage(
                      phoneNumber: phoneNumber,
                    )));
          }
        },
        child: Text(
          'Send OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: width * 0.047,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget buildOr() {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.39,
          height: 0.9,
          color: Colors.white54.withOpacity(0.32),
        ),
        SizedBox(width: width * 0.02),
        Text(
          'OR',
          style: TextStyle(
            color: Colors.white38,
            fontSize: width * 0.038,
          ),
        ),
        SizedBox(width: width * 0.02),
        Container(
          width: width * 0.39,
          height: 0.9,
          color: Colors.white54.withOpacity(0.34),
        ),
      ],
    );
  }
}
