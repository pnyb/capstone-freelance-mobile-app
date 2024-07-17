import 'package:flexedfitness/screen/Trainer/completeProfile3.dart';
import 'package:flexedfitness/screen/registration/registerTrainer1.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

class CompleteProfile2 extends StatefulWidget {
  final String job;
  final String aboutMe;
  final String location;

  const CompleteProfile2({
    Key? key,
    required this.job,
    required this.aboutMe,
    required this.location,
  });

  @override
  _CompleteProfile2State createState() => _CompleteProfile2State();
}

class _CompleteProfile2State extends State<CompleteProfile2> {
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                            builder: (context) => CompleteProfile3(
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
        ));
  }
}
