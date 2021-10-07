import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zomato/models/login_model.dart';

CollectionReference countryRef =
    FirebaseFirestore.instance.collection('country');

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: width * 0.02),
              alignment: Alignment.center,
              height: width * 0.11,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                cursorColor: Colors.red[400],
                style: TextStyle(fontSize: width * 0.047),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  suffixIcon: Icon(
                    FontAwesomeIcons.solidTimesCircle,
                    color: Colors.black54,
                    size: width * 0.04,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your country',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  SizedBox(height: height * 0.02),
                  StreamBuilder(
                    stream: countryRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      context
                                          .read<Country>()
                                          .getCountryCode(e['num'], e['icon']);
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: width * 0.01),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: width * 0.08,
                                                    height: width * 0.054,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          e['icon']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width * 0.025),
                                                  Text(
                                                    e['name'],
                                                    style: TextStyle(
                                                      fontSize: width * 0.042,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text('+${e['num']}'),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.grey.shade200,
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        );
                      } else {
                        return SizedBox(
                          width: width,
                          height: height * 0.8,
                          child: CircularProgressIndicator(
                              color: Colors.red.shade400),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
