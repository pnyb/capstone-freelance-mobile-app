import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/classSchedule.dart';
import 'package:flexedfitness/screen/Trainer/editMySchedule.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends StatefulWidget {
  final List<String> startTime;
  final List<String> endTime;
  final String profileId;
  final String trainerEmail;
  const Schedule({
    required this.startTime,
    required this.endTime,
    required this.profileId,
    required this.trainerEmail,
    Key? key,
  });

  @override
  __ScheduleState createState() => __ScheduleState();
}

class __ScheduleState extends State<Schedule> {
  final User user = FirebaseAuth.instance.currentUser!;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay = DateTime.now();
  final List<TrainerProfile> _trainerProfiles = [];
  bool isloaded = false;
  List<String> timeSlots = [];
  List<String?> clientNames = [];
  List<String> ids = [];

  Stream<List<ClientClass>> readClientClass() {
    return FirebaseFirestore.instance
        .collection('Client Class')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['trainerEmail'].toString().contains(user.email!))
            .map((doc) => ClientClass.fromJson(doc.data()))
            .toList());
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Trainer Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = TrainerProfile.fromJson(doc.data());
        _trainerProfiles.add(myOrder);
        print(_trainerProfiles);

        timeSlots.clear();
        List<Map<String, String>> scheduleList = [];

        // Iterate through each schedule and create a list of start and end times
        for (int i = 0; i < _trainerProfiles.first.startTime.length; i++) {
          scheduleList.add({
            'start': _trainerProfiles.first.startTime[i],
            'end': _trainerProfiles.first.endTime[i],
          });
        }

        // Sort the list based on start times
        scheduleList.sort((a, b) {
          return a['start']!.compareTo(b['start']!);
        });

        // Generate time slots for each sorted schedule
        for (int i = 0; i < scheduleList.length; i++) {
          DateTime startDateTime =
              DateTime.parse('2000-01-01 ${scheduleList[i]['start']}:00');
          DateTime endDateTime =
              DateTime.parse('2000-01-01 ${scheduleList[i]['end']}:00');

          while (startDateTime.isBefore(endDateTime)) {
            String formattedTime =
                '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
            timeSlots.add(formattedTime);
            startDateTime = startDateTime.add(Duration(minutes: 30));
          }
        }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Calendar Schedule',
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
            } else if (snapshot.hasData) {
              final myClass = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: timeSlots.length,
                      itemBuilder: (context, i) {
                        return FutureBuilder<String?>(
                          future: checkAppointmentAvailability(timeSlots[i]),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 45,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return SizedBox(
                                height: 45,
                                child: Center(
                                  child: Text("Error: ${snapshot.error}"),
                                ),
                              );
                            } else {
                              final String? clientName = snapshot.data;
                              print(clientName);

                              return SizedBox(
                                height: 45,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            timeSlots[i],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      (clientName != null)
                                          ? Text(
                                              clientName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              "Vacant",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  )
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

  Future<String?> checkAppointmentAvailability(String timeslot) async {
    final formattedSelectedDay = DateFormat('MMMM d, y').format(_selectedDay!);

    final filteredClasses = await FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail', isEqualTo: widget.trainerEmail)
        .where('scheduleDate', isEqualTo: formattedSelectedDay)
        .get();

    String clientName = "Vacant";

    if (filteredClasses.docs.isNotEmpty) {
      for (final doc in filteredClasses.docs) {
        final scheduleTimes = List<String>.from(doc['scheduleTime']);
        if (scheduleTimes.contains(timeslot)) {
          // If the timeslot is taken, set isAvailable to false and add client information
          clientName = doc['clientName'];
          ids.add(doc.id);
        }
      }
    }

    return clientName;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });

    // Fetch data from Firebase and generate time slots
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
