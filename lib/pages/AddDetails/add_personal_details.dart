import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/AddDetails/verification_code.dart';
import 'package:zomato/pages/Login/country_option.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 1 of 2: Add Personal Details',
                style: TextStyle(fontSize: width * 0.055),
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Adding these details is a one time process.Next time checkout will be a breeze',
                style: TextStyle(
                    fontSize: width * 0.035, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: height * 0.06),
              SizedBox(
                height: width * 0.1,
                child: TextFormField(
                  cursorColor: Colors.red,
                  cursorHeight: width * 0.06,
                  style: TextStyle(fontSize: width * 0.043),
                  decoration: InputDecoration(
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    hintText: 'Name',
                    hintStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
              buildTextFeild(),
              SizedBox(height: height * 0.04),
              Container(
                width: width,
                height: width * 0.142,
                decoration: BoxDecoration(
                  color: _phoneController.text.isEmpty
                      ? Colors.grey.shade300
                      : Colors.red.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RawMaterialButton(
                  onPressed: () {
                    if (_phoneController.text.length == 10) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VarificationCode(
                                phoneNumber: _phoneController.text,
                              )));
                    } else {}
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: _phoneController.text.isEmpty
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
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
}
