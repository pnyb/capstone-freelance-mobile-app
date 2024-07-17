import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushValue = false;
  bool _emailValue = false;

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
              'Notifications',
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
                "Push Notifications",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Spacer(),
              Switch(
                value: _pushValue,
                activeColor: Colors.yellow,
                onChanged: (bool value) {
                  setState(() {
                    _pushValue = value;
                  });
                },
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          SizedBox(height: 20),
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
                "Email Notifications",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Spacer(),
              Switch(
                value: _emailValue,
                activeColor: Colors.yellow,
                onChanged: (bool value) {
                  setState(() {
                    _emailValue = value;
                  });
                },
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
