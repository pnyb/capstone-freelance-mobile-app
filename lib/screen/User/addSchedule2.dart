import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/User/purchaseReview.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class addSchedule2 extends StatefulWidget {
  final String serviceName;
  final String serviceHeader;
  final String serviceLevel;
  final String levelHeader;
  final String levelBody;
  final String sessionDuration;
  final String numberOfExercise;
  final String ongoingSupport;
  final String coaching;
  final String serviceId;
  final String trainerEmail;
  final String clientEmail;
  final String trainerName;
  final String serviceBgImage;
  final String serviceAmount;
  final bool isDietPlan;
  final bool isProgressTrack;
  final String dietPlanAmount;
  final String progressTrackAmount;
  final String date;
  final List<String> timeslots;

  const addSchedule2({
    Key? key,
    required this.serviceName,
    required this.serviceHeader,
    required this.serviceLevel,
    required this.levelHeader,
    required this.levelBody,
    required this.sessionDuration,
    required this.serviceId,
    required this.trainerName,
    required this.numberOfExercise,
    required this.trainerEmail,
    required this.clientEmail,
    required this.ongoingSupport,
    required this.coaching,
    required this.serviceBgImage,
    required this.serviceAmount,
    required this.isDietPlan,
    required this.isProgressTrack,
    required this.dietPlanAmount,
    required this.progressTrackAmount,
    required this.date,
    required this.timeslots,
  });

  @override
  _addSchedule2State createState() => _addSchedule2State();
}

class _addSchedule2State extends State<addSchedule2> {
  final List<ClientClass> _class = [];
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
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  bool isTimeBeforeCurrentTime(String timeString) {
    final currentTime = DateTime.now();
    final timeParts = timeString.split(':');
    final timeHour = int.parse(timeParts[0]);
    final timeMinute = int.parse(timeParts[1]);

    final timeDateTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, timeHour, timeMinute);

    // Convert widget.date (a string) to a DateTime object
    final selectedDate = DateFormat('MMMM d, y').parse(widget.date);

    if (currentTime.isBefore(selectedDate)) {
      // If the selected date is in the past, return true
      print("available all");
      return true;
    } else {
      print("checking if available");
      return currentTime.isBefore(timeDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isloaded == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Center(
                  child: Text(
                "Schedule a Session",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
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
                          Container(
                            width: 160,
                            child: Column(
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
                                //SizedBox(height: 5),
                                // Text(
                                //   widget.serviceHeader,
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.normal,
                                //     fontSize: 14,
                                //     color: Colors.black,
                                //   ),
                                // ),
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
                                ), SizedBox(height: 5),
                                Text(
                                  "Duration: ${widget.sessionDuration}",
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
                          // Check if the timeslot is available
                          // bool isTimeAvailable = !_class.any((client) =>
                          //     client.scheduleTime.any((timeSlot) =>
                          //         timeSlot.contains(widget.timeslots[index])));

                         bool isTimeAvailable = !_class.any((client) =>
                            client.scheduleTime.any((timeSlot) =>
                              timeSlot.contains(widget.timeslots[index]) &&
                              ((client.trainerEmail == widget.trainerEmail && client.userEmail == widget.clientEmail) ||
                                client.userEmail != widget.clientEmail)
                            )
                          );
                          
                          bool isBefore =
                              isTimeBeforeCurrentTime(widget.timeslots[index]);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 80,
                            ),
                            child: ElevatedButton(
                              onPressed: isTimeAvailable
                                  ? () {
                                      if (isBefore == true) {
                                        print(index);
                                        print(widget.timeslots.length);
                                        print(widget.sessionDuration);
                                        bool checkSessionDuration = false;

                                        if (widget.sessionDuration ==
                                            "30 mins") {
                                          setState(() {
                                            checkSessionDuration = true;
                                          });
                                        } else if (widget.sessionDuration ==
                                                "60 mins" &&
                                            (index + 1) <
                                                widget.timeslots.length) {
                                          bool isTimeAvailable = !_class.any(
                                              (client) => client.scheduleTime
                                                  .any((timeSlot) =>
                                                      timeSlot.contains(
                                                          widget.timeslots[
                                                              index + 1])));

                                          if (isTimeAvailable == true) {
                                            setState(() {
                                              checkSessionDuration = true;
                                            });
                                          } else {
                                            checkSessionDuration = false;
                                          }
                                        } else if (widget.sessionDuration ==
                                                "90 mins" &&
                                            (index + 2) <
                                                widget.timeslots.length) {
                                          bool isTimeAvailable = false;
                                          for (int i = 1; i < 3; i++) {
                                            isTimeAvailable = !_class.any(
                                                (client) => client.scheduleTime
                                                    .any((timeSlot) =>
                                                        timeSlot.contains(
                                                            widget.timeslots[
                                                                index + i])));
                                          }
                                          if (isTimeAvailable == true) {
                                            setState(() {
                                              checkSessionDuration = true;
                                            });
                                          } else {
                                            checkSessionDuration = false;
                                          }
                                        } else {
                                          checkSessionDuration = false;
                                        }

                                        print(checkSessionDuration);

                                        if (checkSessionDuration == true) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PurchaseReview(
                                                        serviceName:
                                                            widget.serviceName,
                                                        serviceBgImage: widget
                                                            .serviceBgImage,
                                                        trainerEmail:
                                                            widget.trainerEmail,
                                                        serviceLevel:
                                                            widget.serviceLevel,
                                                        trainerName:
                                                            widget.trainerName,
                                                        serviceHeader: widget
                                                            .serviceHeader,
                                                        serviceId:
                                                            widget.serviceId,
                                                        levelBody:
                                                            widget.levelBody,
                                                        levelHeader:
                                                            widget.levelHeader,
                                                        sessionDuration: widget
                                                            .sessionDuration,
                                                        numberOfExercise: widget
                                                            .numberOfExercise,
                                                        serviceAmount: widget
                                                            .serviceAmount,
                                                        ongoingSupport: widget
                                                            .ongoingSupport,
                                                        coaching:
                                                            widget.coaching,
                                                        isDietPlan:
                                                            widget.isDietPlan,
                                                        isProgressTrack: widget
                                                            .isProgressTrack,
                                                        date: widget.date,
                                                        time: widget
                                                            .timeslots[index],
                                                        dietPlanAmount: widget
                                                            .dietPlanAmount,
                                                        progressTrackAmount: widget
                                                            .progressTrackAmount,
                                                      )));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Invalid Session Duration'),
                                                content: Text(
                                                    'Session duration exceeds trainer schedule.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Invalid Schedule'),
                                              content: Text(
                                                  'The schedule you have chosen is currently not available'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(' Session Taken'),
                                            content: Text(
                                                'Session duration is already taken by other clients'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isTimeAvailable
                                    ? isBefore
                                        ? Colors.white
                                        : Colors.grey
                                    : Colors.grey,
                                foregroundColor: Colors.black,
                                side: BorderSide(width: 1, color: Colors.black),
                              ),
                              child: Text(
                                isTimeAvailable
                                    ? isBefore
                                        ? widget.timeslots[index]
                                        : "Session Over"
                                    : 'Not Available',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ))
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
