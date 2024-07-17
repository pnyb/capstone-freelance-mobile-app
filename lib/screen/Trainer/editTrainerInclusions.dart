import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/screen/Trainer/trainerServices.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class editTrainerInclusions extends StatefulWidget {
  final String id;
  final String trainerId;
  final String trainer;
  final String emailAddress;
  final String serviceName;
  final String body;
  final String header;
  final String beginnerAmount;
  final String intermediateAmount;
  final String hardAmount;
  final bool isBeginner;
  final bool isIntermediate;
  final bool isAdvanced;
  final String beginnerHeader;
  final String intermediateHeader;
  final String advancedHeader;
  final String beginnerBody;
  final String intermediateBody;
  final String advancedBody;
  final String beginnerSessionDuration;
  final String beginnerCoaching;
  final String beginnerNumExercise;
  final String beginnerOngoingSupp;
  final String intermediateSessionDuration;
  final String intermediateCoaching;
  final String intermediateNumExercise;
  final String intermediateOngoingSupp;
  final String advancedSessionDuration;
  final String advancedCoaching;
  final String advancedNumExercise;
  final String advancedOngoingSupp;
  final bool isDietPlan;
  final bool isProgressTrack;
  final String dietPlanAmount;
  final String progressTrackAmount;
  final String serviceBgPhoto;
  final List<File> imagesUrl;

  const editTrainerInclusions({
    Key? key,
    required this.id,
    required this.trainerId,
    required this.trainer,
    required this.emailAddress,
    required this.serviceName,
    required this.body,
    required this.header,
    required this.beginnerAmount,
    required this.intermediateAmount,
    required this.hardAmount,
    required this.isBeginner,
    required this.isIntermediate,
    required this.isAdvanced,
    required this.beginnerHeader,
    required this.intermediateHeader,
    required this.advancedHeader,
    required this.beginnerBody,
    required this.intermediateBody,
    required this.advancedBody,
    required this.beginnerSessionDuration,
    required this.beginnerCoaching,
    required this.beginnerNumExercise,
    required this.beginnerOngoingSupp,
    required this.intermediateSessionDuration,
    required this.intermediateCoaching,
    required this.intermediateNumExercise,
    required this.intermediateOngoingSupp,
    required this.advancedSessionDuration,
    required this.advancedCoaching,
    required this.advancedNumExercise,
    required this.advancedOngoingSupp,
    required this.isDietPlan,
    required this.isProgressTrack,
    required this.dietPlanAmount,
    required this.progressTrackAmount,
    required this.serviceBgPhoto,
    required this.imagesUrl,
  });

  @override
  _editTrainerInclusionsState createState() => _editTrainerInclusionsState();
}

