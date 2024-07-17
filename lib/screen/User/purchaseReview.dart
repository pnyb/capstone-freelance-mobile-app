import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/User/suceessPayment.dart';
import 'package:flexedfitness/screen/landing.dart';
import 'package:flexedfitness/screen/userProfile/deactivation.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class PurchaseReview extends StatefulWidget {
  final String serviceName;
  final String serviceHeader;
  final String serviceLevel;
  final String levelHeader;
  final String levelBody;
  final String sessionDuration;
  final String numberOfExercise;
  final String ongoingSupport;
  final String coaching;
  final String serviceId;
  final String trainerEmail;
  final String trainerName;
  final String serviceBgImage;
  final String serviceAmount;
  final bool isDietPlan;
  final bool isProgressTrack;
  final String dietPlanAmount;
  final String progressTrackAmount;
  final String date;
  final String time;

  const PurchaseReview({
    Key? key,
    required this.serviceName,
    required this.serviceHeader,
    required this.serviceLevel,
    required this.levelHeader,
    required this.levelBody,
    required this.sessionDuration,
    required this.serviceId,
    required this.trainerName,
    required this.numberOfExercise,
    required this.trainerEmail,
    required this.ongoingSupport,
    required this.coaching,
    required this.serviceBgImage,
    required this.serviceAmount,
    required this.isDietPlan,
    required this.isProgressTrack,
    required this.dietPlanAmount,
    required this.progressTrackAmount,
    required this.date,
    required this.time,
  });

  @override
  _PurchaseReviewState createState() => _PurchaseReviewState();
}

