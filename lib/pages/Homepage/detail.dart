import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zomato/models/restaurant.dart';
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
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String restaurantsId = context.watch<RestaurantDetail>().restaurantId;
    bool showMenu = context.watch<RestaurantDetail>().showMenu;
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
              child: Stack(
                children: [
                  NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      builtAppbar(),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(left: width * 0.025),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          color: Colors.grey.shade600
                                              .withOpacity(0.9),
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
                          margin: EdgeInsets.all(width * 0.027),
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
                    body: TabBarView(
                      children: [
                        DeliveryTab(
                          menu: e['menu'],
                        ),
                        const ReviewTab(),
                      ],
                    ),
                  ),
                  showMenu
                      ? Positioned.fill(
                          child: Container(
                            color: Colors.black12,
                          ),
                        )
                      : const Positioned(child: SizedBox()),
                  buildFloatingMenu(e),
                ],
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

  Widget buildFloatingMenu(Map<String, dynamic> e) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Map items = context.watch<CartItems>().items;
    return Positioned(
      bottom: width * 0.027,
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            browseMenuList(e),
            SizedBox(height: height * 0.017),
            browseMenuButton(),
            SizedBox(height: height * 0.017),
            if (items.isNotEmpty) floatingCartBar(),
          ],
        ),
      ),
    );
  }

  Widget floatingCartBar() {
    double width = MediaQuery.of(context).size.width;
    int quantity = context.watch<CartItems>().quantity;
    int totalPrice = context.watch<CartItems>().totalPrice;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.027),
        decoration: BoxDecoration(
            color: Colors.red[400], borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$quantity ITEMS',
                  style: TextStyle(
                    fontSize: width * 0.031,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: width * 0.018),
                RichText(
                  text: TextSpan(
                    text: '₹$totalPrice ',
                    style: TextStyle(
                      fontSize: width * 0.041,
                    ),
                    children: [
                      TextSpan(
                        text: '  plus taxes',
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'View Cart',
                  style: TextStyle(
                    fontSize: width * 0.047,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  size: width * 0.072,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget browseMenuButton() {
    double width = MediaQuery.of(context).size.width;
    bool showMenu = context.watch<RestaurantDetail>().showMenu;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        vertical: width * 0.025,
        horizontal: width * 0.047,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      height: width * 0.1,
      width: showMenu ? width * 0.24 : width * 0.427,
      child: RawMaterialButton(
        onPressed: () {
          if (showMenu) {
            context.read<RestaurantDetail>().getMenuState(false);
          } else {
            context.read<RestaurantDetail>().getMenuState(true);
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!showMenu)
                Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: width * 0.045,
                ),
              if (!showMenu) SizedBox(width: width * 0.02),
              !showMenu
                  ? Text(
                      'Browse Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.044,
                      ),
                      softWrap: true,
                    )
                  : Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.044,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget browseMenuList(Map<String, dynamic> e) {
    double width = MediaQuery.of(context).size.width;
    bool showMenu = context.watch<RestaurantDetail>().showMenu;
    return AnimatedContainer(
      height: showMenu ? width * 0.44 : 0,
      width: showMenu ? width * 0.5 : 0,
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.035, vertical: width * 0.02),
      decoration: BoxDecoration(
        borderRadius: showMenu
            ? BorderRadius.circular(10)
            : const BorderRadius.only(topLeft: Radius.circular(100)),
        color: Colors.white,
      ),
      child: showMenu
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: showMenu
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < e['menu'].length; i++)
                    GestureDetector(
                      onTap: () {
                        context.read<RestaurantDetail>().getIndex(i);
                        context.read<RestaurantDetail>().getMenuState(false);
                        timer = Timer.periodic(
                            const Duration(milliseconds: 500), (timer) {
                          context.read<RestaurantDetail>().scrollToItem();
                          timer.cancel();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: width * 0.037),
                        child: Text(
                          e['menu'][i],
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget buildRightCard(
      Color color, String name, String int, Widget iconWidget) {
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
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: const Color(0xFFfafafa),
      leading: const SizedBox(),
      expandedHeight: width * 0.15,
      collapsedHeight: width * 0.15,
      actions: [
        Container(
          padding: EdgeInsets.symmetric(vertical: width * 0.02),
          child: Row(
            children: [
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
          ),
        ),
      ],
    );
  }
}
