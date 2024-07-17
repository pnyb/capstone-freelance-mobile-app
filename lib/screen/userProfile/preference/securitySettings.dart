import 'package:flutter/material.dart';

class SecuritySettingsPage extends StatefulWidget {
  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool _securityValue = false;

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
              'Security',
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
          SizedBox(height: 80),
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
                "Multi-factor Authentication",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Spacer(),
              Switch(
                value: _securityValue,
                activeColor: Colors.yellow,
                onChanged: (bool value) {
                  setState(() {
                    _securityValue = value;
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
            child: Container(
              width: double
                  .infinity, // Set the container width to occupy the available space
              child: Text(
                "Recommended. We will send an authentication code via SMS, email, or Flexed Fitness notification when using an unrecognized device or browser to login.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
