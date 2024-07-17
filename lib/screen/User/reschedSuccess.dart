import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/login.dart';
import 'package:flexedfitness/screen/registration/registerTrainer2.dart';
import 'package:flexedfitness/screen/registration/registerUser2.dart';
import 'package:flutter/material.dart';

class SuccessResched extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Center(child: Image.asset('assets/images/yellowLogo.png')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/successPay.png'),
              const SizedBox(height: 10),
              const Text('You have rescheduled',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const Text('successfully!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Divider(
                indent: 80,
                endIndent: 80,
                color: Colors.black,
                thickness: 2,
              ),
              const SizedBox(height: 20),
              const Text('Train hard, stay strong, and live fit!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFDE683)),
                  textAlign: TextAlign.center),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => UserPage(
                              indexNo: 0,
                            )));
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFFDE683),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
