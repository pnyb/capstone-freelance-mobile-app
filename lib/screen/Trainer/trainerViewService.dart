import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/review.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/reviewCard.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/trainerEditService.dart';
import 'package:flexedfitness/screen/User/ViewTrainer.dart';
import 'package:flutter/material.dart';

class TrainerViewServiceScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const TrainerViewServiceScreen({
    required this.serviceId,
    required this.serviceName,
    Key? key,
  });

  @override
  State<TrainerViewServiceScreen> createState() =>
      _TrainerViewServiceScreenState();
}

class _TrainerViewServiceScreenState extends State<TrainerViewServiceScreen>
    with TickerProviderStateMixin {
  final User user = FirebaseAuth.instance.currentUser!;
  final List<Services> _profiles = [];
  final List<TrainerProfile> _trainer = [];
  final List<UserReviews> _reviews = [];
  bool noImage = true;
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Services')
        .where('id', isEqualTo: widget.serviceId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Services.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          if (_profiles.first.imageUrls.isEmpty) {
            setState(() {
              noImage = false;
            });
          } else {
            setState(() {
              noImage = true;
            });
          }
        });
      });

      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('User Reviews')
        .where('trainerEmail', isEqualTo: user.email)
        .where('serviceName', isEqualTo: widget.serviceName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = UserReviews.fromJson(doc.data());
        _reviews.add(myOrder);
        print(_reviews.length);
      });

      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('Trainer Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = TrainerProfile.fromJson(doc.data());
        _trainer.add(myOrder);
        print(_trainer);
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
    TabController _tabcontroller = TabController(length: 3, vsync: this);
    return (isloaded)
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 40),
                  child: Text("Service Preview"),
                ),
              ),
              
              actions: [
                  TextButton(
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Color(0xFFFDE683),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => TrainerEditService(
                                name: _trainer.first.name,
                                serviceId: _profiles.first.id,
                              )));
                    },
                  ),
                ],
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              
            ),

            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Image.network(
                          _profiles.first.serviceBgPhoto,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    (noImage)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _profiles.first.imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Image.network(
                                      _profiles.first.imageUrls[index],
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        _profiles.first.serviceName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      thickness: 3,
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewTrainer(
                                  trainerEmail: _trainer.first.emailAddress,)));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 45,
                              height: 45,
                              child: Image.network(
                                _trainer.first.profileImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _trainer.first.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  _trainer.first.jobDescription,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 25),
                      child: Text(
                        _profiles.first.header,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, right: 25),
                      child: Text(
                        _profiles.first.body,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height:10),
                    Container(
                      color: Colors.white,
                      child: Align(
                        alignment: Alignment.center,
                        child: TabBar(
                          controller: _tabcontroller,
                          labelPadding: const EdgeInsets.only(
                              left: 20, right: 20, top: 0),
                          isScrollable: true,
                          indicatorColor: Colors.blue,
                          unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            Tab(text: 'Beginner'),
                            Tab(text: 'Intermediate'),
                            Tab(text: 'Advanced'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height/2,
                      child: TabBarView(
                        controller: _tabcontroller,
                        children: [
                          Container(
                            height: 320,
                            width: double.maxFinite,
                            child: (_profiles.first.isBeginner == true)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, top: 15, right: 25),
                                        child: Text(
                                          _profiles.first.beginnerHeader,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25,
                                            top: 10,
                                            right: 25,
                                            bottom: 10),
                                        child: Text(
                                          _profiles.first.beginnerBody,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                        indent: 25,
                                        endIndent: 25,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Session Duration",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles.first
                                                  .beginnerSessionDuration,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Number of exercise",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles
                                                  .first.beginnerNumExercise,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ongoing Support",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first
                                                        .beginnerOngoingSupp ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Coaching",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first.beginnerCoaching ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "Beginner Plan Not Available",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height/2,
                            width: double.maxFinite,
                            child: (_profiles.first.isIntermediate)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, top: 15, right: 25),
                                        child: Text(
                                          _profiles.first.intermediateHeader,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25,
                                            top: 10,
                                            right: 25,
                                            bottom: 10),
                                        child: Text(
                                          _profiles.first.intermediateBody,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                        indent: 25,
                                        endIndent: 25,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Session Duration",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles.first
                                                  .intermediateSessionDuration,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Number of exercise",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles.first
                                                  .intermediateNumExercise,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ongoing Support",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first
                                                        .intermediateOngoingSupp ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Coaching",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first
                                                        .intermediateCoaching ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "Intermediate Plan Not Available",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                          height: MediaQuery.of(context).size.height/2,
                            width: double.maxFinite,
                            child: (_profiles.first.isAdvanced)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, top: 15, right: 25),
                                        child: Text(
                                          _profiles.first.advancedHeader,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25,
                                            top: 10,
                                            right: 25,
                                            bottom: 10),
                                        child: Text(
                                          _profiles.first.advancedBody,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                        indent: 25,
                                        endIndent: 25,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Session Duration",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles.first
                                                  .advancedSessionDuration,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Number of exercise",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              _profiles
                                                  .first.advancedNumExercise,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ongoing Support",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first
                                                        .advancedOngoingSupp ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Coaching",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            (_profiles.first.advancedCoaching ==
                                                    "included")
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 30,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.remove_circle,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "Advanced Plan Not Available",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    (_reviews.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 25, top: 5),
                            child: Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    (_reviews.isNotEmpty)
                        ? SizedBox(
                            height: (_reviews.length > 5)
                                ? (_reviews.length / 2).ceil() * 140.0
                                : (_reviews.length / 2).ceil() * 165.0,
                            child: ListView.builder(
                              itemCount: _reviews.length,
                              itemBuilder: (context, index) {
                                return ReviewCard(
                                  serviceImageUrl: _reviews[index].serviceImage,
                                  clientName: _reviews[index].clientName,
                                  clientEmail: _reviews[index].userEmail,
                                  rating: double.parse(_reviews[index].rating),
                                  serviceName: _reviews[index].serviceName,
                                  date: _reviews[index]
                                      .dateReviewed
                                      .toDate()
                                      .toString(),
                                  reviewText: _reviews[index].description,
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 10)
                  ],
                ),
              ),
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

  Container _buildTableDataCellMiddle(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 1,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right: BorderSide(width: 1, color: Colors.black), // Add right border
          bottom: BorderSide.none, // Add bottom border
        ),
      ),
      child: Text(data),
    );
  }

  Container _buildTableDataCellLeft(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 1,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right: BorderSide.none, // Add right border
          bottom: BorderSide.none, // Add bottom border
        ),
      ),
      child: Text(data),
    );
  }

  Container _buildTableDataCellRight(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide.none, // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right: BorderSide(width: 1, color: Colors.black), // Add right border
          bottom: BorderSide.none, // Add bottom border
        ),
      ),
      child: Text(data),
    );
  }

  Container _buildTableDataCellBottom(String data) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 0.5,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right:
              BorderSide(width: 0.5, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: _buildPurchaseButton(data),
    );
  }

  Container _buildTableDataCellBottomLeft(String data) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 1,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right:
              BorderSide(width: 0.5, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: _buildPurchaseButton(data),
    );
  }

  Container _buildTableDataCellBottomRight(String data) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 0.5,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide.none, // Add top border
          right: BorderSide(width: 1, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: _buildPurchaseButton(data),
    );
  }

  Container _buildTableDataCellTop(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 0.5,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide(width: 1, color: Colors.black), // Add top border
          right:
              BorderSide(width: 0.5, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: Text(data, textAlign: TextAlign.center),
    );
  }

  Container _buildTableDataCellTopLeft(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 1,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide(width: 1, color: Colors.black), // Add top border
          right:
              BorderSide(width: 0.5, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: Text(
        data,
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _buildTableDataCellTopRight(String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 0.5,
              color:
                  Colors.black), // Remove the left border for the first column
          top: BorderSide(width: 1, color: Colors.black), // Add top border
          right: BorderSide(width: 1, color: Colors.black), // Add right border
          bottom:
              BorderSide(width: 1, color: Colors.black), // Add bottom border
        ),
      ),
      child: Text(data, textAlign: TextAlign.center),
    );
  }

  Widget _buildPurchaseButton(String price) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        fixedSize: Size(100, 35),
      ),
      onPressed: () {
        // Implement the purchase functionality here
      },
      child: Text(
        'Purchase',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final int rating;
  final double starSize;
  final Color starColor;
  final Color unratedStarColor;

  RatingWidget({
    required this.rating,
    this.starSize = 24.0,
    this.starColor = Colors.black,
    this.unratedStarColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(
            Icons.star,
            size: starSize,
            color: starColor,
          );
        } else {
          return Icon(
            Icons.star_border,
            size: starSize,
            color: unratedStarColor,
          );
        }
      }),
    );
  }
}
