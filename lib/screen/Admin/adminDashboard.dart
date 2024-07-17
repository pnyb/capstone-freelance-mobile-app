import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/screen/Admin/toApproveID.dart';
import 'package:flexedfitness/screen/Trainer/schedule.dart';
import 'package:flexedfitness/screen/User/ViewService.dart';
import 'package:flexedfitness/screen/User/addCoins.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/viewTask.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class adminDashboard extends StatefulWidget {
  @override
  _adminDashboardState createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {

  bool dialogShown = false;
  bool screenBuilt = false;
  final User user = FirebaseAuth.instance.currentUser!;
  bool isloaded = false;

  Stream<List<Account>> readAccountProfile() {
    return FirebaseFirestore.instance
        .collection('Account Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['isIDApproved'].toString().contains("false"))
            .map((doc) => Account.fromJson(doc.data()))
            .toList());
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to logout on your account?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                signOut();
              },
            ),
          ],
        );
      },
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

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'PENDING',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Account>>(
            stream: readAccountProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something Went Wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final myUsers = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(myUsers.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => toApproveID(
                                classId: myUsers[index].id,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Image.asset(
                                     'assets/images/pendinglogo.png',
                                    height: 45,
                                    width: 45,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            myUsers[index].firstName + " " + myUsers[index].lastName,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                         
                                        ],
                                      ),
                                     
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            myUsers[index].emailAddress,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                       SizedBox(height: 3),
                                      Text(
                                        "ID NOT VERIFIED",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color:Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                            // Adjust the bottom padding
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
            } else {
            return Center(
              child: Text('No Pending Users'),
            );
            }
          }),
    );
  }
}
