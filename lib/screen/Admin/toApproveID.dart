import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/reschedule1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/video_call.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class toApproveID extends StatefulWidget {
  final String classId;
  const toApproveID({
    Key? key,
    required this.classId,
  });
  @override
  _toApproveIDState createState() => _toApproveIDState();
}

class _toApproveIDState extends State<toApproveID> {
  String time = "";
  String endTime = "";
  String date = "";
  Stream<List<Account>> readAccountProfile() {
    return FirebaseFirestore.instance
        .collection('Account Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['id'].toString().contains(widget.classId))
            .map((doc) => Account.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/images/yellowLogo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              actions: [],
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Account>>(
          stream: readAccountProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something Went Wrong');
            } else if (snapshot.hasData) {
              final myUsers = snapshot.data!;

            
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 234, 234),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 400,
                      height: 600,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Container(
                                height: 200,
                                width: 320,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image.network(
                                  myUsers.first.proofIdImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                             (myUsers.first.isIDApproved == false)
                                ? Center(
                                    child:  Padding(
                                      padding: const EdgeInsets.only(top: 12,),
                                      child: Text(
                                        "NOT VERIFIED",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child:  Padding(
                                      padding: const EdgeInsets.only(top: 12,),
                                      child: Text(
                                        "VERIFIED",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                           
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 3,
                              color: Colors.black,
                              indent: 20,
                              endIndent: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.supervised_user_circle_outlined,
                                          size: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Account Type", style: TextStyle(fontSize: 12)),
                                            Text(
                                              myUsers.first.accountType,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Name", style: TextStyle(fontSize: 12)),
                                            Text(
                                              myUsers.first.firstName + " " + myUsers.first.lastName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.email,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Email Address", style: TextStyle(fontSize: 12)),
                                              Text(
                                                myUsers.first.emailAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            (myUsers.first.isIDApproved == false)
                                ? Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        fixedSize: Size(200, 50),
                                      ),
                                      onPressed: () {
                                        // Implement the purchase functionality here
                                        final userData = FirebaseFirestore.instance
                                        .collection('Account Profile')
                                        .doc(myUsers.first.id);

                                        final data = {
                                            'isIDApproved': true,
                                            
                                          };
                                          userData.update(data);

                                      },
                                      child: Text(
                                        'VERIFY ID',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

}