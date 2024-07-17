import 'package:flutter/material.dart';

class MyInterestPage extends StatelessWidget {
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
              'My Interest',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [],
      ),
    );
  }
}
