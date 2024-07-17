import 'package:flexedfitness/screen/checkAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (ctx) => CheckAccount())));

        print("LOADING PAGE");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/premium.png"),
                width: 300,
              ),
              SizedBox(height: 50),
              SpinKitFadingCircle(
                color: Colors.white,
                size: 40,
              )
            ],
          ),
        ));
  }
}
