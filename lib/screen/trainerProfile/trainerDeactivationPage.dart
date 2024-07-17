import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/landing.dart';
import 'package:flexedfitness/screen/loadingPage.dart';
import 'package:flutter/material.dart';

class TrainerDeactivationPage extends StatefulWidget {
  @override
  _TrainerDeactivationPageState createState() =>
      _TrainerDeactivationPageState();
}

class _TrainerDeactivationPageState extends State<TrainerDeactivationPage> {
  String email = "";
  String password = "";
  String trainerId = "";
  // Function to show a confirmation dialog
  Future<void> _showDeactivationConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deactivation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to deactivate your account?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                final userData = FirebaseFirestore.instance
                    .collection('Account Profile')
                    .doc(_profiles.first.id);

                final data = {'isDeactivated': true};
                userData.update(data);

                for (int i = 0; i < _trainerServices.length; i++) {
                  final serviceData = FirebaseFirestore.instance
                      .collection('Services')
                      .doc("Services-${_trainerServices[i].id}");

                  final services = {'isDeactivated': true};
                  serviceData.update(services);
                }

                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void getTrainerProfileCredentials() {
    FirebaseFirestore.instance
        .collection('Trainer Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = TrainerProfile.fromJson(doc.data());
        _trainerProfiles.add(myOrder);
        setState(() {
          trainerId = _trainerProfiles.first.id;
        });
      });

      // Move the print statement inside the then() block
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deactivation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                deleteUserAccountAndDocuments();
              },
            ),
          ],
        );
      },
    );
  }

  final User user = FirebaseAuth.instance.currentUser!;
  final List<Account> _profiles = [];
  final List<TrainerProfile> _trainerProfiles = [];
  final List<Services> _trainerServices = [];
  bool isloaded = false;
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

    FirebaseFirestore.instance
        .collection('Services')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myTrainer = Services.fromJson(doc.data());
        _trainerServices.add(myTrainer);
        print(_profiles);
        setState(() {
          email = _profiles.first.emailAddress;
          password = _profiles.first.password;
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
              backgroundColor: Colors.black,
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
              title: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Center(
                  child: Text(
                    'Deactivation and Deletion',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double
                        .infinity, // Set the container width to occupy the available space
                    child: Text(
                      "Deactivation or deleting your Flexed Fitness account",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double
                        .infinity, // Set the container width to occupy the available space
                    child: Text(
                      "If you want to temporarily close your account, you can deactivate it. If you want to permanently remove your data from Flexed Fitness, you can delete your account.",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDeactivationConfirmationDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 120,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deactivate Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: double
                                      .infinity, // Set the container width to occupy the available space
                                  child: Text(
                                    "Deactivating your account is reversible. Your profile won’t be shown on Flexed Fitness. You will be able to reactivate your account.",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 120,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: double
                                      .infinity, // Set the container width to occupy the available space
                                  child: Text(
                                    "Deleting your account is permanent and irreversible. You won’t be able to retrieve the files or information from your orders on Flexed Fitness.",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Future<void> deleteUserAccountAndDocuments() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Reauthenticate the user to ensure their session is valid
      AuthCredential credential;
      if (currentUser.email != null) {
        credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password, // Replace with the user's password
        );
      } else {
        // Handle other authentication methods if applicable
        return;
      }

      try {
        await currentUser.reauthenticateWithCredential(credential);
      } catch (error) {
        print('Error reauthenticating user: $error');
        return;
      }

      // Delete the document from Firestore
      try {
        await FirebaseFirestore.instance
            .collection('Account Profile')
            .doc(_profiles.first.id)
            .delete();
      } catch (error) {
        print('Error deleting document: $error');
        return;
      }

      try {
        await FirebaseFirestore.instance
            .collection('Trainer Profile')
            .doc("trainer-${_trainerProfiles.first.id}")
            .delete();
      } catch (error) {
        print('Error deleting document: $error');
        return;
      }

      for (int i = 0; i < _trainerServices.length; i++) {
        await FirebaseFirestore.instance
            .collection('Services')
            .doc("Services-${_trainerServices[i].id}")
            .delete();
      }

      // Delete the user account from Firebase Authentication
      try {
        await currentUser.delete();
      } catch (error) {
        print('Error deleting user account: $error');
        return;
      }

      Navigator.of(context)
        ..pushReplacement(
            MaterialPageRoute(builder: (context) => LandingPage()));
    }
  }
}
