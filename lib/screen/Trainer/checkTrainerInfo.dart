import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/checkTrainerDeactivation.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/completeInfoTrainer.dart';
import 'package:flutter/material.dart';

class CheckTrainerAccount extends StatefulWidget {
  CheckTrainerAccount({Key? key}) : super(key: key);

  @override
  State<CheckTrainerAccount> createState() => _CheckTrainerAccountState();
}

class _CheckTrainerAccountState extends State<CheckTrainerAccount> {
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<TrainerProfile>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final account = snapshot.data!;
            if (account.isEmpty) {
              return CompleteInfoTrainer();
            } else {
              return CheckTrainerDeactivation();
            }
          }
          {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Stream<List<TrainerProfile>> readUser() {
    return FirebaseFirestore.instance
        .collection('Trainer Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['emailAddress'].toString().contains(user.email!))
            .map((doc) => TrainerProfile.fromJson(doc.data()))
            .toList());
  }
}
