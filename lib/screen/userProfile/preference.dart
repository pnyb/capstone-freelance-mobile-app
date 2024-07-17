import 'package:flexedfitness/screen/userProfile/preference/appearanceSettings.dart';
import 'package:flexedfitness/screen/userProfile/preference/notificationSettings.dart';
import 'package:flexedfitness/screen/userProfile/preference/securitySettings.dart';
import 'package:flutter/material.dart';

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  bool _switchValue = false;

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
              'Preferences',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationSettingsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 25),
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.black),
                ),
                Spacer(),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SecuritySettingsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 25),
                Text(
                  "Security",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.black),
                ),
                Spacer(),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppearanceSettingsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 25),
                Text(
                  "Appearance",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.black),
                ),
                Spacer(),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          SizedBox(height: 50),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 25),
              Text(
                "Online Status",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Spacer(),
              Switch(
                value: _switchValue,
                activeColor: Colors.yellow,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "You’ll remain Online for as long as the app is open.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
