// ignore_for_file: file_names
import 'package:flexedfitness/screen/User/Dashboard.dart';
import 'package:flexedfitness/screen/User/notification.dart';
import 'package:flexedfitness/screen/User/profile.dart';
import 'package:flexedfitness/screen/User/search.dart';
import 'package:flexedfitness/screen/User/task.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final int indexNo;
  const UserPage({Key? key, required this.indexNo}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int index = 0;
  final screens = [
    Dashboard(),
    NotificationPage(),
    SearchPage(),
    TaskPage(),
    ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    if (widget.indexNo == 0) {
      index = index;
    } else {
      index = widget.indexNo;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            indicatorColor: Colors.white,
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        child: NavigationBar(
            backgroundColor: Colors.white,
            height: 50,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
                  this.index = index;
                }),
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    Icons.home,
                    color: Color(0xFFFDE683),
                    size: 26,
                  ),
                  label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.notifications,
                      color: Color(0xFFFDE683), size: 26),
                  label: 'Notifications'),
              NavigationDestination(
                  icon: Icon(Icons.search, color: Color(0xFFFDE683), size: 26),
                  label: 'Search'),
              NavigationDestination(
                  icon:
                      Icon(Icons.checklist, color: Color(0xFFFDE683), size: 26),
                  label: 'Task'),
              NavigationDestination(
                  icon: Icon(Icons.person, color: Color(0xFFFDE683), size: 26),
                  label: 'Profile'),
            ]),
      ),
      body: screens[index]);
}
