import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zomato/models/restaurant.dart';

class DeliveryTab extends StatefulWidget {
  final List menu;
  const DeliveryTab({Key? key, required this.menu}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String restaurantId = context.watch<RestaurantDetail>().restaurantId;
    int menuIndex = context.watch<RestaurantDetail>().menuIndex;
    GlobalKey itemKey = context.watch<RestaurantDetail>().itemKey;
    CollectionReference dishRef = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantId)
        .collection('dishes');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MyDelegate1(width),
              floating: true,
              pinned: true,
            ),
            for (int i = 0; i < widget.menu.length; i++)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        key: i == menuIndex ? itemKey : null,
                        child: Text(
                          widget.menu[i],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.047,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      StreamBuilder(
                        stream: dishRef
                            .where('type', isEqualTo: widget.menu[i])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox();
                          }
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data!.docs
                                  .map((e) => buildDishes(e))
                                  .toList(),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(width * 0.035),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Report an issue with the menu',
                          style: TextStyle(
                            fontSize: width * 0.033,
                            color: Colors.red.shade400,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.red.shade400,
                          size: width * 0.047,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.032),
                    Text(
                      'Menu and prices are set directly by the restaurant.',
                      style: TextStyle(
                        fontSize: width * 0.033,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: height * 0.032),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildAddButton(String name, int price, qnty, bool veg) {
    double width = MediaQuery.of(context).size.width;
    Map items = context.watch<CartItems>().items;
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: width * 0.33,
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.02),
                width: width * 0.29,
                height: width * 0.09,
                decoration: BoxDecoration(
                  color: !items.containsKey(name)
                      ? const Color(0xFFffedf5)
                      : Colors.red[400],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 0.7,
                    color: Colors.pink.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: !items.containsKey(name)
                    ? GestureDetector(
                        onTap: () {
                          context
                              .read<CartItems>()
                              .addItem(name, price, qnty, veg);
                        },
                        child: Text(
                          'ADD',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (items.containsKey(name) &&
                                  items[name]['quantity'] <= 1) {
                                context.read<CartItems>().removeItem(name);
                              } else {
                                context
                                    .read<CartItems>()
                                    .decreaseQuantity(name);
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              size: width * 0.047,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            items[name]['quantity'] != null
                                ? items[name]['quantity'].toString()
                                : '1',
                            style: TextStyle(
                              fontSize: width * 0.044,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartItems>().increaseQuantity(name);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: width * 0.047,
                            ),
                          ),
                        ],
                      ),
              ),
              if (!items.containsKey(name))
                Positioned(
                  right: width * 0.012,
                  top: width * 0.01,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CartItems>().addItem(name, price, qnty, veg);
                      timer =
                          Timer.periodic(const Duration(milliseconds: 100), (timer) {
                        context.read<CartItems>().perItemTotal(name);
                        timer.cancel();
                      });
                    },
                    child: Icon(
                      Icons.add,
                      size: width * 0.043,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDishes(DocumentSnapshot e) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.05,
                    height: width * 0.05,
                    child: Image(
                      image: e['veg']
                          ? const AssetImage('assets/veg-img.png')
                          : const AssetImage('assets/non-veg-icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: width * 0.012),
                  Text(
                    e['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: width * 0.042,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: width * 0.005),
                  Text(
                    'In ${e['type']}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: width * 0.0324,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: width * 0.016),
                  Text(
                    '₹${e['price']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: width * 0.02),
                  Container(
                    padding: EdgeInsets.all(width * 0.003),
                    decoration: BoxDecoration(
                        color: Colors.amber.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          width: 0.05,
                          color: Colors.amber,
                        )),
                    child: RatingBarIndicator(
                      rating: e['rating'].toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: width * 0.031,
                      unratedColor: Colors.amber.withAlpha(50),
                    ),
                  ),
                  SizedBox(height: width * 0.016),
                  SizedBox(
                    width: width * 0.55,
                    height: width * 0.04,
                    child: Text(
                      e['des'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: width * 0.0328,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.33,
              height: width * 0.33,
              child: Stack(
                children: [
                  e['img'] != ''
                      ? Container(
                          width: width * 0.33,
                          height: width * 0.26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(e['img']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  buildAddButton(e['name'], e['price'], 1, e['veg']),
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}

class MyDelegate1 extends SliverPersistentHeaderDelegate {
  final _formKey = GlobalKey<FormState>();

  final double width;
  MyDelegate1(this.width);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xFFfafafa),
      child: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: width * 0.025,
                  horizontal: width * 0.045,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildKeyDetail(
                      Icons.delivery_dining,
                      'MODE',
                      'delivery',
                      width,
                    ),
                    buildKeyDetail(
                      Icons.timer,
                      'TIME',
                      '35 mins',
                      width,
                    ),
                    buildKeyDetail(
                      Icons.local_offer_outlined,
                      'OFFERS',
                      'no offers',
                      width,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(width * 0.03),
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.026, vertical: width * 0.02),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                child: Text(
                  '₹10 additional distance fee',
                  style: TextStyle(
                    fontSize: width * 0.035,
                  ),
                ),
              ),
              Container(
                height: width * 0.125,
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.027,
                  vertical: width * 0.012,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400.withOpacity(0.6),
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
                      'Search within the menu...',
                      style: TextStyle(
                        fontSize: width * 0.047,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: width * 0.001, bottom: width * 0.006),
                color: Colors.white,
                child: Row(
                  children: [
                    Switch.adaptive(
                      value: false,
                      onChanged: (value) {
                        value = true;
                      },
                    ),
                    Text(
                      'Veg',
                      style: TextStyle(fontSize: width * 0.041),
                    ),
                    SizedBox(
                      width: width * 0.032,
                    ),
                    Switch.adaptive(
                      value: false,
                      onChanged: (value) {
                        value = true;
                      },
                    ),
                    Text(
                      'Non-Veg',
                      style: TextStyle(fontSize: width * 0.041),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 0.7,
                color: Colors.grey.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKeyDetail(IconData icon, String text1, text2, double width) {
    return Row(
      children: [
        Container(
          width: width * 0.09,
          height: width * 0.09,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 1,
                spreadRadius: 1,
                offset: const Offset(0, 0.5),
              ),
            ],
            color: Colors.white,
          ),
          child: Icon(
            icon,
            size: width * 0.05,
          ),
        ),
        SizedBox(width: width * 0.025),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: width * 0.026, letterSpacing: 2.5),
            ),
            Text(
              text2,
              style: TextStyle(
                  fontSize: width * 0.03, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => width * 0.565;

  @override
  double get minExtent => width * 0.49;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
