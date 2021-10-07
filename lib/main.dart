import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomato/models/restaurant.dart';
import 'package:zomato/models/login_model.dart';
import 'package:zomato/pages/Homepage/homepage.dart';

import 'package:zomato/pages/Login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Country()),
        ChangeNotifierProvider(create: (_) => RestaurantDetail()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zomato',
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : const Homepage(),
      ),
    );
  }
}
