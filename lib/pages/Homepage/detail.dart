import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/variables.dart';
import 'package:zomato/pages/Homepage/delivery_tab.dart';
import 'package:zomato/pages/Homepage/homepage.dart';
import 'package:zomato/pages/Homepage/review_tab.dart';

class DetailPg extends StatefulWidget {
  const DetailPg({Key? key}) : super(key: key);

  @override
  _DetailPgState createState() => _DetailPgState();
}

class _DetailPgState extends State<DetailPg>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String restaurantsId = context.watch<Variables>().restaurantId;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: ref.doc(restaurantsId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic> e =
                snapshot.data!.data() as Map<String, dynamic>;
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  builtAppbar(),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.025),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.7,
                                    child: Text(
                                      e['name'],
                                      style: TextStyle(
                                        fontSize: width * 0.065,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.0085),
                                  SizedBox(
                                    width: width * 0.7,
                                    child: Wrap(
                                      children: [
                                        for (int i = 0;
                                            i < e['dish-type'].length;
                                            i++)
                                          Text(
                                            '${e['dish-type'][i]}, ',
                                            style: TextStyle(
                                              fontSize: width * 0.0365,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.0085),
                                  Text(
                                    e['location'],
                                    style: TextStyle(
                                      fontSize: width * 0.033,
                                      color:
                                          Colors.grey.shade600.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  buildRightCard(
                                      Colors.green.shade800,
                                      'DELIVERY',
                                      '${e['ratings']}',
                                      Icon(
                                        Icons.star,
                                        size: width * 0.035,
                                        color: Colors.white,
                                      )),
                                  SizedBox(height: height * 0.0055),
                                  buildRightCard(
                                    Colors.red.shade900,
                                    'PHOTO',
                                    '1',
                                    const SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.all(width * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: TabBar(
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontSize: width * 0.043,
                          letterSpacing: 1.7,
                        ),
                        indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: const [
                          Tab(
                            text: 'DELIVERY',
                          ),
                          Tab(
                            text: 'REVIEWS',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                body: const TabBarView(
                  children: [
                    DeliveryTab(),
                    ReviewTab(),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildRightCard(Color color, String name, int, Widget iconWidget) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.022),
      width: width * 0.22,
      height: width * 0.127,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                int,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.034,
                  color: Colors.white,
                ),
              ),
              iconWidget
            ],
          ),
          SizedBox(height: height * 0.002),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.027,
            ),
          ),
        ],
      ),
    );
  }

  Widget builtAppbar() {
    double width = MediaQuery.of(context).size.width;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      actions: [
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: Colors.black,
                      size: width * 0.07,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
