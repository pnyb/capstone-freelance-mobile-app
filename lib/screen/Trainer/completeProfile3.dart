import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/registration/registerTrainer1.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';

class CompleteProfile3 extends StatefulWidget {
  final String job;
  final String aboutMe;
  final String location;
  final List<String> skills;

  const CompleteProfile3({
    Key? key,
    required this.job,
    required this.aboutMe,
    required this.location,
    required this.skills,
  });

  @override
  _CompleteProfile3State createState() => _CompleteProfile3State();
}

class _CompleteProfile3State extends State<CompleteProfile3> {
  List<TextEditingController> yearStarted = [];
  List<TextEditingController> yeardEnded = [];
  List<TextEditingController> job = [];
  final List<Account> _profiles = [];
  final User user = FirebaseAuth.instance.currentUser!;

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

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
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
            "Complete your profile",
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
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: DropdownButton<String>(
                                      value: yearStartedList[
                                          i], // Set the selected value here
                                      onChanged: (newValue) {
                                        setState(() {
                                          yearStartedList[i] = newValue!;
                                          yearStarted[i].text = newValue;
                                        });
                                      },
                                      items: List.generate(31, (index) {
                                        // Generate dropdown items from 1990 to current year
                                        int year = DateTime.now().year - index;
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
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
                                        int year = DateTime.now().year - index;
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 14.0),
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
                        List<String> startTime = ["08:00"];
                          List<String> endTime = ["18:00"];

                        final userData = FirebaseFirestore.instance
                            .collection('Trainer Profile')
                            .doc("trainer-${uid}");

                        final data = {
                          'id': "trainer-${uid}",
                          'emailAddress': user?.email!,
                          "jobDescription": widget.job,
                          "location": widget.location,
                          "aboutMe": widget.aboutMe,
                          "skills": widget.skills,
                          'experiences': experiences,
                          "profileImage": _profiles.first.profileImage,
                          'startTime': startTime,
                          'endTime': endTime,
                          "name":
                              "${_profiles.first.firstName} ${_profiles.first.lastName}"
                        };
                        userData.set(data);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TrainerPage(indexNo: 0)));
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
        ));
  }
}
