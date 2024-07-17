import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/User/addSchedule2.dart';
import 'package:flexedfitness/screen/User/purchaseReview.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class addSchedule1 extends StatefulWidget {
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

  const addSchedule1({
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
  });

  @override
  _addSchedule1State createState() => _addSchedule1State();
}

class _addSchedule1State extends State<addSchedule1> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> timeSlots = [];
  final List<TrainerProfile> _trainerProfiles = [];
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });

    // Fetch data from Firebase and generate time slots
    fetchTrainerProfile();
  }

  void fetchTrainerProfile() async {
    try {
      // Fetch the trainer profile based on the provided email

      FirebaseFirestore.instance
          .collection('Trainer Profile')
          .where('emailAddress', isEqualTo: widget.trainerEmail)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final myOrder = TrainerProfile.fromJson(doc.data());
          _trainerProfiles.add(myOrder);
          print(_trainerProfiles);
        });
      });

      if (_trainerProfiles.isNotEmpty) {
        generateTimeSlots(
            _trainerProfiles.first.startTime, _trainerProfiles.first.endTime);
      }
    } catch (e) {
      print('Error fetching trainer profile: $e');
    }
  }

  void generateTimeSlots(List<String> startTimes, List<String> endTimes) {
    // Clear the timeSlots list
    timeSlots.clear();

    // Iterate through each schedule
    for (int i = 0; i < startTimes.length; i++) {
      // Create a list to hold the time intervals
      List<TimeOfDay> timeIntervals = [];

      // Convert start and end times to DateTime objects with a fixed date
      List<DateTime> startDateTimeList = startTimes.map((time) {
        return DateTime.parse('2000-01-01 $time:00');
      }).toList();

      List<DateTime> endDateTimeList = endTimes.map((time) {
        return DateTime.parse('2000-01-01 $time:00');
      }).toList();

      // Combine start and end times into time intervals
      for (int i = 0; i < startDateTimeList.length; i++) {
        DateTime startTime = startDateTimeList[i];
        DateTime endTime = endDateTimeList[i];
        timeIntervals.add(TimeOfDay.fromDateTime(startTime));
        while (startTime.isBefore(endTime)) {
          // Calculate new time with 30 minutes added
          startTime = startTime.add(const Duration(minutes: 30));
          timeIntervals.add(TimeOfDay.fromDateTime(startTime));
        }
      }

      // Sort the time intervals
      timeIntervals.sort((a, b) {
        if (a.hour != b.hour) {
          return a.hour - b.hour;
        } else {
          return a.minute - b.minute;
        }
      });

      // Convert TimeOfDay objects back to formatted time strings
      timeSlots = timeIntervals.map((time) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }).toList();

      // Now, timeSlots contains the sorted time slots
      print(timeSlots);
    }

    // Once all schedules are processed, navigate to the next screen
    final formattedDate = DateFormat('MMMM d, y').format(_selectedDay!);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => addSchedule2(
        serviceName: widget.serviceName,
        serviceBgImage: widget.serviceBgImage,
        trainerEmail: widget.trainerEmail,
        clientEmail: widget.clientEmail,
        serviceLevel: widget.serviceLevel,
        trainerName: widget.trainerName,
        serviceHeader: widget.serviceHeader,
        serviceId: widget.serviceId,
        levelBody: widget.levelBody,
        levelHeader: widget.levelHeader,
        sessionDuration: widget.sessionDuration,
        numberOfExercise: widget.numberOfExercise,
        serviceAmount: widget.serviceAmount,
        ongoingSupport: widget.ongoingSupport,
        coaching: widget.coaching,
        isDietPlan: widget.isDietPlan,
        isProgressTrack: widget.isProgressTrack,
        date: formattedDate.toString(),
        timeslots: timeSlots,
        dietPlanAmount: widget.dietPlanAmount,
        progressTrackAmount: widget.progressTrackAmount,
      ),
    ));
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
            "Schedule a Session",
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
                      Container(
                        width: 150,
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
                            // SizedBox(height: 5),
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
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Duration: ${widget.sessionDuration}",
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
                    "Select a Day ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2030, 12, 31),
                  sixWeekMonthsEnforced: true,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month'
                  },
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}