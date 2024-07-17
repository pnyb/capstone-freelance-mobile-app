import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/completeProfile3.dart';
import 'package:flexedfitness/screen/registration/registerTrainer1.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/trainerProfile/editTrainerProfile3.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

class EditProfile2 extends StatefulWidget {
  final String job;
  final String aboutMe;
  final String location;

  const EditProfile2({
    Key? key,
    required this.job,
    required this.aboutMe,
    required this.location,
  });

  @override
  _EditProfile2State createState() => _EditProfile2State();
}

class _EditProfile2State extends State<EditProfile2> {
  List<TextEditingController> skillControllers = [];

  void addSkill() {
    setState(() {
      skillControllers.add(TextEditingController());
    });
  }

  void deleteSkill() {
    if (skillControllers.isNotEmpty) {
      setState(() {
        skillControllers.removeLast();
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
          for (int i = 0; i < _profiles.first.skills.length; i++) {
            TextEditingController skill = TextEditingController();
            skill.text = _profiles.first.skills[i];
            skillControllers.add(skill);
          }
          isloaded = true;
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
                    "Complete your profile",
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
                                'Skills',
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
                        for (int i = 0; i < skillControllers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextField(
                                controller: skillControllers[i],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter a skill',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 14.0),
                                ),
                              ),
                            ),
                          ),
                        Center(
                          child: Container(
                            width: 350,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                List<String> skills = [];
                                for (var controller in skillControllers) {
                                  skills.add(controller.text);
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditProfile3(
                                          job: widget.job,
                                          aboutMe: widget.aboutMe,
                                          location: widget.location,
                                          skills: skills,
                                        )));
                              },
                              child: Text(
                                'Next',
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
