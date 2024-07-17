import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/User/addCoins.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/userProfile/account.dart';
import 'package:flexedfitness/screen/userProfile/interest.dart';
import 'package:flexedfitness/screen/userProfile/preference.dart';
import 'package:flexedfitness/screen/userProfile/savedList.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 244, 215, 178),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15, left: 15),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      20))), // Set the desired color for the container
                              child: Image.network(
                                _profiles.first.profileImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _profiles.first.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  _profiles.first.emailAddress,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                
               
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AccountPage()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 25),
                      Icon(Icons.account_circle_outlined),
                      SizedBox(width: 25),
                      Text(
                        "Account",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ],
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
}