class _editTrainerInclusionsState extends State<editTrainerInclusions> {
  TextEditingController dietPlanAmount = TextEditingController();
  TextEditingController progressTrackAmount = TextEditingController();
  bool isDietPlan = false;
  bool isProgressTrack = false;
  List<String> imagesUrl = [];
  bool isloaded = false;
  var uuid = const Uuid();
  @override
  void initState() {
    isDietPlan = widget.isDietPlan;
    isProgressTrack = widget.isProgressTrack;
    if (widget.isDietPlan) {
      dietPlanAmount.text = widget.dietPlanAmount;
    }
    if (widget.isProgressTrack) {
      progressTrackAmount.text = widget.progressTrackAmount;
    }
    setState(() {
      isloaded = true;
    });

    super.initState();
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
                "Inclusions",
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add a Diet Plan",
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
                    ),
                    SizedBox(height: 15),
                    buildTextField('Amount', dietPlanAmount),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add a Progress Tracking",
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
                    ),
                    SizedBox(height: 15),
                    buildTextField('Amount', progressTrackAmount),
                    SizedBox(height: 60),
                    Center(
                      child: Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            for (int i = 0; i < widget.imagesUrl.length; i++) {
                              String _uid = uuid.v4();
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child(widget.emailAddress)
                                  .child(widget.serviceName)
                                  .child('Service Gallery Photos')
                                  .child('${_uid}.jpg');
                              await ref.putFile(widget.imagesUrl[i]!);
                              String newImageUrl = await ref.getDownloadURL();
                              imagesUrl.add(newImageUrl);
                            }

                            bool isFeatured = false;

                            if (isDietPlan == true && isProgressTrack == true) {
                              final userData = FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc("Services-${widget.id}");

                              final data = {
                                'id': widget.id,
                                'trainerId': widget.trainerId,
                                'trainer': widget.trainer,
                                'emailAddress': widget.emailAddress,
                                'serviceName': widget.serviceName,
                                'body': widget.body,
                                'header': widget.header,
                                'beginnerAmount': widget.beginnerAmount,
                                'intermediateAmount': widget.intermediateAmount,
                                'hardAmount': widget.hardAmount,
                                'isBeginner': widget.isBeginner,
                                'isIntermediate': widget.isIntermediate,
                                'isAdvanced': widget.isAdvanced,
                                'beginnerHeader': widget.beginnerHeader,
                                'beginnerBody': widget.beginnerBody,
                                'intermediateHeader': widget.intermediateHeader,
                                'intermediateBody': widget.intermediateBody,
                                'advancedHeader': widget.advancedHeader,
                                'advancedBody': widget.advancedBody,
                                'beginnerSessionDuration':
                                    widget.beginnerSessionDuration,
                                'beginnerCoaching': widget.beginnerCoaching,
                                'beginnerNumExercise':
                                    widget.beginnerNumExercise,
                                'beginnerOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'IntermediateSessionDuration':
                                    widget.intermediateSessionDuration,
                                'IntermediateCoaching':
                                    widget.intermediateCoaching,
                                'IntermediateNumExercise':
                                    widget.intermediateNumExercise,
                                'IntermediateOngoingSupp':
                                    widget.intermediateOngoingSupp,
                                'AdvancedSessionDuration':
                                    widget.advancedSessionDuration,
                                'AdvancedCoaching': widget.advancedCoaching,
                                'AdvancedNumExercise':
                                    widget.advancedNumExercise,
                                'AdvancedOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'serviceBgPhoto': widget.serviceBgPhoto,
                                'imageUrls': imagesUrl,
                                'dietPlan': isDietPlan,
                                'progressTrack': isProgressTrack,
                                'dietPlanAmount': dietPlanAmount.text,
                                'progressTrackAmount': progressTrackAmount.text,
                                'isFeatured': isFeatured,
                                'isDeactivated': false
                              };

                              userData.set(data);
                            } else if (isDietPlan == false &&
                                isProgressTrack == true) {
                              final userData = FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc("Services-${widget.id}");

                              final data = {
                                'id': widget.id,
                                'trainerId': widget.trainerId,
                                'trainer': widget.trainer,
                                'emailAddress': widget.emailAddress,
                                'serviceName': widget.serviceName,
                                'body': widget.body,
                                'header': widget.header,
                                'beginnerAmount': widget.beginnerAmount,
                                'intermediateAmount': widget.intermediateAmount,
                                'hardAmount': widget.hardAmount,
                                'isBeginner': widget.isBeginner,
                                'isIntermediate': widget.isIntermediate,
                                'isAdvanced': widget.isAdvanced,
                                'beginnerHeader': widget.beginnerHeader,
                                'beginnerBody': widget.beginnerBody,
                                'intermediateHeader': widget.intermediateHeader,
                                'intermediateBody': widget.intermediateBody,
                                'advancedHeader': widget.advancedHeader,
                                'advancedBody': widget.advancedBody,
                                'beginnerSessionDuration':
                                    widget.beginnerSessionDuration,
                                'beginnerCoaching': widget.beginnerCoaching,
                                'beginnerNumExercise':
                                    widget.beginnerNumExercise,
                                'beginnerOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'IntermediateSessionDuration':
                                    widget.intermediateSessionDuration,
                                'IntermediateCoaching':
                                    widget.intermediateCoaching,
                                'IntermediateNumExercise':
                                    widget.intermediateNumExercise,
                                'IntermediateOngoingSupp':
                                    widget.intermediateOngoingSupp,
                                'AdvancedSessionDuration':
                                    widget.advancedSessionDuration,
                                'AdvancedCoaching': widget.advancedCoaching,
                                'AdvancedNumExercise':
                                    widget.advancedNumExercise,
                                'AdvancedOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'serviceBgPhoto': widget.serviceBgPhoto,
                                'imageUrls': imagesUrl,
                                'dietPlan': isDietPlan,
                                'progressTrack': isProgressTrack,
                                'dietPlanAmount': "",
                                'progressTrackAmount': progressTrackAmount.text,
                                'isFeatured': isFeatured,
                                'isDeactivated': false
                              };

                              userData.set(data);
                            } else if (isDietPlan == true &&
                                isProgressTrack == false) {
                              final userData = FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc("Services-${widget.id}");

                              final data = {
                                'id': widget.id,
                                'trainerId': widget.trainerId,
                                'trainer': widget.trainer,
                                'emailAddress': widget.emailAddress,
                                'serviceName': widget.serviceName,
                                'body': widget.body,
                                'header': widget.header,
                                'beginnerAmount': widget.beginnerAmount,
                                'intermediateAmount': widget.intermediateAmount,
                                'hardAmount': widget.hardAmount,
                                'isBeginner': widget.isBeginner,
                                'isIntermediate': widget.isIntermediate,
                                'isAdvanced': widget.isAdvanced,
                                'beginnerHeader': widget.beginnerHeader,
                                'beginnerBody': widget.beginnerBody,
                                'intermediateHeader': widget.intermediateHeader,
                                'intermediateBody': widget.intermediateBody,
                                'advancedHeader': widget.advancedHeader,
                                'advancedBody': widget.advancedBody,
                                'beginnerSessionDuration':
                                    widget.beginnerSessionDuration,
                                'beginnerCoaching': widget.beginnerCoaching,
                                'beginnerNumExercise':
                                    widget.beginnerNumExercise,
                                'beginnerOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'IntermediateSessionDuration':
                                    widget.intermediateSessionDuration,
                                'IntermediateCoaching':
                                    widget.intermediateCoaching,
                                'IntermediateNumExercise':
                                    widget.intermediateNumExercise,
                                'IntermediateOngoingSupp':
                                    widget.intermediateOngoingSupp,
                                'AdvancedSessionDuration':
                                    widget.advancedSessionDuration,
                                'AdvancedCoaching': widget.advancedCoaching,
                                'AdvancedNumExercise':
                                    widget.advancedNumExercise,
                                'AdvancedOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'serviceBgPhoto': widget.serviceBgPhoto,
                                'imageUrls': imagesUrl,
                                'dietPlan': isDietPlan,
                                'progressTrack': isProgressTrack,
                                'dietPlanAmount': dietPlanAmount.text,
                                'progressTrackAmount': "",
                                'isFeatured': isFeatured,
                                'isDeactivated': false
                              };

                              userData.set(data);
                            } else if (isDietPlan == false &&
                                isProgressTrack == false) {
                              final userData = FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc("Services-${widget.id}");

                              final data = {
                                'id': widget.id,
                                'trainerId': widget.trainerId,
                                'trainer': widget.trainer,
                                'emailAddress': widget.emailAddress,
                                'serviceName': widget.serviceName,
                                'body': widget.body,
                                'header': widget.header,
                                'beginnerAmount': widget.beginnerAmount,
                                'intermediateAmount': widget.intermediateAmount,
                                'hardAmount': widget.hardAmount,
                                'isBeginner': widget.isBeginner,
                                'isIntermediate': widget.isIntermediate,
                                'isAdvanced': widget.isAdvanced,
                                'beginnerHeader': widget.beginnerHeader,
                                'beginnerBody': widget.beginnerBody,
                                'intermediateHeader': widget.intermediateHeader,
                                'intermediateBody': widget.intermediateBody,
                                'advancedHeader': widget.advancedHeader,
                                'advancedBody': widget.advancedBody,
                                'beginnerSessionDuration':
                                    widget.beginnerSessionDuration,
                                'beginnerCoaching': widget.beginnerCoaching,
                                'beginnerNumExercise':
                                    widget.beginnerNumExercise,
                                'beginnerOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'IntermediateSessionDuration':
                                    widget.intermediateSessionDuration,
                                'IntermediateCoaching':
                                    widget.intermediateCoaching,
                                'IntermediateNumExercise':
                                    widget.intermediateNumExercise,
                                'IntermediateOngoingSupp':
                                    widget.intermediateOngoingSupp,
                                'AdvancedSessionDuration':
                                    widget.advancedSessionDuration,
                                'AdvancedCoaching': widget.advancedCoaching,
                                'AdvancedNumExercise':
                                    widget.advancedNumExercise,
                                'AdvancedOngoingSupp':
                                    widget.advancedOngoingSupp,
                                'serviceBgPhoto': widget.serviceBgPhoto,
                                'imageUrls': imagesUrl,
                                'dietPlan': isDietPlan,
                                'progressTrack': isProgressTrack,
                                'dietPlanAmount': "",
                                'progressTrackAmount': "",
                                'isFeatured': isFeatured,
                                'isDeactivated': false
                              };

                              userData.set(data);
                            }

                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => TrainerServicesScreen(
                                          name: widget.trainer,
                                        )));
                          },
                          child: Text(
                            'Update',
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

  buildTextField(String label, TextEditingController controller,
      {String hintText = ''}) {
    return Column(
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
        SizedBox(height: 2.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
