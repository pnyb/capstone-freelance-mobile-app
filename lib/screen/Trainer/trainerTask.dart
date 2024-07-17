import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/viewTask.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/video_call.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainerTaskPage extends StatefulWidget {
  @override
  _TrainerTaskPageState createState() => _TrainerTaskPageState();
}

class _TrainerTaskPageState extends State<TrainerTaskPage>
    with TickerProviderStateMixin {
  final User user = FirebaseAuth.instance.currentUser!;
  bool isloaded = false;
  final List<ClientClass> _scheduledClass = [];
  final List<ClientClass> _cancelledClass = [];
  final List<ClientClass> _completedClass = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail',
            isEqualTo: user.email) // Replace with the desired email address
        .where('status:', isEqualTo: "Completed")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final account = ClientClass.fromJson(doc.data());
        _completedClass.add(account);
      });
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });

    FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail',
            isEqualTo: user.email) // Replace with the desired email address
        .where('status:', isEqualTo: "Ongoing")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final account = ClientClass.fromJson(doc.data());
        _scheduledClass.add(account);
      });

      // Move the print statement inside the then() block
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });

    FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail',
            isEqualTo: user.email) // Replace with the desired email address
        .where('status:', isEqualTo: "Cancelled")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final account = ClientClass.fromJson(doc.data());
        _cancelledClass.add(account);
      });

      setState(() {
        isloaded = true;
        print(_scheduledClass.length);
        print(user.email);
      });
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabcontroller = TabController(length: 2, vsync: this);
    return (isloaded == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/images/smallLogo.png',
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
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Text(
                      "My Classes",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: TabBar(
                        controller: _tabcontroller,
                        labelPadding:
                            const EdgeInsets.only(left: 30, right: 30, top: 0),
                        isScrollable: true,
                        indicatorColor: Colors.blue,
                        unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'Scheduled'),
                          //Tab(text: 'Cancelled'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.maxFinite,
                    height: 500,
                    child: TabBarView(
                      controller: _tabcontroller,
                      children: [
                        _scheduledClassView("Scheduled"),
                       // _cancelledClassView("Cancelled"),
                        _completedClassView("Completed"),
                      ],
                    ),
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

  Widget _completedClassView(String level) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(_completedClass.length, (index) {
            ClientClass item = _completedClass[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: 400,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 226, 226, 226),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          item.serviceName,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "${item.clientName} purchased your service",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 40,
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Level",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.serviceLevel,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                                height: 40,
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Time",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            convertTo12HourFormat(
                                                item.scheduleTime[0]),
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 40,
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.scheduleDate,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  Widget _cancelledClassView(String level) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(_cancelledClass.length, (index) {
            ClientClass item = _cancelledClass[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: 400,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 226, 226, 226),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          item.serviceName,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "${item.clientName} purchased your service",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 40,
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Level",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.serviceLevel,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                                height: 40,
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Time",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            convertTo12HourFormat(
                                                item.scheduleTime[0]),
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 40,
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.scheduleDate,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  Widget _scheduledClassView(String level) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(_scheduledClass.length, (index) {
            ClientClass item = _scheduledClass[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: 400,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 226, 226, 226),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          item.serviceName,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Text(
                          "${item.clientName} purchased your service",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 40,
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Level",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.serviceLevel,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                                height: 40,
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Time",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            convertTo12HourFormat(
                                                item.scheduleTime[0]),
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 40,
                                width: 160,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Date",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.scheduleDate,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    )
                                  ],
                                )
                                
                                ),
                                GestureDetector(
                              onTap: () {
                                if (isTimeAfterCurrentTime(_scheduledClass
                                        .first.scheduleTime[0]) &&
                                    isDateToday(
                                        _scheduledClass.first.scheduleDate)) {
                                  // The scheduled time is after the current time and it's today
                                  // Implement the purchase functionality here
                                  if (_scheduledClass.first.status ==
                                      "Ongoing") {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => VideoCall(
                                                  isUser: false,
                                                  classId:
                                                      _scheduledClass.first.id,
                                                  email: _scheduledClass
                                                      .first.trainerEmail,
                                                )));
                                  } else {
                                    MyUtils.errorSnackBar(Icons.error,
                                        "This session is currently over");
                                  }
                                } else {
                                  // The scheduled time is not after the current time or it's not today
                                  // Handle the case where you can't join the class
                                  MyUtils.errorSnackBar(Icons.error,
                                      "Class schedule is not yet available");
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFFFDE683),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Join',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
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

  String convertTo12HourFormat(String time24Hour) {
    print(_scheduledClass.length);
    int hour = int.parse(time24Hour.split(':')[0]);
    int minute = int.parse(time24Hour.split(':')[1]);

    String period = 'AM';

    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }

    String hourStr = hour < 10 ? '$hour' : hour.toString();
    String minuteStr = minute < 10 ? '0$minute' : minute.toString();

    return '$hourStr:$minuteStr $period';
  }
}
