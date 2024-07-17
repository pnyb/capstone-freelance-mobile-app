import 'package:flexedfitness/screen/login.dart';
import 'package:flexedfitness/screen/registration/registerTrainer2.dart';
import 'package:flexedfitness/screen/registration/registerUser2.dart';
import 'package:flutter/material.dart';

class TrainerIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Inspire, Motivate, and Sculpt Lives from the Comfort of Your Own Space.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 15),
            Divider(
              indent: 50,
              endIndent: 50,
              color: Colors.black,
              thickness: 2,
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/trainerIntro.png'),
            Spacer(),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterTrainer2()));
                    },
                    child: Center(
                      child: Text(
                        'Next',
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
