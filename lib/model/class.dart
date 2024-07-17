import 'package:cloud_firestore/cloud_firestore.dart';

class ClientClass {
  String id;
  String serviceId;
  String serviceBgPhoto;
  String status;
  String orderNumber;
  String trainer;
  String serviceName;
  Timestamp dateofPurchase;
  Timestamp scheduleTimestamp;
  String userEmail;
  String serviceLevel;
  String clientName;
  String totalAmount;
  String trainerEmail;
  String scheduleDate;
  String sessionDuration;
  List<String> scheduleTime;
  bool dietPlanInclusions;
  bool progressTrackInclusions;

  ClientClass({
    required this.id,
    required this.orderNumber,
    required this.trainer,
    required this.serviceName,
    required this.serviceId,
    required this.serviceBgPhoto,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.status,
    required this.dateofPurchase,
    required this.scheduleTimestamp,
    required this.userEmail,
    required this.serviceLevel,
    required this.trainerEmail,
    required this.clientName,
    required this.sessionDuration,
    required this.totalAmount,
    required this.dietPlanInclusions,
    required this.progressTrackInclusions,
  });

  static ClientClass fromJson(Map<String, dynamic> json) => ClientClass(
        id: json['id'],
        orderNumber: json['orderNumber'],
        trainer: json['trainer'],
        serviceName: json['serviceName'],
        dateofPurchase: json['dateofPurchase'],
        scheduleTimestamp: json['scheduleTimestamp'],
        serviceId: json['serviceId'],
        serviceBgPhoto: json['serviceBgPhoto'],
        sessionDuration: json['sessionDuration'],
        status: json['status:'],
        scheduleDate: json['scheduleDate'] ?? "",
        scheduleTime: List<String>.from(json['scheduleTime'] ?? {}),
        userEmail: json['userEmail'],
        serviceLevel: json['serviceLevel'],
        trainerEmail: json['trainerEmail'],
        clientName: json['clientName'],
        totalAmount: json['totalAmount'],
        dietPlanInclusions: json['dietPlanInclusions'],
        progressTrackInclusions: json['progressTrackInclusions'],
      );
}
