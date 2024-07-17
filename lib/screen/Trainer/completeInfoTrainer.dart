import 'package:flexedfitness/screen/Trainer/completeProfile1.dart';
import 'package:flexedfitness/screen/registration/registerUser2.dart';
import 'package:flutter/material.dart';

class CompleteInfoTrainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(child: Image.asset('assets/images/yellowLogo.png')),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),
            Image.asset('assets/images/verified.png'),
            const SizedBox(height: 10),
            const Text('Thanks for signing up!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Divider(
              indent: 80,
              endIndent: 80,
              color: Colors.black,
              thickness: 2,
            ),
            const SizedBox(height: 15),
            const Text(
                'Once you’ve completed your profile, you’ll be able to start your fitness journey!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CompleteProfile1()));
                    },
                    child: Center(
                      child: Text(
                        'Complete your profile',
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
