import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/notifications.dart';
import 'package:flexedfitness/screen/User/ViewNotification.dart';
import 'package:flutter/material.dart';

class TrainerNotificationPage extends StatefulWidget {
  @override
  _TrainerNotificationPageState createState() =>
      _TrainerNotificationPageState();
}

class _TrainerNotificationPageState extends State<TrainerNotificationPage> {
  final User user = FirebaseAuth.instance.currentUser!;
  final List<Notifications> _notifications = [];
  bool isloaded = false;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Trainer Notifications')
        .where('trainerEmail', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Notifications.fromJson(doc.data());
        _notifications.add(myOrder);
        setState(() {
          isloaded = true;
        });
      });

      // Move the print statement inside the then() block
    });

    setState(() {
      isloaded = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isloaded == true)
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,

            body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: _notifications != null && _notifications!.isNotEmpty
                  ? List.generate(_notifications!.length, (index) {
                      Notifications item = _notifications![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewNotification(
                              notifId: _notifications!.first.id,
                              isUser: false,
                            ),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                                child: Text(
                                  "Order Update",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                                child: Text(
                                  "${item.clientName} purchased your service (${item.serviceName})",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                                child: Text(
                                  item.dateofPurchase.toDate().toString(),
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                                // Adjust the bottom padding
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  : [
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'There are no notifications at the moment.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ],
            ),
          ),

          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                )));
  }
}
