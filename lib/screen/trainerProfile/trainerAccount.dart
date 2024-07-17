import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/landing.dart';
import 'package:flexedfitness/screen/trainerProfile/editTrainerAccount.dart';
import 'package:flexedfitness/screen/trainerProfile/trainerDeactivationPage.dart';
import 'package:flexedfitness/screen/userProfile/deactivation.dart';
import 'package:flexedfitness/screen/userProfile/editUserAccount.dart';
import 'package:flutter/material.dart';

class TrainerAccountPage extends StatefulWidget {
  @override
  _TrainerAccountPageState createState() => _TrainerAccountPageState();
}

class _TrainerAccountPageState extends State<TrainerAccountPage> {
  final User user = FirebaseAuth.instance.currentUser!;
  final List<Account> _profiles = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          isloaded = true;
        });
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isloaded == true)
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: TextButton(
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Color(0xFFFDE683),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Center(
                  child: Text(
                    'Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Account Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          _profiles.first.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          _profiles.first.lastName,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Full name",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      _profiles.first.emailAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      _profiles.first.gender,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Gender",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      _profiles.first.dateOfBirth,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Birthdate",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      _profiles.first.contactNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Mobile Number",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Account Management",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TrainerDeactivationPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Text(
                          "Deactivation and Deletion",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 25),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditTrainerAccount()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Text(
                          "Edit Account Information",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 25),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  SizedBox(height: 50),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      signOut();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 25),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                )));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
