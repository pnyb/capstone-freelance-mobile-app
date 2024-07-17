import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/screen/Trainer/schedule.dart';
import 'package:flexedfitness/screen/User/ViewService.dart';
import 'package:flexedfitness/screen/User/addCoins.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/viewTask.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Services> _services = [];
  final List<Account> _account = [];
  bool dialogShown = false;
  bool screenBuilt = false;
  final User user = FirebaseAuth.instance.currentUser!;
  bool isloaded = false;
  String classStatus = "All";
  final classStatuses = ['Ongoing', 'Completed', 'All'];

  Stream<List<ClientClass>> readClientClass() {
    if (classStatus == 'All') {
      return FirebaseFirestore.instance
          .collection('Client Class')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['userEmail'].toString().contains(user.email!))
              .map((doc) => ClientClass.fromJson(doc.data()))
              .toList());
    } else if (classStatus == 'Ongoing') {
      return FirebaseFirestore.instance
          .collection('Client Class')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['userEmail'].toString().contains(user.email!))
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['status:'].toString().contains("Ongoing"))
              .map((doc) => ClientClass.fromJson(doc.data()))
              .toList());
    } 
    // else if (classStatus == 'Cancelled') {
    //   return FirebaseFirestore.instance
    //       .collection('Client Class')
    //       .snapshots()
    //       .map((snapshot) => snapshot.docs
    //           .where((QueryDocumentSnapshot<Object?> element) =>
    //               element['userEmail'].toString().contains(user.email!))
    //           .where((QueryDocumentSnapshot<Object?> element) =>
    //               element['status:'].toString().contains("Cancelled"))
    //           .map((doc) => ClientClass.fromJson(doc.data()))
    //           .toList());
    // } 
    else {
      return FirebaseFirestore.instance
          .collection('Client Class')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['userEmail'].toString().contains(user.email!))
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['status:'].toString().contains("Completed"))
              .map((doc) => ClientClass.fromJson(doc.data()))
              .toList());
    }
  }

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
    checkClassStatus();
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
    FirebaseFirestore.instance
        .collection('Services')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final service = Services.fromJson(doc.data());
        _services.add(service);
      });
      // Move the print statement inside the then() block
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
              child: StreamBuilder<List<ClientClass>>(
                  stream: readClientClass(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something Went Wrong ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final myClass = snapshot.data!;
                      if (myClass.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 90,
                                constraints:
                                    BoxConstraints(maxWidth: double.infinity),
                                color: Color(0xFF33363F),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Stronger ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'everyday',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Join us ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'right away',
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
                                  ],
                                ),
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
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => addCoins(
                                                      accountId:
                                                          _account.first.id,
                                                      existingCoin: _account
                                                          .first.myCoins,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.yellow,
                                      ))
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'My Classes',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      width: 120,
                                      height: 30,
                                      padding: const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            value: classStatus,
                                            isExpanded: true,
                                            iconSize: 20,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                            items: classStatuses
                                                .map(buildMenuItems)
                                                .toList(),
                                            onChanged: (value) => setState(
                                                () => classStatus = value!)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: (myClass.length > 5)
                                    ? (myClass.length / 2).ceil() * 150.0
                                    : (myClass.length / 2).ceil() * 180.0,
                                child: GridView.builder(
                                  // physics:
                                  //     NeverScrollableScrollPhysics(), // Disable scrolling
                                  padding: EdgeInsets.all(20),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: myClass.length,
                                  itemBuilder: (context, index) {
                                    return buildMyClass(myClass[index]);
                                  },
                                ),
                              ),
                              Text(
                                'All Services',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: (_services.length / 2).ceil() * 160.0,
                                child: GridView.builder(
                                  // physics:
                                  //     NeverScrollableScrollPhysics(), // Disable scrolling
                                  
                                  padding: EdgeInsets.fromLTRB(20,20,20,5),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: _services.length,
                                  itemBuilder: (context, index) {
                                    return buildSearchItem(_services[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 90,
                                constraints:
                                    BoxConstraints(maxWidth: double.infinity),
                                color: Color(0xFF33363F),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Stronger ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'everyday',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Join us ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'right away',
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
                                  ],
                                ),
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
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => addCoins(
                                                      accountId:
                                                          _account.first.id,
                                                      existingCoin: _account
                                                          .first.myCoins,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.yellow,
                                      ))
                                ],
                              ),
                              SizedBox(height: 15),
                                  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      'All Services',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      width: 120,
                                      height: 30,
                                      padding: const EdgeInsets.only(left: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            value: classStatus,
                                            isExpanded: true,
                                            iconSize: 20,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ),
                                            items: classStatuses
                                                .map(buildMenuItems)
                                                .toList(),
                                            onChanged: (value) => setState(
                                                () => classStatus = value!)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: (_services.length / 2).ceil() * 160.0,
                                child: GridView.builder(
                                  // physics:
                                  //     NeverScrollableScrollPhysics(), // Disable scrolling
                                  padding: EdgeInsets.fromLTRB(20,20,20,5),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: _services.length,
                                  itemBuilder: (context, index) {
                                    return buildSearchItem(_services[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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

  Widget buildMyClass(ClientClass item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewTask(
                  classId: item.id,
                )));
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.network(
                  item.serviceBgPhoto,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '${item.serviceName}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Instructor: ${item.trainer}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                item.scheduleDate,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              height: 18,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.yellow, // Change to your desired background color
              ),
              child: Center(
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchItem(Services item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewServiceScreen(
                  serviceId: item.id,
                  trainerName: item.trainer,
                  clientEmail: _account.first.emailAddress,
                  serviceName: item.serviceName,
                )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.network(
              item.serviceBgPhoto,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '${item.serviceName}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Instructor: ${item.trainer}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (item.isBeginner == true &&
              item.isIntermediate == false &&
              item.isAdvanced == false)
            Text(
              "Beginner",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == true &&
              item.isIntermediate == true &&
              item.isAdvanced == false)
            Text(
              "Beginner - Intermediate",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == true &&
              item.isIntermediate == false &&
              item.isAdvanced == true)
            Text(
              "Beginner - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == true &&
              item.isAdvanced == false)
            Text(
              "Intermediate",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == true &&
              item.isAdvanced == true)
            Text(
              "Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == false &&
              item.isAdvanced == true)
            Text(
              "Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else
            Text(
              "Beginner - Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
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

  Future<void> checkClassStatus() async {
    final filteredClasses = await FirebaseFirestore.instance
        .collection('Client Class')
        .where('userEmail', isEqualTo: user.email)
        .get();

    if (filteredClasses.docs.isNotEmpty) {
      for (final doc in filteredClasses.docs) {
        final scheduleDate = doc['scheduleDate'];
        final scheduleTime = doc['scheduleTime'][0];

// Parse the scheduleDate and scheduleTime to a DateTime object
        final scheduleDateTime = DateFormat('MMMM d, y HH:mm')
            .parse('$scheduleDate ${scheduleTime}');

        if ((DateTime.now())
            .isAfter(scheduleDateTime.add(const Duration(minutes: 60)))) {
          // If the scheduleDate is before today, update the status to 'completed'

          print("Updated class status");
          await FirebaseFirestore.instance
              .collection('Client Class')
              .doc(doc.id)
              .update({'status:': 'Completed'});

          print("classes are passed due");
        } else {
          print("no classes are passed due");
        }
        // You can add more conditions as needed
      }
    }
  }

  bool isScreenUsed() {
    return screenBuilt;
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
      ));

  Future<void> checkClassesForToday() async {
    if (dialogShown || !isScreenUsed()) {
      return; // Return early if a dialog has already been shown
    }

    final formattedSelectedDay = DateFormat('MMMM d, y').format(DateTime.now());
    final filteredClasses = await FirebaseFirestore.instance
        .collection('Client Class')
        .where('userEmail', isEqualTo: user.email)
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
