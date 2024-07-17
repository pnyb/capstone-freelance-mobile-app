import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/schedule.dart';
import 'package:flexedfitness/screen/Trainer/trainerReviews.dart';
import 'package:flexedfitness/screen/Trainer/trainerServices.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TrainerDashboard extends StatefulWidget {
  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  final User user = FirebaseAuth.instance.currentUser!;
  final List<TrainerProfile> _profiles = [];
  bool isloaded = false;
  bool screenBuilt = false;
  final List<Account> _account = [];
  bool dialogShown = false;
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to logout on your account?',
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
                signOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

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
      });

      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress',
            isEqualTo: user.email) // Replace with the desired email address
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final account = Account.fromJson(doc.data());
        _account.add(account);
      });
      setState(() {
        isloaded = true;
      });
      // Move the print statement inside the then() block
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });

    // Check if there are classes for today and show a dialog

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenBuilt = true;
    return (isloaded == true)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/images/smallLogo.png',
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
            body: WillPopScope(
              onWillPop: () async {
                // Show the logout dialog when the back button is pressed
                _showLogoutDialog(context);

                // Prevent navigation
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      constraints: BoxConstraints(maxWidth: double.infinity),
                      color: Color(0xFF33363F),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Train in ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'confidence',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                ', ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'believe in ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'yourself',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                '.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    20))), // Set the desired color for the container
                            child: Image.network(
                              _profiles.first.profileImage,
                              width: 110,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              _profiles.first.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              _profiles.first.jobDescription,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'My Coins: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Image.asset(
                                  'assets/images/coin.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  _account.first.myCoins.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 1.5,
                      color: Colors.black,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrainerServicesScreen(
                                        name: _profiles.first.name,
                                      )));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 226, 226, 226),
                              ),
                              child: Center(
                                child: Text(
                                  'Services',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ), SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      TrainerPage(indexNo: 2)));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 226, 226, 226),
                              ),
                              child: Center(
                                child: Text(
                                  'Classes',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                    
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                     
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Schedule(
                                        startTime: _profiles.first.startTime,
                                        endTime: _profiles.first.endTime,
                                        profileId: _profiles.first.id,
                                        trainerEmail:
                                            _profiles.first.emailAddress,
                                      )));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 226, 226, 226),
                              ),
                              child: Center(
                                child: Text(
                                  'Calendar',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      TrainerReviewsScreen()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromARGB(255, 226, 226, 226),
                              ),
                              child: Center(
                                child: Text(
                                  'Reviews',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                    
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

  Widget buildBox(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.solidHeart, size: 40),
            SizedBox(height: 4.0),
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool isScreenUsed() {
    return screenBuilt;
  }

  Future<void> checkClassesForToday() async {
    if (dialogShown || !isScreenUsed()) {
      return; // Return early if a dialog has already been shown
    }

    final formattedSelectedDay = DateFormat('MMMM d, y').format(DateTime.now());
    final filteredClasses = await FirebaseFirestore.instance
        .collection('Client Class')
        .where('trainerEmail', isEqualTo: user.email)
        .where('scheduleDate', isEqualTo: formattedSelectedDay)
        .get();

    if (filteredClasses.docs.isNotEmpty) {
      setState(() {
        dialogShown = true; // Set the flag to true
      });

      // Show a dialog with the number of classes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Classes Update'),
            content: Text(
                'You have ${filteredClasses.docs.length} class(es) today.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        dialogShown = true; // Set the flag to true
      });

      // Show a dialog indicating no classes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Classes Update'),
            content: Text('There are no classes for today.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
