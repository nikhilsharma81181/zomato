import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zomato/models/variables.dart';
import 'package:zomato/pages/Homepage/detail.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('restaurants');

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: SafeArea(
                top: true,
                bottom: false,
                child: Container(
                  padding: EdgeInsets.all(width * 0.032),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bihar, India',
                        style: TextStyle(
                          fontSize: width * 0.047,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const CircleAvatar(),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: MyDelegate(width),
              floating: true,
              pinned: true,
            )
          ],
          body: StreamBuilder<QuerySnapshot>(
            stream: ref.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.red.shade400),
                );
              }

              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          '${snapshot.data!.docs.length} restaurants around you',
                          style: TextStyle(
                              fontSize: width * 0.048,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Column(
                          children: snapshot.data!.docs
                              .map((e) => buildBody(e))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(color: Colors.red.shade400),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody(DocumentSnapshot e) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        context.read<Variables>().getRestaurantId(e.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DetailPg(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: width * 0.02),
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 7,
                spreadRadius: 4,
                offset: const Offset(0, 0.6),
              )
            ]),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: width * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(e['icon']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: width * 0.032,
                  top: width * 0.032,
                  child: Container(
                    padding: EdgeInsets.all(width * 0.018),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.bookmark_outline,
                      size: width * 0.07,
                    ),
                  ),
                ),
                Positioned(
                  right: width * 0.032,
                  bottom: width * 0.032,
                  child: Container(
                    padding: EdgeInsets.all(width * 0.014),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.4),
                      color: Colors.white,
                    ),
                    child: Text(
                      '61 mins',
                      style: TextStyle(fontSize: width * 0.03),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(width * 0.032),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e['name'],
                        style: TextStyle(
                          fontSize: width * 0.052,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(width * 0.012),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.4),
                          color: Colors.green.shade600,
                        ),
                        child: Row(
                          children: [
                            Text(
                              ' ${e['ratings']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: width * 0.034,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              size: width * 0.035,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          for (int i = 0; i < e['dish-type'].length; i++)
                            Text(
                              '${e['dish-type'][i]}, ',
                              style: TextStyle(
                                fontSize: width * 0.034,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${e['starting-price']} for one',
                        style: TextStyle(
                          fontSize: width * 0.034,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final double width;
  MyDelegate(this.width);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: width * 0.125,
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.042, vertical: width * 0.012),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400.withOpacity(0.45),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: width * 0.035),
                Icon(
                  Icons.search,
                  color: Colors.red,
                  size: width * 0.07,
                ),
                SizedBox(width: width * 0.03),
                Text(
                  'Resturant name, cusine, or a dish... ',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: width * 0.028),
                    buildRow('Fastest Devivery'),
                    buildRow('Offers'),
                    buildRow('Rating 4.0+'),
                    buildRow('Cuisines'),
                    buildRow('MAX Safety'),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(width * 0.021),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300.withOpacity(0.45),
                        spreadRadius: 1.4,
                        blurRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.sync_alt,
                          size: width * 0.037,
                        ),
                      ),
                      // SizedBox(width: width * 0.012),
                      const Text('Popular'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(text) {
    return Container(
        padding: EdgeInsets.all(width * 0.021),
        margin: EdgeInsets.symmetric(horizontal: width * 0.011),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(text));
  }

  @override
  double get maxExtent => width * 0.3;

  @override
  double get minExtent => width * 0.3;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
