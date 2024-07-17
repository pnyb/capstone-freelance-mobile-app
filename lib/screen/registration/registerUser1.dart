import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class RegisterUser1 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String suffix;
  final String gender;
  final String dateOfBirth;
  final String username;
  final String contactNumber;
  final String typeOfId;
  final File profileImage;
  final File proofIdentification;
  const RegisterUser1(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.suffix,
      required this.profileImage,
      required this.gender,
      required this.dateOfBirth,
      required this.username,
      required this.typeOfId,
      required this.proofIdentification,
      required this.contactNumber});

  @override
  _RegisterUser1State createState() => _RegisterUser1State();
}

class _RegisterUser1State extends State<RegisterUser1> {
  TextEditingController email = TextEditingController();
  TextEditingController repassword = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isRepasswordVisible = true;
  bool _agreedToTerms = false; // Track whether the user has agreed to terms
  String serviceImageUrl = "";
  String proofIdImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                  height: 180,
                ),
              ), // Replace with your actual image path

              Center(
                child: Text(
                  'Fitness journey starts here!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Set your account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),

              SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: password,
                    obscureText: _isPasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Re-enter Password',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: repassword,
                    obscureText: _isRepasswordVisible,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => _isRepasswordVisible = !_isRepasswordVisible,
                        ),
                        child: Icon(
                          _isRepasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50),

              // Add the Checkbox widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value!;
                        });
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'By joining, you agree to the Flexed Fitness ',
                              ),
                              TextSpan(
                                text: 'Terms and \nConditions',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _termsConditions(context);
                                    print('Terms of Service Clicked!');
                                    // You can navigate, show a dialog, or perform any action on click
                                  },
                              ),
                              TextSpan(
                                text:
                                    ' and to occasionally receive emails from us.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add your logic here for the login button

                      if (repassword.text == password.text) {
                        signUp();
                        print(email.text);
                        print(password.text);
                      } else {
                        MyUtils.errorSnackBar(
                            Icons.error, "Password do not match");
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

              

              // ... Your existing code ...
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Check if the user has agreed to terms before proceeding
      if (!_agreedToTerms) {
        MyUtils.errorSnackBar(Icons.error, "Please read and agree to FlexedFitness Terms & Conditions");
        //Navigator.pop(context);
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Get the current user
      User? user = userCredential.user;

      // Check if the user is not null
      if (user != null) {
        // Save user information
        await saveInfo(user);

        // Navigate to MainPage only after saveInfo is completed
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false,
        );
      } else {
        // Handle the case where the user is null
        MyUtils.errorSnackBar(Icons.error, "User creation failed");
      }
    } on FirebaseAuthException catch (e) {
      if (e.message == "Given String is empty or null") {
        MyUtils.errorSnackBar(Icons.error, "Please input your username and password");
      } else {
        MyUtils.errorSnackBar(Icons.error, e.message.toString());
        print(e.message);
      }
    } finally {
      //Navigator.pop(context); // Close the loading dialog
    }
  }


    Future saveInfo(User user) async {
    String uid = user.uid;
    print("User UID: $uid");

    final ref = FirebaseStorage.instance
        .ref()
        .child(user.email!)
        .child('Profile Image')
        .child('$uid.jpg');
    await ref.putFile(widget.profileImage);
    String bgImageUrl = await ref.getDownloadURL();
    print("saveRefU");

    try {
      final ref1 = FirebaseStorage.instance
          .ref()
          .child(user.email!)
          .child('Proof Identification')
          .child('$uid.jpg');
      await ref1.putFile(widget.proofIdentification);
      print("line312");
      proofIdImageUrl = await ref1.getDownloadURL();
      print("line314");
    } catch (e) {
      print("Error uploading proof identification image: $e");
      print("File: ${widget.proofIdentification.path}");
    }

    final userData =
        FirebaseFirestore.instance.collection('Account Profile').doc(uid);

    final data = {
      'id': uid,
      'firstName': widget.firstName,
      'username': widget.username,
      'lastName': widget.lastName,
      'contactNumber': widget.contactNumber,
      'gender': widget.gender,
      'suffix': widget.suffix,
      'isDeactivated': false,
      'dateOfBirth': widget.dateOfBirth,
      'emailAddress': email.text.trim(),
      'password': password.text.trim(),
      'accountType': "User",
      "profileImage": bgImageUrl,
      'typeOfId': widget.typeOfId,
      "proofIdImage": proofIdImageUrl,
      'isIDApproved': false,
      'myCoins': 0
    };
    await userData.set(data);
  }


  Future<bool> _termsConditions(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Flexed Fitness',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'By using the FlexedFitness app, you agree to comply with and be bound by the following terms and conditions. If you do not agree to these terms, please do not use the App.',
                      style: TextStyle(
              
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Services Offered',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'FlexedFitness provides a platform that connects users (Clients) with freelance fitness professionals (Freelancers) for the provision of fitness services.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Scheduling and Appointments',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'No Rescheduling: Once an appointment is scheduled between a Client and a Freelancer, no rescheduling is allowed.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Timeliness: Clients and Freelancers are expected to be punctual for appointments. Late arrivals may result in a shortened session.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Freelancer Working Hours',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Working Hours Compliance: Trainers are required to adhere strictly to the designated working hours outlined in their employment agreement or schedule. Any deviation from the agreed-upon working hours must be communicated and approved in advance by the relevant authority. Failure to comply with the stipulated working hours without prior authorization may result in disciplinary action, including but not limited to warnings, suspension, or termination of employment.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Payments and Refunds',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'No Refunds: All payments for fitness services are non-refundable.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Cancellation Policy',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Client Cancellation: Clients are not permitted to cancel appointments once confirmed.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'User Conduct',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Compliance: Users are expected to comply with all applicable laws and regulations while using the App.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Professionalism: Both Clients and Freelancers are expected to behave in a professional manner during interactions facilitated by the App.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Intellectual Property',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Content Ownership: All content provided by the App, including but not limited to text, graphics, logos, and images, is the property of Flexed Fitness and is protected by intellectual property laws.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Disclaimer of Liability',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Flexed Fitness is not responsible for any injuries, damages, or losses incurred during or as a result of fitness sessions facilitated by the App. Users participate at their own risk.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Modification of Terms',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'Flexed Fitness reserves the right to modify these terms and conditions at any time. Users will be notified of significant changes.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Governing Law',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      textAlign: TextAlign.justify,
                      'These terms and conditions are governed by the laws of the Republic of the Philippines.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('I have read and understood'),
                  onPressed: () {
                    Navigator.of(context).pop(false);

                    // Return true if 'Yes' is pressed
                  },
                ),
                // TextButton(
                //   child: const Text('I Agree'),
                //   onPressed: () {
                //     Navigator.of(context).pop(true);
                //   },
                // ),
              ],
            );
          },
        ) ??
        false;
  }

  

}
