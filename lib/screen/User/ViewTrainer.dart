import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/User/ViewService.dart';
import 'package:flutter/material.dart';

class ViewTrainer extends StatefulWidget {
  final String trainerEmail;
  const ViewTrainer({
    Key? key,
    required this.trainerEmail,
  });

  @override
  _ViewTrainerState createState() => _ViewTrainerState();
}

class _ViewTrainerState extends State<ViewTrainer> {
  final List<Account> _profiles = [];
  final List<TrainerProfile> _trainerProfiles = [];
  final List<Services> _service = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Trainer Profile')
        .where('emailAddress', isEqualTo: widget.trainerEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = TrainerProfile.fromJson(doc.data());
        _trainerProfiles.add(myOrder);
        print(_profiles);
      });

      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('Services')
        .where('emailAddress', isEqualTo: widget.trainerEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Services.fromJson(doc.data());
        _service.add(myOrder);
        print(_profiles);
        setState(() {});
      });

      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: widget.trainerEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
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
    return (isloaded == true)
        ? Scaffold(
            appBar: AppBar(
              leading: TextButton(
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Color(0xFFFDE683),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Center(
                  child: Text(
                    'Trainer Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _trainerProfiles.first.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 100),
                                child: Text(
                                  _trainerProfiles.first.jobDescription,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 229,
                            229), // Set the desired color for the container
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              20), // Circular border on top-left
                          topRight: Radius.circular(
                              20), // Circular border on top-right
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fixedSize: Size(120, 35),
                              ),
                              onPressed: () {
                                // Implement the purchase functionality here
                              },
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 170,
                                height: MediaQuery.of(context).size.height *
                                    0.35, // Adjust the height of the divider
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.work),
                                          SizedBox(width: 5),
                                          Text(
                                            _trainerProfiles
                                                .first.jobDescription,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 15),
                                      child: Row(
                                        children: [
                                          Icon(Icons.person),
                                          SizedBox(width: 5),
                                          Text(
                                            _profiles.first.gender,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                   Padding(
                                      padding: const EdgeInsets.only(left: 15, top: 15),
                                      child: Row(
                                        children: [
                                          Icon(Icons.pin_drop),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              _trainerProfiles.first.location,
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1, // Set maxLines to 1 to prevent multiple lines
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Text(
                                          "Ratings (5/5)",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    RatingWidget(
                                        rating: 5,
                                        starSize: 20,
                                        starColor: Colors.black,
                                        unratedStarColor: Colors.grey),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: MediaQuery.of(context).size.height *
                                    0.47, // Adjust the height of the divider
                                color: Colors.black,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5),
                                        child: Text(
                                          "About Me",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        child: Container(
                                          width: 215,
                                          child: Flexible(
                                            child: Text(
                                              _trainerProfiles.first.aboutMe,
                                              textAlign: TextAlign.justify,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        child: Text(
                                          "Skills",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.075,
                                        width: 215,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount: _trainerProfiles
                                              .first.skills.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.black,
                                                  size: 11,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  _trainerProfiles
                                                      .first.skills[index],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        child: Text(
                                          "Experiences",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width: 215,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(0),
                                          itemCount: _trainerProfiles
                                              .first.experiences.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.black,
                                                  size: 11,
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  width: 180,
                                                  child: Flexible(
                                                    child: Text(
                                                      "${_trainerProfiles.first.experiences[index].job}(${_trainerProfiles.first.experiences[index].yearStarted} - ${_trainerProfiles.first.experiences[index].yearEnded})",
                                                      softWrap: true,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 20, // Adjust the top padding
                            endIndent: 20, // Adjust the bottom padding
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  "Services",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      List.generate(_service.length, (index) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Image.network(
                                              _service[index].serviceBgPhoto,
                                              fit: BoxFit.fill,
                                              height: 80,
                                              width: 160,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            _service[index].serviceName,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Text(
                                          //   _service[index].header,
                                          //   softWrap: true,
                                          //   style: TextStyle(
                                          //     fontSize: 11,
                                          //     fontWeight: FontWeight.normal,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      // Add other widgets or content inside the container if needed
                    ),

                    // Add other widgets or content here
                  ],
                ),
                Positioned(
                  top: 5,
                  left: 20,
                  child: Container(
                    height: 125,
                    width: 125,

                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Image.network(
                      _profiles.first.profileImage,
                      width: 125,
                      height: 125,
                      fit: BoxFit.fill,
                    ),
                    // Set the desired color for the container
                  ),
                ),
              ],
            ),
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