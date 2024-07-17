import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/editMySchedule2.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flexedfitness/timePicker1.dart';
import 'package:flutter/material.dart';

class mySchedule extends StatefulWidget {
  final List<String> startTime;
  final List<String> endTime;
  final String profileId;
  final String trainerEmail;
  const mySchedule({
    required this.startTime,
    required this.endTime,
    required this.profileId,
    required this.trainerEmail,
    Key? key,
  });

  @override
  __myScheduleState createState() => __myScheduleState();
}

class __myScheduleState extends State<mySchedule> {
  List<String> currentStartTime = [];
  List<String> currentEndTime = [];
  bool isloaded = false;
  @override
  void initState() {
    setState(() {
      // Combine the start and end times into pairs for easier sorting
      List<Map<String, String>> timePairs = [];
      for (int i = 0; i < widget.startTime.length; i++) {
        timePairs.add({
          'start': widget.startTime[i],
          'end': widget.endTime[i],
        });
      }

      // Sort the list based on start times
      timePairs.sort((a, b) {
        return a['start']!.compareTo(b['start']!);
      });

      // Separate the sorted times back into start and end lists
      currentStartTime = [];
      currentEndTime = [];
      for (int i = 0; i < timePairs.length; i++) {
        currentStartTime.add(timePairs[i]['start']!);
        currentEndTime.add(timePairs[i]['end']!);
      }

      isloaded = true;
    });

    super.initState();
  }

  // Function to check for overlapping schedules
  bool hasOverlap(List<String> startTimes, List<String> endTimes) {
    for (int i = 0; i < startTimes.length; i++) {
      for (int j = i + 1; j < startTimes.length; j++) {
        if (DateTime.parse("2000-01-01 " + startTimes[j])
                .isBefore(DateTime.parse("2000-01-01 " + endTimes[i])) &&
            DateTime.parse("2000-01-01 " + endTimes[j])
                .isAfter(DateTime.parse("2000-01-01 " + startTimes[i]))) {
          return true;
        }
      }
    }
    return false;
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
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Center(
                        child: Text(
                      "Working Hours",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    )),
                    SizedBox(height: 20),
                    for (int i = 0; i < currentStartTime.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Start:'),
                            SizedBox(width: 10),
                            TimePickerTextField1(
                              initialValue: currentStartTime[i],
                              onTimeChanged: (time) {
                                setState(() {
                                  currentStartTime[i] = time;
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            Text('-'),
                            SizedBox(width: 10),
                            Text('End:'),
                            SizedBox(width: 10),
                            TimePickerTextField1(
                              initialValue: currentEndTime[i],
                              onTimeChanged: (time) {
                                setState(() {
                                  currentEndTime[i] = time;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => editMySchedule(
                                startTime: widget.startTime,
                                endTime: widget.endTime,
                                profileId: widget.profileId,
                                trainerEmail: widget.trainerEmail,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFDE683), // Set button background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Set border radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30,15,30,15),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                    
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
