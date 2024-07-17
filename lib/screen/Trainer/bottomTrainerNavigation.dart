// ignore_for_file: file_names
import 'package:flexedfitness/screen/Trainer/trainerDashboard.dart';
import 'package:flexedfitness/screen/Trainer/trainerNotication.dart';
import 'package:flexedfitness/screen/Trainer/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/trainerTask.dart';
import 'package:flexedfitness/screen/User/Dashboard.dart';
import 'package:flexedfitness/screen/User/notification.dart';
import 'package:flexedfitness/screen/User/profile.dart';
import 'package:flexedfitness/screen/User/task.dart';
import 'package:flutter/material.dart';

class TrainerPage extends StatefulWidget {
  final int indexNo;
  const TrainerPage({Key? key, required this.indexNo}) : super(key: key);

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  int index = 0;
  final screens = [
    TrainerDashboard(),
    TrainerNotificationPage(),
    TrainerTaskPage(),
    TrainerProfilePage()
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
            backgroundColor: Colors.black,
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            indicatorColor: Colors.black,
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        child: NavigationBar(
            backgroundColor: Colors.black,
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
                label: 'Home',
              ),
              NavigationDestination(
                  icon: Icon(Icons.notifications,
                      color: Color(0xFFFDE683), size: 26),
                  label: 'Notifications'),
              NavigationDestination(
                  icon: Icon(Icons.receipt, color: Color(0xFFFDE683), size: 26),
                  label: 'Sales'),
              NavigationDestination(
                  icon: Icon(Icons.person, color: Color(0xFFFDE683), size: 26),
                  label: 'Profile'),
            ]),
      ),
      body: screens[index]);
}
