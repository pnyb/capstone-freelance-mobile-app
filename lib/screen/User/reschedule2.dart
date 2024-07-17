import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/purchaseReview.dart';
import 'package:flexedfitness/screen/User/reschedSuccess.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class reschedule2 extends StatefulWidget {
  final String classId;
  final String serviceLevel;
  final String trainerName;
  final String serviceName;
  final String trainerEmail;
  final String sessionDuration;
  final String serviceBgImage;
  final String date;
  final List<String> timeslots;

  const reschedule2({
    Key? key,
    required this.classId,
    required this.serviceLevel,
    required this.trainerName,
    required this.serviceName,
    required this.trainerEmail,
    required this.sessionDuration,
    required this.serviceBgImage,
    required this.date,
    required this.timeslots,
  });

  @override
  _reschedule2State createState() => _reschedule2State();
}

class _reschedule2State extends State<reschedule2> {
  String time = "";
  int selectedButtonIndex = -1;
  final List<ClientClass> _class = [];
  List<String> timeSchedules = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail', isEqualTo: widget.trainerEmail)
        .where('scheduleDate', isEqualTo: widget.date)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = ClientClass.fromJson(doc.data());
        _class.add(myOrder);
      });
      setState(() {
        isloaded = true;
        print(_class.length);
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Center(
              child: Text(
            "Reschedule a Session",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 120,
                        height: 120,
                        child: Image.network(
                          widget.serviceBgImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Trainer: ${widget.trainerName}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Level: ${widget.serviceLevel}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Date: ${widget.date}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black, thickness: 2),
                SizedBox(height: 25),
                Center(
                  child: Text(
                    "Select a Time ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.timeslots.length,
                    itemBuilder: (context, index) {
                      bool isTimeAvailable = !_class.any((client) =>
                          client.scheduleTime.any((timeSlot) =>
                              timeSlot.contains(widget.timeslots[index])));

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                        ),
                        child: ElevatedButton(
                          onPressed: isTimeAvailable
                              ? () {
                                  setState(() {
                                    time = widget.timeslots[index];
                                    selectedButtonIndex = index;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTimeAvailable
                                ? (selectedButtonIndex == index)
                                    ? Colors.yellow
                                    : Colors.white
                                : Colors.grey, // Background color
                            foregroundColor: Colors.black, // Text color
                            side: BorderSide(
                                width: 1, color: Colors.black), // Border color
                          ),
                          child: Text(
                            isTimeAvailable
                                ? widget.timeslots[index]
                                : 'Not Available',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
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
                      calculateTimeSlots(time, widget.sessionDuration);
                      // Implement the purchase functionality here
                      final clientClass = FirebaseFirestore.instance
                          .collection('Client Class')
                          .doc(widget.classId);

                      final clientClassData = {
                        'scheduleTime': timeSchedules,
                        'scheduleDate': widget.date,
                        'scheduleTimestamp': Timestamp.now(),
                      };
                      clientClass.update(clientClassData);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SuccessResched()));
                    },
                    child: Text(
                      'Reschedule',
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
              ],
            ),
          ),
        ));
  }

  void calculateTimeSlots(String initialTime, String sessionDuration) {
    // Convert initial time to a DateTime object
    DateTime currentTime = DateFormat.Hm().parse(initialTime);
    timeSchedules.clear();

    // Add the initial time slot
    timeSchedules.add(DateFormat.Hm().format(currentTime));

    // Calculate the number of time slots based on session duration
    int slots = 0;
    if (sessionDuration == "60 mins") {
      slots = 1;
    } else if (sessionDuration == "90 mins") {
      slots = 2;
    }

    // Add additional time slots
    for (int i = 0; i < slots; i++) {
      currentTime = currentTime.add(Duration(minutes: 30));
      timeSchedules.add(DateFormat.Hm().format(currentTime));
    }
  }
}
