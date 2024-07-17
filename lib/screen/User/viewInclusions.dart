import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/screen/Trainer/trainerServices.dart';
import 'package:flexedfitness/screen/User/addSchedule1.dart';
import 'package:flexedfitness/screen/User/purchaseReview.dart';
import 'package:flutter/material.dart';

class viewInclusions extends StatefulWidget {
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

  const viewInclusions({
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
  _viewInclusionsState createState() => _viewInclusionsState();
}

class _viewInclusionsState extends State<viewInclusions> {
  bool isDietPlan = false;
  bool isProgressTrack = false;
  List<String> imagesUrl = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Center(
              child: Text(
            "Inclusions",
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                //   child: Text(
                //       "Upgrade your experience with this optional inclusions.",
                //       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontStyle: FontStyle.italic),
                //     ),
                  
                //   ),
                SizedBox(height: 25),
                (widget.isDietPlan)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Diet Plan",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value:
                                  isDietPlan, // You can set the initial value here
                              onChanged: (bool? newValue) {
                                // Handle the checkbox state change here
                                setState(() {
                                  isDietPlan = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                (widget.isDietPlan) ? SizedBox(height: 15) : SizedBox.shrink(),
                (widget.isDietPlan)
                    ? buildTextField('Amount', widget.dietPlanAmount)
                    : SizedBox.shrink(),
                (widget.isDietPlan) ? SizedBox(height: 20) : SizedBox.shrink(),
                (widget.isProgressTrack)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress Tracking",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value:
                                  isProgressTrack, // You can set the initial value here
                              onChanged: (bool? newValue) {
                                // Handle the checkbox state change here
                                setState(() {
                                  isProgressTrack = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                (widget.isProgressTrack)
                    ? SizedBox(height: 15)
                    : SizedBox.shrink(),
                (widget.isProgressTrack)
                    ? buildTextField('Amount', widget.progressTrackAmount)
                    : SizedBox.shrink(),
                (widget.isProgressTrack)
                    ? SizedBox(height: 60)
                    : SizedBox.shrink(),
                Center(
                  child: Container(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => addSchedule1(
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
                                  isDietPlan: isDietPlan,
                                  isProgressTrack: isProgressTrack,
                                  dietPlanAmount: widget.dietPlanAmount,
                                  progressTrackAmount:
                                      widget.progressTrackAmount,
                                )));
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 222, 89, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  buildTextField(
    String label,
    String controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 15.0),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            controller,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
