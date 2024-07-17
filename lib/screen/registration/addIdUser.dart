import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/notifications.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/themeHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class addIdUser extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String suffix;
  final String gender;
  final String dateOfBirth;
  final String username;
  final String contactNumber;
  final File profileImage;

  const addIdUser(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.suffix,
      required this.profileImage,
      required this.gender,
      required this.dateOfBirth,
      required this.username,
      required this.contactNumber});

  @override
  _addIdUserState createState() => _addIdUserState();
}

class _addIdUserState extends State<addIdUser> {
  TextEditingController typeOfId = TextEditingController();
  bool editImage = false;
  File? serviceImage;

  Future<bool> _showDiscardDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Discard'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Are you sure you want to discard this information?',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if 'No' is pressed
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true if 'Yes' is pressed
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Provide a default value of false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Show the discard dialog
        final shouldDiscard = _showDiscardDialog(context);

        // Return true to allow navigation if 'Yes' is chosen in the dialog,
        // or return false to prevent navigation if 'No' is chosen.
        return shouldDiscard;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                SizedBox(height: 25),
                Center(
                  child: Text(
                    "Proof of Identification",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 125,
                    width: 125,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: (serviceImage == null)
                        ? IconButton(
                            onPressed: () async {
                              editImage = true;
                              try {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (image == null) return;

                                final imageTemporary = File(image.path);

                                setState(() {
                                  serviceImage = imageTemporary;
                                });
                              } on PlatformException catch (e) {
                                print('Failed to pick image: $e');
                              }
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ))
                        : Image.file(
                            serviceImage!,
                            height: 125,
                            width: 125,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                buildTextField('Type of Identification', typeOfId),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Add your logic here for the proceed button

                        if (editImage == true || typeOfId.text.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterUser1(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    profileImage: widget.profileImage,
                                    suffix: widget.suffix,
                                    proofIdentification: serviceImage!,
                                    typeOfId: typeOfId.text,
                                    gender: widget.gender,
                                    dateOfBirth: widget.dateOfBirth,
                                    username: widget.username,
                                    contactNumber: widget.contactNumber,
                                  )));
                        } else {
                          MyUtils.errorSnackBar(Icons.error,
                              "Please complete all the required fields");
                        }
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                SizedBox(height: 15),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Text(
                //     'By joining, you agree to the Flexed Fitness Terms of Service and to occasionally receive emails from us. Please read our Privacy Policy, to learn how we use your personal data.',
                //     style: TextStyle(fontSize: 12),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {String hintText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
