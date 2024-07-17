import 'package:flutter/material.dart';

class AppearanceSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Appearance',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 100),
          Row(
            children: [
              Container(
                width: 200,
                height: 350,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 290,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: RadioListTile(
                        title: Text(
                          'Light',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        value: 'option1',
                        groupValue: null, // Replace with your group value
                        onChanged: (value) {
                          // Handle radio button selection
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 200,
                height: 350,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 290,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: RadioListTile(
                        title: Text(
                          'Dark',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        value: 'option1',
                        groupValue: null, // Replace with your group value
                        onChanged: (value) {
                          // Handle radio button selection
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double
                  .infinity, // Set the container width to occupy the available space
              child: Text(
                "If ‘system’ is selected, Flexed Fitness app will automatically adjust your appearance based on your device’s system settings.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
