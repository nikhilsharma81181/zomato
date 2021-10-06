import 'package:flutter/material.dart';

class EmailWelcome extends StatefulWidget {
  const EmailWelcome({Key? key}) : super(key: key);

  @override
  _EmailWelcomeState createState() => _EmailWelcomeState();
}

class _EmailWelcomeState extends State<EmailWelcome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.02),
            Icon(
              Icons.mail_outline,
              size: width * 0.32,
              color: Colors.red.shade400,
            ),
            Text(
              'Check your email',
              style: TextStyle(
                fontSize: width * 0.051,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.65,
              child: Text(
                'To confirm your email address, please tap the button in the email we sent to ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: height * 0.055),
            Container(
              width: width * 0.94,
              height: width * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.shade300,
              ),
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {},
                child: Text(
                  'Open email app',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.048,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.018),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend link',
                    style: TextStyle(
                      fontSize: width * 0.041,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Manually enter OTP',
                    style: TextStyle(
                      fontSize: width * 0.041,
                      color: Colors.red.shade400,
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

  AppBar buildAppBar() {
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
    );
  }
}
