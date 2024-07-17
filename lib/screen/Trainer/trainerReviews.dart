import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/review.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/reviewCard.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/classSchedule.dart';
import 'package:flexedfitness/screen/Trainer/editMySchedule.dart';
import 'package:flexedfitness/timePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainerReviewsScreen extends StatefulWidget {
  const TrainerReviewsScreen({
    Key? key,
  });

  @override
  _TrainerReviewsScreenState createState() => _TrainerReviewsScreenState();
}

class _TrainerReviewsScreenState extends State<TrainerReviewsScreen> {
  final User user = FirebaseAuth.instance.currentUser!;

  Stream<List<UserReviews>> readMyReviews() {
    return FirebaseFirestore.instance
        .collection('User Reviews')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['trainerEmail'].toString().contains(user.email!))
            .map((doc) => UserReviews.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'My Reviews',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<List<UserReviews>>(
          stream: readMyReviews(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something Went Wrong');
            } else if (snapshot.hasData) {
              final myClass = snapshot.data!;
              if (myClass.isNotEmpty) {
                return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: ListView.builder(
                      itemCount: myClass.length,
                      itemBuilder: (context, index) {
                        return ReviewCard(
                          serviceImageUrl: myClass[index].serviceImage,
                          clientName: myClass[index].clientName,
                          clientEmail: myClass[index].userEmail,
                          rating: double.parse(myClass[index].rating),
                          serviceName: myClass[index].serviceName,
                          date: myClass[index].dateReviewed.toDate().toString(),
                          reviewText: myClass[index].description,
                        );
                      },
                    ));
              } else {
                return Center(
                    child: Text("There are no reviews as of the moment."));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
