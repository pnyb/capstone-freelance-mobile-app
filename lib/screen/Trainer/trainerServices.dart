import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/model/trainerProfile.dart';
import 'package:flexedfitness/screen/Trainer/addService1.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/trainerViewService.dart';
import 'package:flexedfitness/screen/User/ViewService.dart';
import 'package:flutter/material.dart';

class TrainerServicesScreen extends StatefulWidget {
  final String name;

  const TrainerServicesScreen({
    required this.name,
    Key? key,
  });
  @override
  _TrainerServiceScreenState createState() => _TrainerServiceScreenState();
}

class _TrainerServiceScreenState extends State<TrainerServicesScreen> {
  final User user = FirebaseAuth.instance.currentUser!;
  final List<Services> _profiles = [];
  bool noImage = true;
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Services')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Services.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          if (_profiles.first.serviceBgPhoto.isEmpty) {
            setState(() {
              noImage = true;
              isloaded = true;
            });
          } else {
            setState(() {
              noImage = false;
              isloaded = true;
            });
          }
        });
      });

      // Move the print statement inside the then() block
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onDestinationSelected: (index) => setState(() {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TrainerPage(indexNo: index)));
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
                  icon:
                      Icon(Icons.checklist, color: Color(0xFFFDE683), size: 26),
                  label: 'Task'),
              NavigationDestination(
                  icon: Icon(Icons.person, color: Color(0xFFFDE683), size: 26),
                  label: 'Profile'),
            ]),
      ),
      appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/images/yellowLogo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              actions: [],
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddService1(
                          name: widget.name,
                        )));
              },
              child: Container(
                width: 250,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFFDE683),
                ),
                child: Center(
                  child: Text(
                    'Add A Service',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                return buildSearchItem(_profiles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchItem(Services item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TrainerViewServiceScreen(
                  serviceId: item.id,
                  serviceName: item.serviceName,
                )));
      },
      child: Container(
        height: 400,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                item.serviceBgPhoto,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              '${item.serviceName}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   'Instructor: ${item.Name}',
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     fontSize: 11,
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
            if (item.isBeginner == true &&
                item.isIntermediate == false &&
                item.isAdvanced == false)
              Text(
                "Beginner",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else if (item.isBeginner == true &&
                item.isIntermediate == true &&
                item.isAdvanced == false)
              Text(
                "Beginner - Intermediate",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else if (item.isBeginner == true &&
                item.isIntermediate == false &&
                item.isAdvanced == true)
              Text(
                "Beginner - Advanced",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else if (item.isBeginner == false &&
                item.isIntermediate == true &&
                item.isAdvanced == false)
              Text(
                "Intermediate",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else if (item.isBeginner == false &&
                item.isIntermediate == true &&
                item.isAdvanced == true)
              Text(
                "Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else if (item.isBeginner == false &&
                item.isIntermediate == false &&
                item.isAdvanced == true)
              Text(
                "Advanced",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              )
            else
              Text(
                "Beginner - Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
