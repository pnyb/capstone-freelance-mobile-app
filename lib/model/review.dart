import 'package:cloud_firestore/cloud_firestore.dart';

class UserReviews {
  String id;
  String clientName;
  String trainerName;
  String serviceName;
  String description;
  String serviceImage;
  String trainerEmail;
  String userEmail;
  String rating;
  Timestamp dateReviewed;

  UserReviews({
    required this.id,
    required this.clientName,
    required this.trainerName,
    required this.serviceName,
    required this.description,
    required this.serviceImage,
    required this.trainerEmail,
    required this.userEmail,
    required this.rating,
    required this.dateReviewed,
  });

  static UserReviews fromJson(Map<String, dynamic> json) => UserReviews(
        id: json['id'],
        clientName: json['clientName'],
        trainerName: json['trainerName'],
        serviceName: json['serviceName'],
        description: json['description'] ?? "",
        serviceImage: json['serviceImage'],
        trainerEmail: json['trainerEmail'],
        userEmail: json['userEmail'],
        rating: json['rating'],
        dateReviewed: json['dateReviewed'],
      );
}
