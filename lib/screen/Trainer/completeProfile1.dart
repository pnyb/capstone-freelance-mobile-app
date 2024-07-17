import 'package:flexedfitness/screen/Trainer/completeProfile2.dart';
import 'package:flexedfitness/screen/registration/registerTrainer1.dart';
import 'package:flexedfitness/screen/registration/registerUser1.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

class CompleteProfile1 extends StatefulWidget {
  @override
  _CompleteProfile1State createState() => _CompleteProfile1State();
}

class _CompleteProfile1State extends State<CompleteProfile1> {
  TextEditingController locationController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  final job = [
    'Cardio',
    'HIIT',
    'Pilates',
    'Strengthening',
    'Weights',
    'Yoga',
    'Zumba'
  ];
  String finalJob = "Cardio";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          "Complete your profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              buildTextField(
                'Location',
                locationController,
                "Tell us what city and province you are located.",
                hintText: "Davao City, Davao DelSur",
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Job Position",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: finalJob,
                        isExpanded: true,
                        iconSize: 20,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        items: job.map(buildMenuItems).toList(),
                        onChanged: (value) =>
                            setState(() => finalJob = value!)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildRichTextField('About Me', aboutMeController),
              SizedBox(height: 60),
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CompleteProfile2(
                              job: finalJob,
                              aboutMe: aboutMeController.text,
                              location: locationController.text)));
                    },
                    child: Text(
                      'Next',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, String Description,
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
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            Description,
            style: TextStyle(
              fontSize: 12.0,
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
          padding: const EdgeInsets.only(
            left: 25,
          ),
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
              minLines: 6,
              maxLines: 8,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
