import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewNotification extends StatefulWidget {
  final String notifId;
  final bool isUser;

  const ViewNotification({
    Key? key,
    required this.notifId,
    required this.isUser,
  }) : super(key: key);

  @override
  _ViewNotificationState createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  final List<Notifications> _notifications = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() {
    final collectionPath = widget.isUser
        ? 'User Notifications'
        : 'Trainer Notifications';

    FirebaseFirestore.instance
        .collection(collectionPath)
        .where('id', isEqualTo: widget.notifId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Notifications.fromJson(doc.data());
        _notifications.add(myOrder);
        setState(() {
          isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 227, 225, 225),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 400,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Service Order #${_notifications.first.orderNumber}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle, size: 30),
                                      SizedBox(width: 10),
                                      Text(
                                        widget.isUser ? "Trainer" : "Client",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.isUser
                                        ? _notifications.first.trainer
                                        : _notifications.first.clientName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.work, size: 30),
                                      SizedBox(width: 10),
                                      Text(
                                        "Service",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _notifications.first.serviceName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, size: 30),
                                      SizedBox(width: 10),
                                      Text(
                                        "Date of Purchase",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('MMMM dd, y').format(
                                      _notifications.first.dateofPurchase.toDate(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.credit_card, size: 30),
                                      SizedBox(width: 10),
                                      Text(
                                        "Total Cost",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Php ${_notifications.first.totalAmount.toString()}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
  }
}
