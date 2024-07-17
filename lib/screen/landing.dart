import 'package:flexedfitness/screen/login.dart';
import 'package:flexedfitness/screen/registration/registerTrainer2.dart';
import 'package:flexedfitness/screen/registration/registerUser2.dart';
import 'package:flexedfitness/trainerIntro.dart';
import 'package:flexedfitness/userIntro.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Image.asset(
                        'assets/images/premium.png',
                        width: 220,
                        height: 100,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Stronger ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'everyday',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          ', ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Join us ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'right away',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  color: Colors.white,
                  child: Container(
                    height: 300,
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/trainer.png'),
                        SizedBox(height: 15), // Replace with your image asset
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            height: 50,
                            color: Colors.white,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button press
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TrainerIntroPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFDE683),
                              ),
                              child: Text(
                                //USER WANTS REGISTER AS TRAINER
                                'I WILL TRAIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  color: Colors.white,
                  child: Container(
                    height: 300,
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/user.png'),
                        SizedBox(height: 15), // Replace with your image asset
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            height: 50,
                            color: Colors.white,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button press
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UserIntroPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFDE683),
                              ),
                              child: Text(
                                //USER WANTS REGISTER AS CLIENT
                                'I WILL HIRE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFFDE683),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Add your sign-in logic here
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
