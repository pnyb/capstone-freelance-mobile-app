import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/screen/registration/addIdUser.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flexedfitness/themeHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegisterUser2 extends StatefulWidget {
  @override
  _RegisterUser2State createState() => _RegisterUser2State();
}

class _RegisterUser2State extends State<RegisterUser2> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController suffixController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  late Timestamp dobTimestamp;
  String date = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  final gender = ['Male', 'Female'];
  String finalGender = "Male";

  final suffix = ['None', 'Jr. ', 'Sr.', 'I', "II", "III"];
  String finalSuffix = "None";

  bool editImage = false;
  File? serviceImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              SizedBox(height: 15),
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
                  'Set your user profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Profile Image",
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
              buildTextField('First Name', firstNameController),
              SizedBox(height: 14),
              buildTextField('Last Name', lastNameController),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Suffix",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          width: 65,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: finalSuffix,
                                isExpanded: true,
                                iconSize: 20,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                items: suffix.map(buildMenuItems).toList(),
                                onChanged: (value) =>
                                    setState(() => finalSuffix = value!)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Container(
                          width: 80,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: finalGender,
                                isExpanded: true,
                                iconSize: 20,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                items: gender.map(buildMenuItems).toList(),
                                onChanged: (value) =>
                                    setState(() => finalGender = value!)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  bottom: 5,
                ),
                child: Text("Date of Birth",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: buildDateofBirth()),
              ),
              SizedBox(height: 5),
              buildTextField('Username', usernameController),
              SizedBox(height: 5),
              buildTextField('Contact Number', contactNumberController),
              SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic here for the proceed button

                        if (firstNameController.text.isEmpty ||
                            lastNameController.text.isEmpty ||
                            dateOfBirthController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            contactNumberController.text.isEmpty ||
                            serviceImage == null) {
                          MyUtils.errorSnackBar(Icons.error,
                              "Please complete all the required fields");
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => addIdUser(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    profileImage: serviceImage!,
                                    suffix: finalSuffix,
                                    gender: finalGender,
                                    dateOfBirth: dateOfBirthController.text,
                                    username: usernameController.text,
                                    contactNumber: contactNumberController.text,
                                  )));
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
    );
  }

  Container buildDateofBirth() {
    return Container(
      child: TextFormField(
        onTap: () async {
          DateTime accidentDate = await selectDate(context, DateTime.now(),
              lastDate: DateTime.now());
          date = DateFormat('dd-MM-yyyy').format(accidentDate);
          setState(() {
            print(date);
            dateOfBirthController = TextEditingController()..text = this.date;
            dobTimestamp = Timestamp.fromDate(accidentDate);
            print(dobTimestamp);
          });
        },
        controller: dateOfBirthController,
        decoration:
            ThemeHelper().textInputDecoration("Date of Birth", "mm/dd/yyyy"),
        keyboardType: TextInputType.emailAddress,
        validator: (val) {
          if ((val!.isNotEmpty) &&
              !RegExp(r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$")
                  .hasMatch(val)) {
            return "Enter a valid date";
          }
          return null;
        },
      ),
    );
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime? lastDate}) async {
    Completer completer = Completer();
    if (Platform.isAndroid) {
      showDatePicker(
              context: context,
              initialDate: initialDateTime,
              firstDate: DateTime(1970),
              // ignore: prefer_if_null_operators
              lastDate: lastDate == null
                  ? DateTime(initialDateTime.year + 10)
                  : lastDate)
          .then((temp) {
        if (temp == null) return null;
        completer.complete(temp);
        setState(() {});
      });
    } else {
      DatePicker.showDatePicker(
        context,
        dateFormat: 'yyyy-mmm-dd',
        onConfirm: (temp, selectedIndex) {
          // ignore: unnecessary_null_comparison
          if (temp == null) {
            return null;
          }
          completer.complete(temp);

          setState(() {});
        },
      );
    }
    return completer.future;
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ));

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
