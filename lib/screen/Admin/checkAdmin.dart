import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/Admin/bottomAdminNavigation.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/registration/emailVerification.dart';
import 'package:flutter/material.dart';

class CheckAdmin extends StatefulWidget {
  CheckAdmin({Key? key}) : super(key: key);

  @override
  State<CheckAdmin> createState() => _CheckAdminState();
}

class _CheckAdminState extends State<CheckAdmin> {
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Account>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Something Went Wrong: ${snapshot.hasError}'));
          } else {
            final account = snapshot.data!;
            print(account.first.accountType);
            if (account.first.isDeactivated == true) {
              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Your account was recently deactivated, Please email customer service for the reactivation of your account!',
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
                    Image.asset('assets/images/userIntro.png'),
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
                              signOut();
                            },
                            child: Center(
                              child: Text(
                                'Logout',
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
              );
            } else {
              return AdminPage(indexNo: 0);
            }
          }
        },
      ),
    );
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

  Stream<List<Account>> readUser() {
    return FirebaseFirestore.instance
        .collection('Account Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['emailAddress'].toString().contains(user.email!))
            .map((doc) => Account.fromJson(doc.data()))
            .toList());
  }
}
