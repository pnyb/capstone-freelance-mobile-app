import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerFeedback {
  String id;
  String clientName;
  String clientEmail;
  String trainerName;
  String trainerEmail;
  String classID;
  String serviceName;
  String serviceLevel;
  String consisRate;
  String formTechRate;
  String enduRate;
  String balStabRate;
  String adaptRate;
  String commRate;
  String description;
  Timestamp dateFeedback;

  TrainerFeedback({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.trainerName,
    required this.trainerEmail,
    required this.classID,
    required this.serviceName,
    required this.serviceLevel,
    required this.consisRate,
    required this.formTechRate,
    required this.enduRate,
    required this.balStabRate,
    required this.adaptRate,
    required this.commRate,
    required this.description,
    required this.dateFeedback,
  });

  static TrainerFeedback fromJson(Map<String, dynamic> json) => TrainerFeedback(
        id: json['id'],
        clientName: json['clientName'],
        clientEmail: json['clientEmail'],
        trainerName: json['trainerName'],
        trainerEmail: json['trainerEmail'],
        classID: json['classID'], 
        serviceName: json['serviceName'],
        serviceLevel: json['serviceLevel'],
        consisRate: json['consisRate'],
        formTechRate: json['formTechRate'],
        enduRate: json['enduRate'],
        balStabRate: json['balStabRate'],
        adaptRate: json['adaptRate'],
        commRate: json['commRate'],
        description: json['description'] ?? "",
        dateFeedback: json['dateFeedback'],
      );
}
