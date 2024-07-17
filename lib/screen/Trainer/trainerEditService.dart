import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/screen/Trainer/editTrainerInclusions.dart';
import 'package:flexedfitness/screen/Trainer/trainerDashboard.dart';
import 'package:flexedfitness/screen/Trainer/trainerServices.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class TrainerEditService extends StatefulWidget {
  final String name;
  final String serviceId;
  const TrainerEditService({
    required this.name,
    required this.serviceId,
    Key? key,
  });
  @override
  _TrainerEditServiceState createState() => _TrainerEditServiceState();
}

class _TrainerEditServiceState extends State<TrainerEditService> {
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
  TextEditingController dietPlanAmount = TextEditingController();
  TextEditingController progressTrackAmount = TextEditingController();

  final sessionDuration = ['30 mins', '60 mins', '90 mins'];
  String finalbeginnerSessionDuration = '30 mins';
  String finalIntermediateSessionDuration = '60 mins';
  String finalAdvancedSessionDuration = '90 mins';

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
  bool beginner = false;
  bool intermediate = false;
  bool advanced = false;
  bool completeInfo = false;
  List<File> images = [];
  List<String> imagesUrl = [];
  bool isEdit = false;
  bool isloaded = false;
  bool isDietPlan = false;
  bool isProgressTrack = false;
  bool lackingInfo = false;
  String fileName = 'background_image.jpg';
  String _uid = "";
  final List<Services> _profiles = [];

  Future<void> downloadImages(List<String> imageUrls) async {
    final dio = Dio();
    final List<File> downloadedImages = [];

    for (final imageUrl in imageUrls) {
      try {
        final response = await dio.get<List<int>>(imageUrl,
            options: Options(responseType: ResponseType.bytes));
        final bytes = response.data!;
        final file = File(
            '${Directory.systemTemp.path}/${Uuid().v4()}.jpg'); // Use a unique filename
        await file.writeAsBytes(bytes);
        downloadedImages.add(file);
      } catch (e) {
        print('Error downloading image: $e');
      }
    }

    setState(() {
      images = downloadedImages;
    });
  }

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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Service"),
          content: Text("Are you sure you want to delete this service?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                _deleteService(); // Perform the deletion
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<File> downloadImage(String imageUrl, String fileName) async {
    Dio dio = Dio();

    try {
      Response response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(response.data);
      return file;
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }

  void _deleteService() async {
    // Replace 'your_collection_name' with the actual name of your Firestore collection
    FirebaseFirestore.instance
        .collection('Services')
        .doc(
            "Services-${_uid}") // Use the appropriate document ID to identify the service
        .delete()
        .then((_) {
      // Service deleted successfully
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TrainerDashboard(),
        ),
      );
    }).catchError((error) {
      // An error occurred while deleting the service
      print("Error deleting service: $error");
      // You can handle the error as needed (e.g., showing an error message).
    });

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Trainer Notifications')
              .where("serviceName", isEqualTo: serviceNameController.text)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('Services')
            .doc(documentSnapshot.id)
            .delete();
        // Print a message indicating successful deletion for each document (optional)
        print('Document with ID ${documentSnapshot.id} deleted successfully.');
      }

