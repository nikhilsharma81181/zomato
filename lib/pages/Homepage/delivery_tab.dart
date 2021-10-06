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
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildKeyDetail(
                  Icons.delivery_dining,
                  'MODE',
                  'delivery',
                ),
                buildKeyDetail(
                  Icons.timer,
                  'TIME',
                  '35 mins',
                ),
                buildKeyDetail(
                  Icons.local_offer_outlined,
                  'OFFERS',
                  'no offers',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKeyDetail(IconData icon, String text1, text2) {
    double width = MediaQuery.of(context).size.width;
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
}
