import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/reschedule1.dart';
import 'package:flutter/material.dart';

class ViewClass extends StatefulWidget {
  final String classId;
  const ViewClass({
    Key? key,
    required this.classId,
  });
  @override
  _ViewClassState createState() => _ViewClassState();
}

class _ViewClassState extends State<ViewClass> {
  Stream<List<ClientClass>> readClientClass() {
    return FirebaseFirestore.instance
        .collection('Client Class')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['id'].toString().contains(widget.classId))
            .map((doc) => ClientClass.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              'Schedule',
              style: TextStyle(
                color: Colors.white,
              ),
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
            } else if (snapshot.hasData) {
              final myClass = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 234, 234),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 400,
                      height: 550,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Container(
                                height: 125,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image.network(
                                  myClass.first.serviceBgPhoto,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 30),
                              child: Text(
                                "Service Name: ${myClass.first.serviceName}",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 30),
                              child: Text(
                                "Date of Purchase: ${formatDate(myClass.first.dateofPurchase)}",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      height: 50,
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 50,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Client",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(myClass.first.clientName,
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 50,
                                      width: 160,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            size: 50,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Level",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(myClass.first.serviceLevel,
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      height: 50,
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 50,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Date",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(myClass.first.scheduleDate,
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 50,
                                      width: 160,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            size: 50,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Time",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(
                                                  convertTo12HourFormat(myClass
                                                      .first.scheduleTime[0]),
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  fixedSize: Size(150, 40),
                                ),
                                onPressed: () {
                                  // Implement the purchase functionality here
                                },
                                child: Text(
                                  'Join',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
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

  Future<bool> _showCancelSession(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cancel Session'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Are you sure you want to cancel your session?',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'If you will cancel your session, you will have an automatic refund to your account. You can still reschedule a different date or time.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if 'No' is pressed
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true if 'Yes' is pressed
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Provide a default value of false
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return formattedDate;
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
