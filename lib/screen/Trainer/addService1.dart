import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/screen/Trainer/trainerServices.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'addTrainerInclusions.dart';

class AddService1 extends StatefulWidget {
  final String name;
  const AddService1({
    required this.name,
    Key? key,
  });
  @override
  _AddService1State createState() => _AddService1State();
}

class _AddService1State extends State<AddService1> {
  File? serviceImage;
  String serviceImageUrl = "";

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController headerController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  TextEditingController beginnerHeaderController = TextEditingController();
  TextEditingController beginnerBodyController = TextEditingController();
  TextEditingController intermediateHeaderController = TextEditingController();
  TextEditingController intermediateBodyController = TextEditingController();
  TextEditingController hardHeaderController = TextEditingController();
  TextEditingController hardBodyController = TextEditingController();
  TextEditingController beginnerAmountController = TextEditingController();
  TextEditingController intermediateAmountController = TextEditingController();
  TextEditingController hardAmountController = TextEditingController();

  final sessionDuration = ['30 mins', '60 mins', '90 mins'];
  String finalbeginnerSessionDuration = '30 mins';
  String finalIntermediateSessionDuration = '30 mins';
  String finalAdvancedSessionDuration = '30 mins';

  String finalbeginnerCoaching = 'included';
  String finalIntermediateCoaching = 'included';
  String finalAdvancedCoaching = 'included';
  String finalbeginnerDietOngoingSup = 'included';
  String finalIntermediateOngoingSup = 'included';
  String finalAdvancedOngoingSup = 'included';

