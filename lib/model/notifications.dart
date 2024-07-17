import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String id;
  String orderNumber;
  String trainer;
  String serviceName;
  Timestamp dateofPurchase;
  String userEmail;
  String serviceLevel;
  String clientName;
  String totalAmount;
  String trainerEmail;

  Notifications({
    required this.id,
    required this.orderNumber,
    required this.trainer,
    required this.serviceName,
    required this.dateofPurchase,
    required this.userEmail,
    required this.serviceLevel,
    required this.trainerEmail,
    required this.clientName,
    required this.totalAmount,
  });

  static Notifications fromJson(Map<String, dynamic> json) => Notifications(
        id: json['id'],
        orderNumber: json['orderNumber'],
        trainer: json['trainer'],
        serviceName: json['serviceName'],
        dateofPurchase: json['dateofPurchase'],
        userEmail: json['userEmail'],
        serviceLevel: json['serviceLevel'],
        trainerEmail: json['trainerEmail'],
        clientName: json['clientName'],
        totalAmount: json['totalAmount'],
      );
}
