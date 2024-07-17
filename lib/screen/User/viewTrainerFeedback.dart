import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/feedback.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/reschedule1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/video_call.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class viewTrainerFB extends StatefulWidget {
  final String classId;
  const viewTrainerFB({
    Key? key,
    required this.classId,
  });
  @override
  _viewTrainerFBState createState() => _viewTrainerFBState();
}

class _viewTrainerFBState extends State<viewTrainerFB> {
 
  Stream<List<TrainerFeedback>> readTrainerFeedback() {
    return FirebaseFirestore.instance
        .collection('Trainer Feedback')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['classID'].toString().contains(widget.classId))
            .map((doc) => TrainerFeedback.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: StreamBuilder<List<TrainerFeedback>>(
          stream: readTrainerFeedback(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something Went Wrong');
            } else if (snapshot.hasData) {
              final _feedbacks = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 234, 234),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 400,
                      height: MediaQuery.sizeOf(context).height * .87,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            SizedBox(
                              height: 8,
                            ),

                            Center(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 12,),
                                child: Text(
                                  "TRAINER FEEDBACK",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                           
                            // SizedBox(
                            //   height: 8,
                            // ),

                            Center(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 8,),
                                child: Text(
                                  _feedbacks.first.serviceName + " - "  + _feedbacks.first.serviceLevel,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            //  SizedBox(
                            //   height: 8,
                            // ),

                            Center(
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 8,),
                                child: Text(
                                  convertTo12HourFormat(_feedbacks.first.dateFeedback.toDate().toString()),
                                  //_feedbacks.first.dateFeedback.toDate().toString(),
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                           
                            SizedBox(
                              height: 8,
                            ),


                            Divider(
                              thickness: 3,
                              color: Colors.black,
                              indent: 20,
                              endIndent: 20,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hi, " + _feedbacks.first.clientName + "!",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  Text("I hope this message finds you well on your fitness journey!",
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12,), textAlign: TextAlign.justify,
                                  ),
                                  
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Text("Your trainer, " + _feedbacks.first.trainerName + " , has provided some valuable feedback on your recent workouts. Here's a quick summary to help you stay informed and motivated:",
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12,), textAlign: TextAlign.justify,
                                  ),
                                ],
                              )
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            //CONSISTENCY 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Consistency",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:   RatingStars(rating: _feedbacks.first.consisRate),

                                  )
                                ],
                              )
                            ),
                            SizedBox(
                              height: 18,
                            ),

                            // FORM & TECHNIQUE
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Form & Technique",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:   RatingStars(rating: _feedbacks.first.formTechRate),
                                  )
                                  
                                ],
                              )
                            ),
                            SizedBox(
                              height: 18,
                            ),

                            //ENDURANCE 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Endurance",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:    RatingStars(rating: _feedbacks.first.enduRate),
                                  )
                                ],
                              )
                            ),
                            SizedBox(
                              height: 18,
                            ),

                            //BALANCE & STABILITY 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Balance & Stability",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:    RatingStars(rating: _feedbacks.first.balStabRate),
                                  )
                                ],
                              )
                            ),
                            SizedBox(
                              height: 18,
                            ),

                            //ADAPTABILITY 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Adaptability",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:   RatingStars(rating: _feedbacks.first.adaptRate),
                                  )
                                ],
                              )
                            ),
                            SizedBox(
                              height: 18,
                            ),

                            //COMMUNICATION 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35,),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Communication",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:  15),
                                    child:  RatingStars(rating: _feedbacks.first.commRate),
                                  )
                                ],
                              )
                            ),
                            
                             SizedBox(
                              height: 18,
                            ),

                            //COMMENT 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Here's the overall comment of your trainer:",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                   SizedBox(
                                    height: 10,
                                  ),
                                   Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white, 
                                          borderRadius: BorderRadius.circular(6.0)
                                        
                                        ),
                                        padding: const EdgeInsets.all(8.0), // Set your desired background color
                                        child: Text(
                                          _feedbacks.first.description,
                                          style: TextStyle(fontSize: 12,),
                                          textAlign: TextAlign.justify,
                                        ),

                                  ),
                                  )
                                  
                                ],
                              )
                            ),
                            
                          ]),
                    ),
                  ),
                ],
              );
            
             } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  String convertTo12HourFormat(String time24Hour) {
    String date = time24Hour.split(' ')[0];

    return date;
  }

}

class RatingStars extends StatelessWidget {
  final String rating; // Change the type to String

  RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    double doubleRating = double.tryParse(rating) ?? 0.0; // Convert the string to double
    int numberOfFullStars = doubleRating.floor(); // Get the integer part of the rating
    bool hasHalfStar = doubleRating - numberOfFullStars == 0.5; // Check for half-star

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          if (index < numberOfFullStars) {
            return Icon(Icons.star, color: Colors.amber, size: 30.0,);
          } else if (index == numberOfFullStars && hasHalfStar) {
            return Icon(Icons.star_half, color: Colors.amber, size: 30.0,);
          } else {
            return Icon(Icons.star_border, color: Colors.amber, size: 30.0,);
          }
        },
      ),
    );
  }
}