  final numberOfExercise = [
    '5 - 10 exercise',
    '10 - 15 exercise',
    '15 - 20 exercise'
  ];
  String finalbeginnerNumExercise = '5 - 10 exercise';
  String finalIntermediateNumExercise = '5 - 10 exercise';
  String finalAdvancedNumExercise = '5 - 10 exercise';
  String lackingArea = "";
  bool editImage = false;
  bool beginner = false;
  bool isChecked = false;
  bool intermediate = false;
  bool advanced = false;
  bool completeInfo = false;
  bool lackingInfo = false;
  List<File> images = [];
  List<String> imagesUrl = [];
  var uuid = const Uuid();
  String _uid = "";
  Future<bool> _showDiscardDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Discard'),
              content: const SingleChildScrollView(
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
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if 'No' is pressed
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
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

  Future<bool> _addPhoto(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Photo Uploading',
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
                      'By uploading a cover photo to this platform, you agree to the following terms and conditions:',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Ownership and Rights',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'You represent and warrant that you have the legal right to upload and share the Photo. You either own the Photo\'s copyright or have obtained all necessary permissions and licenses from the rightful owner(s) to upload and share the Photo on this Platform.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Authenticity',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'The Photo you upload is an authentic representation of the subject it portrays. Any form of manipulation, alteration, or misrepresentation of the Photo is strictly prohibited.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Consent',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'If the Photo contains identifiable individuals, you affirm that you have obtained their informed consent to upload and display their likeness on this Platform. You release this Platform from any liability related to the use of such images without proper consent.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Legal Compliance',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'The Photo does not infringe upon any applicable laws, regulations, or the rights of third parties, including but not limited to copyright, trademark, privacy, or publicity rights.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Responsibility',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'You acknowledge that you are solely responsible for the content of the Photo you upload and any consequences that may arise from its use on this Platform.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'User Account',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Violation of this Photo Upload Disclaimer may result in the removal of your Photo, suspension of your account, or other actions deemed appropriate by the Platform.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'By uploading a Photo to Flexed Fitness, you acknowledge and agree to comply with this Photo Upload Disclaimer and Flexed Fitness\' Terms of Service. Failure to adhere to these terms may result in the removal of your content and/or restrictions on your use of Flexed Fitness. Flexed Fitness disclaims all liability for any misuse, misrepresentation, or infringement of rights related to the Photos uploaded by users. Users are solely responsible for ensuring the authenticity and legality of the Photos they upload.',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('I Dont Agree'),
                  onPressed: () {
                    Navigator.of(context).pop(false);

                    // Return true if 'Yes' is pressed
                  },
                ),
                TextButton(
                  child: const Text('I Agree'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              
            ),
      body: WillPopScope(
        onWillPop: () {
          // Show the discard dialog
          final shouldDiscard = _showDiscardDialog(context);

          // Return true to allow navigation if 'Yes' is chosen in the dialog,
          // or return false to prevent navigation if 'No' is chosen.
          return shouldDiscard;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  height: 50,
                  color: const Color(0xFFFFDE59), // Background color
                  child: const Center(
                    child: Text(
                      'Service Profile',
                      style: TextStyle(
                        color: Colors.black, // Font color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Cover Photo",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 125,
                    width: 125,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: (serviceImage == null)
                        ? IconButton(
                            onPressed: () async {
                              bool shouldAdd = await _addPhoto(context);

                              if (shouldAdd) {
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
                              }
                            },
                            icon: const Icon(
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
                const SizedBox(height: 20),
                buildTextField('Service Name', serviceNameController),
                const SizedBox(height: 10),
                buildTextField('Description Title', headerController),
                const SizedBox(height: 15),
                buildRichTextField('Description', bodyController),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  height: 50,
                  color: const Color(0xFFFFDE59), // Background color
                  child: const Center(
                    child: Text(
                      'Levels',
                      style: TextStyle(
                        color: Colors.black, // Font color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Beginner",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Checkbox(
                        value: beginner, // You can set the initial value here
                        onChanged: (bool? newValue) {
                          // Handle the checkbox state change here
                          setState(() {
                            beginner = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                buildTextField('Description Title', beginnerHeaderController),
                const SizedBox(height: 15),
                buildRichTextField('Description ', beginnerBodyController),
                const SizedBox(height: 15),
                buildTextField('Base Price', beginnerAmountController),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Session Duration",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 120,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalbeginnerSessionDuration,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: sessionDuration
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(() =>
                                      finalbeginnerSessionDuration = value!)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        children: [
                          const Text(
                            "Number of Exercise",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 130,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalbeginnerNumExercise,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: numberOfExercise
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(
                                      () => finalbeginnerNumExercise = value!)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Intermediate",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Checkbox(
                        value:
                            intermediate, // You can set the initial value here
                        onChanged: (bool? newValue) {
                          // Handle the checkbox state change here
                          setState(() {
                            intermediate = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                buildTextField(
                    'Description Title', intermediateHeaderController),
                const SizedBox(height: 15),
                buildRichTextField('Description', intermediateBodyController),
                const SizedBox(height: 15),
                buildTextField('Base Price', intermediateAmountController),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Session Duration",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 120,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalIntermediateSessionDuration,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: sessionDuration
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(() =>
                                      finalIntermediateSessionDuration =
                                          value!)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        children: [
                          const Text(
                            "Number of Exercise",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 130,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalIntermediateNumExercise,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: numberOfExercise
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(() =>
                                      finalIntermediateNumExercise = value!)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Advanced",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Checkbox(
                        value: advanced, // You can set the initial value here
                        onChanged: (bool? newValue) {
                          // Handle the checkbox state change here
                          setState(() {
                            advanced = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                buildTextField('Description Title', hardHeaderController),
                const SizedBox(height: 15),
                buildRichTextField('Description', hardBodyController),
                const SizedBox(height: 15),
                buildTextField('Base Price', hardAmountController),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Session Duration",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 120,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalAdvancedSessionDuration,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: sessionDuration
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(() =>
                                      finalAdvancedSessionDuration = value!)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        children: [
                          const Text(
                            "Number of Exercise",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            width: 130,
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  value: finalAdvancedNumExercise,
                                  isExpanded: true,
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  items: numberOfExercise
                                      .map(buildMenuItems)
                                      .toList(),
                                  onChanged: (value) => setState(
                                      () => finalAdvancedNumExercise = value!)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  height: 50,
                  color: const Color(0xFFFFDE59), // Background color
                  child: const Center(
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: Colors.black, // Font color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Photo Gallery',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              // Code for adding an image
                              bool shouldAdd = await _addPhoto(context);

                              if (shouldAdd) {
                                var pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    images.add(File(pickedImage.path));
                                  });
                                }
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              // Code for deleting an image
                              if (images.isNotEmpty) {
                                setState(() {
                                  images.removeLast();
                                });
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Please upload photos of your services or sequence of sample routines',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.file(images[index]!),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        User? user = auth.currentUser;
                        String uid = user?.uid ?? "";
                        print("User UID: $uid");

                        // Function to check if fields are empty
                        bool areFieldsEmpty(TextEditingController amountController,
                            TextEditingController headerController,
                            TextEditingController bodyController) {
                          return amountController.text.isEmpty ||
                              headerController.text.isEmpty ||
                              bodyController.text.isEmpty;
                        }

                        // Function to handle level-specific validation
                        void handleLevel(bool isSelected, TextEditingController amountController,
                            TextEditingController headerController,
                            TextEditingController bodyController, String level) {
                          if (isSelected) {
                            if (areFieldsEmpty(amountController, headerController, bodyController)) {
                              setState(() {
                                completeInfo = true;
                                lackingInfo = true;
                                lackingArea += ", $level level";
                              });
                            } else {
                              setState(() {
                                lackingInfo = false;
                                completeInfo = true;
                              });
                            }
                          }
                        }

                        // Reset lackingArea before checking each level
                        lackingArea = "";

                        if (beginner == true) {
                          handleLevel(
                              beginner,
                              beginnerAmountController,
                              beginnerHeaderController,
                              beginnerBodyController,
                              "beginner");
                        }
                        if (intermediate == true) {
                          handleLevel(
                              intermediate,
                              intermediateAmountController,
                              intermediateHeaderController,
                              intermediateBodyController,
                              "intermediate");
                        }
                        if (advanced == true) {
                          handleLevel(
                              advanced,
                              hardAmountController,
                              hardHeaderController,
                              hardBodyController,
                              "advanced");
                        }

                        if (lackingArea.isNotEmpty) {
                          lackingArea = lackingArea.substring(2); // Remove leading comma and space
                        }

                        if (completeInfo == true) {
                          _uid = uuid.v4();
                          if (headerController.text.isEmpty ||
                              bodyController.text.isEmpty ||
                              serviceNameController.text.isEmpty ||
                              serviceImage == null) {
                            MyUtils.errorSnackBar(Icons.error,
                                "please complete the general information above");
                          } else if (lackingInfo == true) {
                            MyUtils.errorSnackBar(Icons.error,
                                "please complete the information on this level: $lackingArea");
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => addTrainerInclusions(
                      id: _uid,
                                                            trainerId: "trainer-$uid",
                                                            trainer: widget.name,
                                                            emailAddress: user!.email!,
                                                            serviceName: serviceNameController.text,
                                                            body: headerController.text,
                                                            header: bodyController.text,
                                                            beginnerAmount:
                                                                beginnerAmountController.text,
                                                            intermediateAmount:
                                                                intermediateAmountController.text,
                                                            hardAmount: hardAmountController.text,
                                                            isBeginner: beginner,
                                                            isIntermediate: intermediate,
                                                            isAdvanced: advanced,
                                                            beginnerHeader:
                                                                beginnerHeaderController.text,
                                                            beginnerBody: beginnerBodyController.text,
                                                            intermediateHeader:
                                                                intermediateHeaderController.text,
                                                            intermediateBody:
                                                                intermediateBodyController.text,
                                                            advancedHeader: hardHeaderController.text,
                                                            advancedBody: hardBodyController.text,
                                                            beginnerSessionDuration:
                                                                finalbeginnerSessionDuration,
                                                            beginnerCoaching: finalbeginnerCoaching,
                                                            beginnerNumExercise:
                                                                finalbeginnerNumExercise,
                                                            beginnerOngoingSupp:
                                                                finalbeginnerDietOngoingSup,
                                                            intermediateSessionDuration:
                                                                finalIntermediateSessionDuration,
                                                            intermediateCoaching:
                                                                finalIntermediateCoaching,
                                                            intermediateNumExercise:
                                                                finalIntermediateNumExercise,
                                                            intermediateOngoingSupp:
                                                                finalIntermediateOngoingSup,
                                                            advancedSessionDuration:
                                                                finalAdvancedSessionDuration,
                                                            advancedCoaching: finalAdvancedCoaching,
                                                            advancedNumExercise:
                                                                finalAdvancedNumExercise,
                                                            advancedOngoingSupp:
                                                                finalAdvancedOngoingSup,
                                                            serviceBgPhoto: serviceImage!,
                                                            imagesUrl: images,
                                    )));
                          }
                        }  else {
                          MyUtils.errorSnackBar(Icons.error,
                              "please select at least one level in creating a service and complete the information given");
                        }
                      },

                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFDE59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(height: 100),
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
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 4.0),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItems(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ));

  Widget buildRichTextField(String label, TextEditingController controller,
      {String hintText = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              minLines: 6,
              maxLines: 8,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
