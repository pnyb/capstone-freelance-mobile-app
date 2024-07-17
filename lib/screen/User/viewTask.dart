import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/reschedule1.dart';
import 'package:flexedfitness/screen/User/viewTrainerFeedback.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/video_call.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewTask extends StatefulWidget {
  final String classId;
  const ViewTask({
    Key? key,
    required this.classId,
  });
  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  String time = "";
  String endTime = "";
  String date = "";
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
      body: StreamBuilder<List<ClientClass>>(
          stream: readClientClass(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something Went Wrong');
            } else if (snapshot.hasData) {
              final myClass = snapshot.data!;

              time = myClass.first.scheduleTime[0];
              endTime = myClass
                  .first.scheduleTime[myClass.first.scheduleTime.length - 1];
              date = myClass.first.scheduleDate;
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
                                      height: 40,
                                      width: 145,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Trainer",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(myClass.first.trainer,
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 40,
                                      width: 110,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            size: 30,
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
                                                  overflow: TextOverflow.ellipsis,
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
                                      height: 40,
                                      width: 145,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 30,
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
                                              Flexible(
                                                child: Text(
                                                    myClass.first.scheduleDate,
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      height: 40,
                                      width: 110,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer,
                                            size: 30,
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
                                                      
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14))
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ), SizedBox(
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
                                      height: 40,
                                      width: 145,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.payment,
                                            size: 30,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Total",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Flexible(
                                                child: Text(
                                                    "PHP ${myClass.first.totalAmount}",
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                              )
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
                            (myClass.first.status == "Ongoing")
                                ? Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        fixedSize: Size(150, 40),
                                      ),
                                      onPressed: () {
                                        // Implement the purchase functionality here
                                        print(date);
                                        print(time);
                                        if (isTimeAfterCurrentTime(time) &&
                                            isDateToday(date)) {
                                          // The scheduled time is after the current time and it's today
                                          // Implement the purchase functionality here

                                          if (isTimeAfterClassTime(time)) {
                                            MyUtils.errorSnackBar(Icons.error,
                                                "Current session is already over");
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoCall(
                                                          isUser: true,
                                                          classId:
                                                              widget.classId,
                                                          email: myClass
                                                              .first.userEmail,
                                                        )));
                                          }
                                        } else {
                                          // The scheduled time is not after the current time or it's not today
                                          // Handle the case where you can't join the class
                                          MyUtils.errorSnackBar(Icons.error,
                                              "Class schedule is not yet available");
                                        }
                                      },
                                      child: Text(
                                        'Join',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 15,
                            ),
                            (myClass.first.status == "Completed")
                                ? Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        fixedSize: Size(250, 50),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        viewTrainerFB(
                                                          classId:
                                                              widget.classId,
                                                        )));
                                      },
                                      child: Text(
                                        'VIEW FEEDBACK',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
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

  bool isTimeAfterCurrentTime(String time) {
    // Parse the current time
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    print(currentTime);

    // Parse the scheduled time
    final scheduledTime =
        int.parse(time.split(':')[0]) * 60 + int.parse(time.split(':')[1]);
    print(scheduledTime);

    if (scheduledTime < currentTime) {
      print("it is time");
    } else {
      print("is not time yet");
    }
    return scheduledTime < currentTime;
  }

  bool isTimeAfterClassTime(String time) {
    // Parse the current time
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    print(currentTime);

    // Parse the scheduled time
    final scheduledTime =
        int.parse(time.split(':')[0]) * 60 + int.parse(time.split(':')[1]);
    print(scheduledTime);

    if (scheduledTime < currentTime) {
      print("it is time");
    } else {
      print("is not time yet");
    }
    return scheduledTime > currentTime;
  }

  bool isDateToday(String date) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d, y').format(now);

    print(formattedDate);
    if (date == formattedDate) {
      print("today");
    } else {
      print("not today");
    }
    return date == formattedDate;
  }
}
