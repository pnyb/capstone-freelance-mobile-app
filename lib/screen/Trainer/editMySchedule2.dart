import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';

class editMySchedule extends StatefulWidget {
  final List<String> startTime;
  final List<String> endTime;
  final String profileId;
  final String trainerEmail;
  const editMySchedule({
    required this.startTime,
    required this.endTime,
    required this.profileId,
    required this.trainerEmail,
    Key? key,
  });

  @override
  _editMyScheduleState createState() => _editMyScheduleState();
}

class _editMyScheduleState extends State<editMySchedule> {
  List<String> currentStartTime = [];
  List<String> currentEndTime = [];
  bool isloaded = false;
  @override
  void initState() {
    setState(() {
      for (int i = 0; i < widget.startTime.length; i++){
        currentStartTime.add(widget.startTime[i]);
      }
       for (int i = 0; i < widget.endTime.length; i++){
        currentEndTime.add(widget.endTime[i]);
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

  void deleteSchedule(int index) {
    if (currentStartTime.isNotEmpty) {
      setState(() {
        currentStartTime.removeAt(index);
      });
    }
    if (currentEndTime.isNotEmpty) {
      setState(() {
        currentEndTime.removeAt(index);
      });
    }
    
  }

 void addSchedule() {
    setState(() {
     currentStartTime.add("08:00");
      currentEndTime.add("18:00");
    });
  }

  Future<bool> _showDiscardDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Discard'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Are you sure you want to discard this information?',
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
            body: WillPopScope(
                  onWillPop: () {
                // Show the discard dialog
                final shouldDiscard = _showDiscardDialog(context);

                // Return true to allow navigation if 'Yes' is chosen in the dialog,
                // or return false to prevent navigation if 'No' is chosen.
                return shouldDiscard;
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Edit Working Hours",
                      //       style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 24,
                      //       color: Colors.black),
                      //     ),
                      //     SizedBox(width: 25,),

                         
                      //   ],
                      // ),
                      SizedBox(height: 15),

                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                           ElevatedButton(
                              onPressed: addSchedule,
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFDE683), // Set button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Set border radius
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20,),
                        
                      for (int i = 0; i < currentStartTime.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Start:'),

                            TimePickerTextField(
                              initialValue: currentStartTime[i],
                              onTimeChanged: (time) {
                                setState(() {
                                  currentStartTime[i] = time;
                                });
                              },
                            ),
                            SizedBox(width: 5,),
                            Text('-'),
                            SizedBox(width: 5,),
                            Text('End:'),
                         
                            TimePickerTextField(
                              initialValue: currentEndTime[i],
                              onTimeChanged: (time) {
                                setState(() {
                                  currentEndTime[i] = time;
                                });
                              },
                            ),
                           SizedBox(width: 15,),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          
                            color: Colors.red, // Change to your desired color
                          ),
                          child: IconButton(
                            onPressed: () {
                              deleteSchedule(i); // Call the function here
                            },
                            icon: Icon(Icons.delete, color: Colors.white, size: 14,), // You can change the icon color to white
                          ),
                        )

            
                              
       
                            
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Check for overlapping schedules
                            if (hasOverlap(currentStartTime, currentEndTime)) {
                              // Overlapping schedules, show a message
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Overlapping Schedules"),
                                    content: Text("Schedules should not overlap. Please try again."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // No overlapping schedules, update the schedule
                              final userData = FirebaseFirestore.instance.collection('Trainer Profile').doc(widget.profileId);
                              final data = {
                                'startTime': currentStartTime,
                                'endTime': currentEndTime,
                              };
                              userData.update(data);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TrainerPage(indexNo: 0),
                              ));
                            }
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
                              'Save',
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
