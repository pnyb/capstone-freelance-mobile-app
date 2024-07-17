// ignore_for_file: file_names
import 'package:flexedfitness/screen/Admin/adminDashboard.dart';
import 'package:flexedfitness/screen/Admin/approvedID.dart';
import 'package:flexedfitness/screen/Admin/adminProfile.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  final int indexNo;
  const AdminPage({Key? key, required this.indexNo}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int index = 0;
  final screens = [
    adminDashboard(),
    approvedID(),
    AdminProfilePage(),
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
                    Icons.pending,
                    color: Color(0xFFFDE683),
                    size: 26,
                  ),
                  label: 'Pending'), 
              NavigationDestination(
                  icon:
                      Icon(Icons.verified, color: Color(0xFFFDE683), size: 26),
                  label: 'Verified'),
              NavigationDestination(
                  icon: Icon(Icons.person, color: Color(0xFFFDE683), size: 26),
                  label: 'Profile'),
            ]),
      ),
      body: screens[index]);
}
