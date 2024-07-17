import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/viewTask.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final User user = FirebaseAuth.instance.currentUser!;

  Stream<List<ClientClass>> readClientClass() {
    return FirebaseFirestore.instance
        .collection('Client Class')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['userEmail'].toString().contains(user.email!))
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['status:'].toString().contains("Ongoing"))
            .map((doc) => ClientClass.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Schedule',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<ClientClass>>(
            stream: readClientClass(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something Went Wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final myClass = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(myClass.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewTask(
                                classId: myClass[index].id,
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
                                    'assets/images/smallLogo.png',
                                    height: 60,
                                    width: 60,
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
                                            myClass[index].serviceName,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            " - ",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          Text(
                                            myClass[index].serviceLevel,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                     
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            myClass[index].scheduleDate,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            ": ",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          Text(
                                            convertTo12HourFormat(
                                                myClass[index].scheduleTime[0]),
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                       SizedBox(height: 3),
                                      Text(
                                        "View your Class Details",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic
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
              );
            } else {
            return Center(
              child: Text('No Upcoming Schedules'),
            );
            }
          }),
    );
  }

  String convertTo12HourFormat(String time24Hour) {
    int hour = int.parse(time24Hour.split(':')[0]);
    int minute = int.parse(time24Hour.split(':')[1]);

    String period = 'AM';

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }

    String hourStr = hour < 10 ? '0$hour' : hour.toString();
    String minuteStr = minute < 10 ? '0$minute' : minute.toString();

    return '$hourStr:$minuteStr $period';
  }
}