      // Perform any other actions after successful deletion if needed
    } catch (error) {
      print('Error deleting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    }

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('User Notifications')
              .where("serviceName", isEqualTo: serviceNameController.text)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('Services')
            .doc(documentSnapshot.id)
            .delete();
        // Print a message indicating successful deletion for each document (optional)
        print('Document with ID ${documentSnapshot.id} deleted successfully.');
      }

      // Perform any other actions after successful deletion if needed
    } catch (error) {
      print('Error deleting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Services')
        .where('id', isEqualTo: widget.serviceId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Services.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          beginner = _profiles.first.isBeginner;
          intermediate = _profiles.first.isIntermediate;
          advanced = _profiles.first.isAdvanced;
          _uid = _profiles.first.id;
          finalAdvancedNumExercise = _profiles.first.advancedNumExercise;
          finalIntermediateNumExercise =
              _profiles.first.intermediateNumExercise;
          finalbeginnerNumExercise = _profiles.first.beginnerNumExercise;
          finalAdvancedOngoingSup = _profiles.first.advancedOngoingSupp;
          finalIntermediateOngoingSup = _profiles.first.intermediateOngoingSupp;
          finalbeginnerDietOngoingSup = _profiles.first.advancedOngoingSupp;
          finalAdvancedCoaching = _profiles.first.advancedCoaching;
          finalIntermediateCoaching = _profiles.first.intermediateCoaching;
          finalbeginnerCoaching = _profiles.first.beginnerCoaching;
          finalAdvancedSessionDuration =
              _profiles.first.advancedSessionDuration;
          finalIntermediateSessionDuration =
              _profiles.first.intermediateSessionDuration;
          finalbeginnerSessionDuration =
              _profiles.first.beginnerSessionDuration;
          hardAmountController.text = _profiles.first.hardAmount;
          intermediateAmountController.text =
              _profiles.first.intermediateAmount;
          beginnerAmountController.text = _profiles.first.beginnerAmount;
          hardBodyController.text = _profiles.first.advancedBody;
          hardHeaderController.text = _profiles.first.advancedHeader;
          intermediateBodyController.text = _profiles.first.intermediateBody;
          intermediateHeaderController.text =
              _profiles.first.intermediateHeader;
          beginnerBodyController.text = _profiles.first.beginnerBody;
          beginnerHeaderController.text = _profiles.first.beginnerHeader;
          bodyController.text = _profiles.first.body;
          headerController.text = _profiles.first.header;
          isDietPlan = _profiles.first.dietPlan;
          isProgressTrack = _profiles.first.progressTrack;
          dietPlanAmount.text = _profiles.first.dietPlanAmount;
          progressTrackAmount.text = _profiles.first.progressTrackAmount;
          serviceNameController.text = _profiles.first.serviceName;

          serviceImageUrl = _profiles.first.serviceBgPhoto;
          for (int i = 0; i < _profiles.first.imageUrls.length; i++) {
            imagesUrl.add(_profiles.first.imageUrls[i]);
          }
          print(_profiles.first.imageUrls.length);
          print(imagesUrl.length);
          downloadImages(imagesUrl);
          isloaded = true;
        });
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isloaded)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                TextButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Color(0xFFFDE683),
                    ),
                  ),
                  onPressed: () {
                    _showDeleteConfirmationDialog();
                  },
                ),
              ],
              title: Center(
                  child: Text(
                "Edit Service",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
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
                        constraints: BoxConstraints(maxWidth: double.infinity),
                        height: 50,
                        color: Color(0xFFFFDE59), // Background color
                        child: Center(
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Cover Photo",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
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
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (image == null) return;

                                final imageTemporary = File(image.path);

                                setState(() {
                                  serviceImage = imageTemporary;
                                  isEdit = true;
                                });
                              } on PlatformException catch (e) {
                                print('Failed to pick image: $e');
                              }
                            },
                            child: Container(
                              height: 125,
                              width: 125,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: (isEdit == false)
                                  ? Image.network(
                                      serviceImageUrl,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      serviceImage!,
                                      height: 125,
                                      width: 125,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTextField('Service Name', serviceNameController),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      buildTextField('Header', headerController),
                      SizedBox(height: 15),
                      buildRichTextField('Sub-Header', bodyController),
                      SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(maxWidth: double.infinity),
                        height: 50,
                        color: Color(0xFFFFDE59), // Background color
                        child: Center(
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Beginner",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value:
                                  beginner, // You can set the initial value here
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
                      SizedBox(height: 15),
                      buildTextField('Header', beginnerHeaderController),
                      SizedBox(height: 15),
                      buildRichTextField('Sub-Header', beginnerBodyController),
                      SizedBox(height: 15),
                      buildTextField('Base Price', beginnerAmountController),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Session Duration",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                                            finalbeginnerSessionDuration =
                                                value!)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              children: [
                                Text(
                                  "Number of Exercise",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                                        onChanged: (value) => setState(() =>
                                            finalbeginnerNumExercise = value!)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
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
                      SizedBox(height: 15),
                      buildTextField('Header', intermediateHeaderController),
                      SizedBox(height: 15),
                      buildRichTextField(
                          'Sub-Header', intermediateBodyController),
                      SizedBox(height: 15),
                      buildTextField(
                          'Base Price', intermediateAmountController),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Session Duration",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                            SizedBox(width: 20.0),
                            Column(
                              children: [
                                Text(
                                  "Number of Exercise",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                                            finalIntermediateNumExercise =
                                                value!)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Advanced",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Checkbox(
                              value:
                                  advanced, // You can set the initial value here
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
                      SizedBox(height: 15),
                      buildTextField('Header', hardHeaderController),
                      SizedBox(height: 15),
                      buildRichTextField('Sub-Header', hardBodyController),
                      SizedBox(height: 15),
                      buildTextField('Base Price', hardAmountController),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Session Duration",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                                            finalAdvancedSessionDuration =
                                                value!)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              children: [
                                Text(
                                  "Number of Exercise",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  width: 150,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
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
                                        onChanged: (value) => setState(() =>
                                            finalAdvancedNumExercise = value!)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(maxWidth: double.infinity),
                        height: 50,
                        color: Color(0xFFFFDE59), // Background color
                        child: Center(
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Photo Gallery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // Code for adding an image
                                    var pickedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedImage != null) {
                                      setState(() {
                                        images.add(File(pickedImage.path));
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.add),
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
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
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
                              String uid = "";
                              if (user != null) {
                                uid = user.uid;
                                print("User UID: $uid");
                              } else {
                                print("User not signed in.");
                              }
                              try {
                                print(serviceImageUrl);

                                if (isEdit == true) {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child(user!.email!)
                                      .child(serviceNameController.text)
                                      .child('Service Background Image')
                                      .child('${_uid}.jpg');
                                  await ref.putFile(serviceImage!);

                                  String bgImageUrl =
                                      await ref.getDownloadURL();
                                  serviceImageUrl = bgImageUrl;
                                }

                                File imageFile = await downloadImage(
                                    serviceImageUrl, fileName);
                                // Now you have the image saved as a file (imageFile)

                                if (beginner == true) {
                                  if (beginnerAmountController.text.isEmpty ||
                                      beginnerHeaderController.text.isEmpty ||
                                      beginnerBodyController.text.isEmpty) {
                                    setState(() {
                                      lackingInfo = true;
                                      lackingArea = "within the beginner level";
                                    });
                                  } else {
                                    setState(() {
                                      completeInfo = true;
                                    });
                                  }
                                }
                                if (intermediate == true) {
                                  if (intermediateAmountController.text.isEmpty ||
                                      intermediateHeaderController
                                          .text.isEmpty ||
                                      intermediateBodyController.text.isEmpty) {
                                    setState(() {
                                      lackingInfo = true;
                                      lackingArea =
                                          "within the intermediate level";
                                    });
                                  } else {
                                    setState(() {
                                      completeInfo = true;
                                    });
                                  }
                                }

                                if (advanced == true) {
                                  if (hardAmountController.text.isEmpty ||
                                      hardBodyController.text.isEmpty ||
                                      hardHeaderController.text.isEmpty) {
                                    setState(() {
                                      lackingInfo = true;
                                      lackingArea = "within the advance level";
                                    });
                                  } else {
                                    setState(() {
                                      completeInfo = true;
                                    });
                                  }
                                }
                                imagesUrl.clear();
                                if (completeInfo == true) {
                                  if (headerController.text.isEmpty ||
                                      bodyController.text.isEmpty ||
                                      serviceNameController.text.isEmpty) {
                                    MyUtils.errorSnackBar(Icons.error,
                                        "please complete the general information above");
                                  } else if (lackingInfo == true) {
                                    MyUtils.errorSnackBar(Icons.error,
                                        "please complete the information ${lackingArea}");
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                editTrainerInclusions(
                                                  id: _uid,
                                                  trainerId: "trainer-${uid}",
                                                  trainer: widget.name,
                                                  emailAddress: user!.email!,
                                                  serviceName:
                                                      serviceNameController
                                                          .text,
                                                  body: headerController.text,
                                                  header: bodyController.text,
                                                  beginnerAmount:
                                                      beginnerAmountController
                                                          .text,
                                                  intermediateAmount:
                                                      intermediateAmountController
                                                          .text,
                                                  hardAmount:
                                                      hardAmountController.text,
                                                  isBeginner: beginner,
                                                  isIntermediate: intermediate,
                                                  isAdvanced: advanced,
                                                  beginnerHeader:
                                                      beginnerHeaderController
                                                          .text,
                                                  beginnerBody:
                                                      beginnerBodyController
                                                          .text,
                                                  intermediateHeader:
                                                      intermediateHeaderController
                                                          .text,
                                                  intermediateBody:
                                                      intermediateBodyController
                                                          .text,
                                                  advancedHeader:
                                                      hardHeaderController.text,
                                                  advancedBody:
                                                      hardBodyController.text,
                                                  beginnerSessionDuration:
                                                      finalbeginnerSessionDuration,
                                                  beginnerCoaching:
                                                      finalbeginnerCoaching,
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
                                                  advancedCoaching:
                                                      finalAdvancedCoaching,
                                                  advancedNumExercise:
                                                      finalAdvancedNumExercise,
                                                  advancedOngoingSupp:
                                                      finalAdvancedOngoingSup,
                                                  serviceBgPhoto:
                                                      serviceImageUrl,
                                                  imagesUrl: images,
                                                  dietPlanAmount:
                                                      dietPlanAmount.text,
                                                  progressTrackAmount:
                                                      progressTrackAmount.text,
                                                  isDietPlan: isDietPlan,
                                                  isProgressTrack:
                                                      isProgressTrack,
                                                )));
                                  }
                                } else {
                                  MyUtils.errorSnackBar(Icons.error,
                                      "please select atleast one level in creating a service and complete the information given");
                                }
                              } catch (e) {
                                print('Error: $e');
                              }
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFDE59),
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
          )
        : const Scaffold(
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
              fontWeight: FontWeight.normal,
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
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
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
              minLines: 6,
              maxLines: 8,
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
