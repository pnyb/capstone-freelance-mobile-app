import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/registration/registerTrainer1.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';

class EditProfile3 extends StatefulWidget {
  final String job;
  final String aboutMe;
  final String location;
  final List<String> skills;

  const EditProfile3({
    Key? key,
    required this.job,
    required this.aboutMe,
    required this.location,
    required this.skills,
  });

  @override
  _EditProfile3State createState() => _EditProfile3State();
}

class _EditProfile3State extends State<EditProfile3> {
  List<TextEditingController> yearStarted = [];
  List<TextEditingController> yeardEnded = [];
  List<TextEditingController> job = [];
  String trainerName = "";
  List<String> yearStartedList = List.generate(5, (index) {
    int year = DateTime.now().year - index;
    return year.toString();
  });

  List<String> yearEndedList = List.generate(5, (index) {
    int year = DateTime.now().year - index;
    return year.toString();
  });

  void addSkill() {
    setState(() {
      yearStarted.add(TextEditingController());
      yeardEnded.add(TextEditingController());
      job.add(TextEditingController());
    });
  }

  void deleteSkill() {
    if (yearStarted.isNotEmpty) {
      setState(() {
        yearStarted.removeLast();
      });
    }
    if (yeardEnded.isNotEmpty) {
      setState(() {
        yeardEnded.removeLast();
      });
    }
    if (job.isNotEmpty) {
      setState(() {
        job.removeLast();
      });
    }
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

  final User user = FirebaseAuth.instance.currentUser!;
  final List<TrainerProfile> _profiles = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Trainer Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = TrainerProfile.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          trainerName = _profiles.first.name;
          for (int i = 0; i < _profiles.first.experiences.length; i++) {
            TextEditingController yearStartedData = TextEditingController();
            yearStartedData.text = _profiles.first.experiences[i].yearStarted;
            yearStarted.add(yearStartedData);

            TextEditingController yearEndedData = TextEditingController();
            yearEndedData.text = _profiles.first.experiences[i].yearEnded;
            yeardEnded.add(yearEndedData);

            TextEditingController jobData = TextEditingController();
            jobData.text = _profiles.first.experiences[i].job;
            job.add(jobData);
          }
          isloaded = true;
          print(_profiles.first.experiences.length);
          print(job.length);
        });
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isloaded == true)
        ? WillPopScope(
            onWillPop: () {
              // Show the discard dialog
              final shouldDiscard = _showDiscardDialog(context);

              // Return true to allow navigation if 'Yes' is chosen in the dialog,
              // or return false to prevent navigation if 'No' is chosen.
              return shouldDiscard;
            },
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black,
                  title: Center(
                      child: Text(
                    "edit your profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
                        SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Experiences',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: addSkill,
                                    icon: Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: deleteSkill,
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        for (int i = 0; i < job.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Year Started",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: DropdownButton<String>(
                                              value: yearStartedList[
                                                  i], // Set the selected value here
                                              onChanged: (newValue) {
                                                setState(() {
                                                  yearStartedList[i] =
                                                      newValue!;
                                                  yearStarted[i].text =
                                                      newValue;
                                                });
                                              },
                                              items: List.generate(31, (index) {
                                                // Generate dropdown items from 1990 to current year
                                                int year =
                                                    DateTime.now().year - index;
                                                return DropdownMenuItem<String>(
                                                  value: year.toString(),
                                                  child: Text(year.toString()),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      " - ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Year Ended",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: DropdownButton<String>(
                                              value: yearEndedList[
                                                  i], // Set the selected value here
                                              onChanged: (newValue) {
                                                setState(() {
                                                  yearEndedList[i] = newValue!;
                                                  yeardEnded[i].text = newValue;
                                                });
                                              },
                                              items: List.generate(31, (index) {
                                                // Generate dropdown items from 1990 to current year
                                                int year =
                                                    DateTime.now().year - index;
                                                return DropdownMenuItem<String>(
                                                  value: year.toString(),
                                                  child: Text(year.toString()),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextField(
                                    controller: job.isNotEmpty ? job[i] : null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Job or Company',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: 350,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;
                                String uid = "";
                                if (user != null) {
                                  uid = user.uid;
                                  print("User UID: $uid");
                                } else {
                                  print("User not signed in.");
                                }

                                List<Map<String, String>> experiences = [];

                                for (int i = 0; i < job.length; i++) {
                                  experiences.add({
                                    'yearStarted': yearStarted[i].text,
                                    'yearEnded': yeardEnded[i].text,
                                    'job': job[i].text,
                                  });
                                }

                                final userData = FirebaseFirestore.instance
                                    .collection('Trainer Profile')
                                    .doc("trainer-${uid}");

                                final data = {
                                  'id': "trainer-${uid}",
                                  'emailAddress': user?.email!,
                                  "jobDescription": widget.job,
                                  "location": widget.location,
                                  "aboutMe": widget.aboutMe,
                                  'name': trainerName,
                                  "skills": widget.skills,
                                  'experiences': experiences,
                                  "profileImage": _profiles.first.profileImage,
                                };
                                userData.update(data);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TrainerPage(indexNo: 3)));
                              },
                              child: Text(
                                'Save',
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
                )),
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
}
