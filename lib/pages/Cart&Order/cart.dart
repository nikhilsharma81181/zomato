import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:zomato/models/restaurant.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var instructionsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            deliveryDetail(),
            cartDetail(),
            SizedBox(height: height * 0.015),
            greyBar(),
            offers(),
            SizedBox(height: height * 0.015),
            climateConscious(),
            greyBar(),
            SizedBox(height: height * 0.015),
            totalPrice(),
            greyBar(),
            addPersonalDetails(),
            greyBar(),
            SizedBox(height: height * 0.015),
            Container(
              padding: EdgeInsets.all(width * 0.035),
              child: Text(
                'Orders once placed cannot be cannot be cancelled and are non-refundable.',
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: height * 0.1),
          ],
        ),
      ),
      bottomSheet: Container(
        margin: EdgeInsets.all(width * 0.028),
        width: width,
        height: width * 0.142,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RawMaterialButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 1),
              Text(
                'Add person details',
                style: TextStyle(
                  fontSize: width * 0.052,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: width * 0.07,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPersonalDetails() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add personal details',
                style: TextStyle(
                  fontSize: width * 0.044,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order for someone else',
                    style: TextStyle(
                      fontSize: width * 0.044,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Send personalized message and e-card',
                    style: TextStyle(
                      fontSize: width * 0.034,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget totalPrice() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int totalPrice = context.watch<CartItems>().totalPrice;
    double taxes = totalPrice * 5 / 100;
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      height: height * 0.19,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item Total',
                style: TextStyle(
                  fontSize: width * 0.034,
                ),
              ),
              Text(
                '₹${totalPrice.toDouble()}0',
                style: TextStyle(
                  fontSize: width * 0.034,
                ),
              )
            ],
          ),
          indivisualFeild('Delivery Charge', '₹20.00'),
          indivisualFeild('Taxes', '₹${taxes}0'),
          indivisualFeild('Donate ₹1 to Feeding india', '₹1.00'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: width * 0.049,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                (totalPrice + taxes + 20 + 1).toString(),
                style: TextStyle(
                  fontSize: width * 0.049,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget indivisualFeild(String feildName, dynamic value) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          feildName,
          style: TextStyle(
            fontSize: width * 0.034,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: width * 0.034,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget climateConscious() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool sendCutlery = context.watch<CartItems>().sendCutlery;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Climate conscious delivery',
            style: TextStyle(
              fontSize: width * 0.046,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height * 0.012),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.dining_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: width * 0.02),
                    SizedBox(
                      width: width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Don\'t send cutlery, tissues and straws',
                            style: TextStyle(
                              fontSize: width * 0.036,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade600,
                            ),
                          ),
                          Text(
                            sendCutlery
                                ? 'Thanks you for caring about the environment!'
                                : 'If possible, opt in and help the environent.',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: sendCutlery,
                onChanged: (_) {
                  context.read<CartItems>().dsCutlery();
                },
                activeColor: Colors.green,
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              const Icon(
                Icons.park,
                color: Colors.green,
              ),
              SizedBox(width: width * 0.02),
              SizedBox(
                width: width * 0.77,
                child: Text(
                  'We fund environmental projects to offset the carbon footprint of our deliveries. Know more',
                  style: TextStyle(
                    fontSize: width * 0.034,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.012),
        ],
      ),
    );
  }

  Widget offers() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Offers',
            style: TextStyle(
              fontSize: width * 0.046,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height * 0.016),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    color: Colors.grey,
                    size: width * 0.055,
                  ),
                  SizedBox(width: width * 0.032),
                  Text(
                    'Selected a promo code',
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                'View offers',
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.007),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
          SizedBox(height: height * 0.007),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue.shade700,
                    size: width * 0.057,
                  ),
                  SizedBox(width: width * 0.032),
                  Text(
                    'FREE delivery applied!',
                    style: TextStyle(
                      fontSize: width * 0.036,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                '-₹35.00',
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.016),
        ],
      ),
    );
  }

  Widget greyBar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.015,
      color: Colors.grey.shade200,
    );
  }

  Widget cartDetail() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Map items = context.watch<CartItems>().items;
    List itemList = context.watch<CartItems>().itemList;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your cart  ',
                style: TextStyle(
                  fontSize: width * 0.048,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.shopping_bag, size: width * 0.06),
            ],
          ),
          SizedBox(height: width * 0.027),
          Container(
            width: width,
            padding: EdgeInsets.all(width * 0.025),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                width: 1.2,
                color: Colors.blue.shade700,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your total savings',
                  style: TextStyle(
                    fontSize: width * 0.041,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹55.00',
                  style: TextStyle(
                    fontSize: width * 0.041,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.027),
          for (var item in itemList)
            Container(
              padding: EdgeInsets.symmetric(vertical: width * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        height: width * 0.052,
                        width: width * 0.052,
                        image: items[item]['veg']
                            ? const AssetImage('assets/veg-img.png')
                            : const AssetImage('assets/non-veg-icon.png'),
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[item]['name'],
                            style: TextStyle(
                              fontSize: width * 0.037,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: width * 0.008),
                          Text(
                            '₹${items[item]['price']}',
                            style: TextStyle(
                              fontSize: width * 0.036,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(width * 0.02),
                        width: width * 0.24,
                        height: width * 0.08,
                        decoration: BoxDecoration(
                          color: const Color(0xFFffedf5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.7,
                            color: Colors.pink.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (items.containsKey(item) &&
                                    items[item]['quantity'] <= 1) {
                                  context.read<CartItems>().removeItem(item);
                                } else {
                                  context
                                      .read<CartItems>()
                                      .decreaseQuantity(item);
                                }
                              },
                              child: Icon(
                                Icons.remove,
                                size: width * 0.04,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              items[item]['quantity'].toString(),
                              style: TextStyle(
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<CartItems>()
                                    .increaseQuantity(item);
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.red,
                                size: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width * 0.012),
                      Text(
                        '₹${items[item]['totalPrice']}',
                        style: TextStyle(
                          fontSize: width * 0.036,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(height: height * 0.022),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (_) => addCookingInstruction(),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: width * 0.044,
                  color: Colors.grey,
                ),
                Text(
                  'Add cooking instruction (optional)',
                  style: TextStyle(
                    fontSize: width * 0.031,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget deliveryDetail() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width * 0.02),
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width * 0.06,
                    height: width * 0.08,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red[300],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: '  Delivery at ',
                      style: TextStyle(
                        fontSize: width * 0.036,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Loaction',
                          style: TextStyle(
                            fontSize: width * 0.036,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'Add',
                style: TextStyle(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.06,
                height: width * 0.08,
                child: Icon(
                  Icons.timer,
                  color: Colors.yellow.shade800,
                  size: width * 0.05,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '  Delivery in ',
                  style: TextStyle(
                    fontSize: width * 0.036,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '60 min',
                      style: TextStyle(
                        fontSize: width * 0.036,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    String restaurantName = context.watch<RestaurantDetail>().restaurantName;
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      leading: const SizedBox(),
      elevation: 0.32,
      backgroundColor: const Color(0xFFfafafa),
      actions: [
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: width * 0.12,
                      height: width,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: width * 0.051,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    restaurantName,
                    style: TextStyle(
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: Colors.grey[600],
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.015),
                    Text(
                      'Offers',
                      style: TextStyle(
                        fontSize: width * 0.041,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget addCookingInstruction() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width * 0.035),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Special cooking instuctions',
                style: TextStyle(fontSize: width * 0.046),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: width * 0.05,
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.05),
          TextFormField(
            controller: instructionsController,
            cursorColor: Colors.red,
            cursorWidth: 1.7,
            style: TextStyle(fontSize: width * 0.045),
            decoration: const InputDecoration(
              labelText: 'Add cooking instructions (optional)',
              floatingLabelStyle: TextStyle(color: Colors.red),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(height: width * 0.1),
          Text(
            'The restaurant will follow your instructions on the best effort basis. No refunds or cancellations will be processed based on failure to comply with requests for special instructions.',
            style:
                TextStyle(fontSize: width * 0.032, color: Colors.red.shade300),
          ),
          SizedBox(height: width * 0.1),
          Container(
            width: width,
            height: width * 0.145,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RawMaterialButton(
              onPressed: () {
                context
                    .read<CartItems>()
                    .addInstructions(instructionsController.text);
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: width * 0.047,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: width * 0.1),
        ],
      ),
    );
  }
}
