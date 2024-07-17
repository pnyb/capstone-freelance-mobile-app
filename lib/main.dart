import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flexedfitness/screen/landing.dart';
import 'package:flexedfitness/screen/loadingPage.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      title: 'Flexed Fitness',

      debugShowCheckedModeBanner:
          false, // Set debugShowCheckedModeBanner to false
      home: MainPage(),
    );
  }
}

//DEFENSED

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong'));
          } else if (snapshot.hasData) {
            return SplashScreenPage();
          } else {
            return LandingPage();
          }
        },
      ),
    );
  }
}
