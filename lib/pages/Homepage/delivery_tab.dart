import 'package:flutter/material.dart';

class DeliveryTab extends StatefulWidget {
  const DeliveryTab({Key? key}) : super(key: key);

  @override
  _DeliveryTabState createState() => _DeliveryTabState();
}

class _DeliveryTabState extends State<DeliveryTab> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: MyDelegate1(width),
          floating: true,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            width: width,
            height: width * 2,
          ),
        ),
        
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
    return SingleChildScrollView(
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
  double get maxExtent => width * 0.55;

  @override
  double get minExtent => width * 0.49;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