class _PurchaseReviewState extends State<PurchaseReview> {
  String strFinalAmount = "";
  int finalAmount = 0;
  String selectedPaymentMethod = "Debit Card";
  var uuid = const Uuid();
  String _uid = "";
  Random random = Random();
  final User user = FirebaseAuth.instance.currentUser!;
  final List<Account> _profiles = [];
  final List<Account> _trainerProfiles = [];
  List<String> timeSchedules = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: widget.trainerEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _trainerProfiles.add(myOrder);
      });

      // Move the print statement inside the then() block
    });
    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        int intValue = int.tryParse(widget.serviceAmount) ?? 0;
        int dietValue = 0; // Use 0 if parsing fails
        int progressTrackValue = 0;
        if (widget.isDietPlan == true) {
          dietValue = int.tryParse(widget.dietPlanAmount) ?? 0;
        }
        if (widget.isProgressTrack == true) {
          progressTrackValue = int.tryParse(widget.progressTrackAmount) ?? 0;
        }
        setState(() {
          // Add 50 to the integer
          finalAmount = intValue + 50 + dietValue + progressTrackValue;

          // Convert the result back to a string
          strFinalAmount = finalAmount.toString();
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
                    'Purchase Review',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 80,
                          height: 80,
                          child: Image.network(
                            widget.serviceBgImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.serviceName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            // SizedBox(height: 5),
                            // Text(
                            //   widget.serviceHeader,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.normal,
                            //     fontSize: 16,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            SizedBox(height: 5),
                            Text(
                              "Trainer: ${widget.trainerName}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Level: ${widget.serviceLevel}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Duration: ${widget.sessionDuration}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black, thickness: 2),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Schedule Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Date: ${widget.date}",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Time: ${widget.time}",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(color: Colors.black, thickness: 2),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Text(
                      "Add Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: "Debit Card",
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/debitCard.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 10),
                      Text("Debit Card"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: "Gcash",
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/gcash.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 10),
                      Text("Gcash"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: "myCoins",
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/coin.png',
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(width: 10),
                      Text("My Coins"),
                      SizedBox(width: 5),
                      Text("(₱${_profiles.first.myCoins.toString()})"),
                    ],
                  ),
                  Divider(color: Colors.black, thickness: 2),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Purchase Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.levelHeader,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.levelBody,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    endIndent: 30,
                    indent: 30,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Session Duration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          widget.sessionDuration,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Number of exercise",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          widget.numberOfExercise,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ongoing Support",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        (widget.ongoingSupport == "included")
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
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Coaching",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        (widget.coaching == "included")
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
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    endIndent: 30,
                    indent: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (widget.isDietPlan == true)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Diet Plan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                size: 30,
                                color: Colors.green,
                              )
                            ],
                          ),
                        )
                      : SizedBox.fromSize(),
                  (widget.isProgressTrack == true)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Progress Tracking",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                size: 30,
                                color: Colors.green,
                              )
                            ],
                          ),
                        )
                      : SizedBox.fromSize(),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(color: Colors.black, thickness: 2),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Purchase Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "₱${widget.serviceAmount}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (widget.isDietPlan == true)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Diet Plan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "₱${widget.dietPlanAmount}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.fromSize(),
                  (widget.isProgressTrack == true)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Progress Tracking",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "₱${widget.progressTrackAmount}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.fromSize(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Service Fee",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "₱50",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    endIndent: 30,
                    indent: 30,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "₱${strFinalAmount}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        num transact =
                            _profiles.first.myCoins - num.parse(strFinalAmount);

                        num profit = _trainerProfiles.first.myCoins +
                            num.parse(strFinalAmount);
                        if (transact < 0) {
                          MyUtils.errorSnackBar(Icons.error,
                              "You dont have sufficient My Coins to process this transaction");
                        } else {
                          _uid = uuid.v4();
                          int orderNumber = 10000 + random.nextInt(90000);
                          final userNotifcations = FirebaseFirestore.instance
                              .collection('User Notifications')
                              .doc(_uid);

                          final data = {
                            'id': _uid,
                            'orderNumber': "${orderNumber}",
                            'trainer': widget.trainerName,
                            "serviceName": widget.serviceName,
                            "dateofPurchase": Timestamp.now(),
                            "userEmail": user.email,
                            "serviceLevel": widget.serviceLevel,
                            "trainerEmail": widget.trainerEmail,
                            "clientName":
                                "${_profiles.first.firstName} ${_profiles.first.lastName}",
                            "totalAmount": strFinalAmount
                          };
                          userNotifcations.set(data);

                          final trainerNotifcations = FirebaseFirestore.instance
                              .collection('Trainer Notifications')
                              .doc(_uid);

                          final trainerData = {
                            'id': _uid,
                            'orderNumber': "${orderNumber}",
                            'trainer': widget.trainerName,
                            "serviceName": widget.serviceName,
                            "trainerEmail": widget.trainerEmail,
                            "dateofPurchase": Timestamp.now(),
                            "userEmail": user.email,
                            "serviceLevel": widget.serviceLevel,
                            "clientName":
                                "${_profiles.first.firstName} ${_profiles.first.lastName}",
                            "totalAmount": strFinalAmount
                          };
                          trainerNotifcations.set(trainerData);

                          Timestamp timestamp =
                              convertToTimestamp(widget.date, widget.time);
                          calculateTimeSlots(
                              widget.time, widget.sessionDuration);
                          final clientClass = FirebaseFirestore.instance
                              .collection('Client Class')
                              .doc(_uid);

                          final clientClassData = {
                            'id': _uid,
                            'orderNumber': "${orderNumber}",
                            'trainer': widget.trainerName,
                            "serviceId": widget.serviceId,
                            "serviceName": widget.serviceName,
                            "trainerEmail": widget.trainerEmail,
                            "serviceBgPhoto": widget.serviceBgImage,
                            "dietPlanInclusions": widget.isDietPlan,
                            "progressTrackInclusions": widget.isProgressTrack,
                            "sessionDuration": widget.sessionDuration,
                            "dateofPurchase": Timestamp.now(),
                            "status:": "Ongoing",
                            "userEmail": user.email,
                            "serviceLevel": widget.serviceLevel,
                            'scheduleTime': timeSchedules,
                            'scheduleDate': widget.date,
                            'scheduleTimestamp': Timestamp.now(),
                            "clientName":
                                "${_profiles.first.firstName} ${_profiles.first.lastName}",
                            "totalAmount": strFinalAmount
                          };
                          clientClass.set(clientClassData);

                          int change = int.parse(transact.toString());
                          final userData = FirebaseFirestore.instance
                              .collection('Account Profile')
                              .doc(_profiles.first.id);
                          final data1 = {"myCoins": change};
                          userData.update(data1);

                          int trainerProfit = int.parse(profit.toString());
                          final trainerProfile = FirebaseFirestore.instance
                              .collection('Account Profile')
                              .doc(_trainerProfiles.first.id);
                          final trainerData1 = {"myCoins": trainerProfit};
                          trainerProfile.update(trainerData1);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SuccessPayment()));
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFDE683),
                        ),
                        child: Center(
                          child: Text(
                            'Purchase',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserPage(
                                  indexNo: 0,
                                )));
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFDE683),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
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

  void calculateTimeSlots(String initialTime, String sessionDuration) {
    // Convert initial time to a DateTime object
    DateTime currentTime = DateFormat.Hm().parse(initialTime);
    timeSchedules.clear();

    // Add the initial time slot
    timeSchedules.add(DateFormat.Hm().format(currentTime));

    // Calculate the number of time slots based on session duration
    int slots = 0;
    if (sessionDuration == "60 mins") {
      slots = 1;
    } else if (sessionDuration == "90 mins") {
      slots = 2;
    }

    // Add additional time slots
    for (int i = 0; i < slots; i++) {
      currentTime = currentTime.add(Duration(minutes: 30));
      timeSchedules.add(DateFormat.Hm().format(currentTime));
    }
  }

  Timestamp convertToTimestamp(String dateString, String timeString) {
    // Parse the date
    final parsedDate = DateFormat('MMMM dd, yyyy').parse(dateString);

    // Parse the time
    final parsedTime = DateFormat('HH:mm').parse(timeString);

    // Combine date and time into a DateTime object
    final dateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    // Convert DateTime to Timestamp
    return Timestamp.fromDate(dateTime);
  }
}
