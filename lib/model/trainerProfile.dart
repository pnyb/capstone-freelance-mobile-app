import 'dart:convert';

class TrainerProfile {
  String aboutMe;
  String emailAddress;
  String id;
  String jobDescription;
  String location;
  List<Experience> experiences;
  List<String> skills;
  String profileImage;
  String name;
   List<String> startTime;
   List<String> endTime;

  TrainerProfile({
    required this.aboutMe,
    required this.emailAddress,
    required this.id,
    required this.jobDescription,
    required this.location,
    required this.experiences,
    required this.skills,
    required this.profileImage,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  static TrainerProfile fromJson(Map<String, dynamic> json) => TrainerProfile(
      aboutMe: json['aboutMe'],
      emailAddress: json['emailAddress'],
      id: json['id'],
      jobDescription: json['jobDescription'],
      location: json['location'],
      profileImage: json['profileImage'],
      name: json['name'],
      startTime: List<String>.from(json['startTime'] ?? []),
      endTime: List<String>.from(json['endTime'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      experiences: List<Experience>.from(
          json['experiences']?.map((x) => Experience.fromMap(x)) ?? []));
}

class Experience {
  final String yearEnded;
  final String yearStarted;
  final String job;
  Experience({
    required this.yearEnded,
    required this.yearStarted,
    required this.job,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'yearEnded': yearEnded});
    result.addAll({'yearStarted': yearStarted});
    result.addAll({'job': job});

    return result;
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      yearEnded: map['yearEnded'] ?? '',
      yearStarted: map['yearStarted'] ?? '',
      job: map['job'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Experience.fromJson(String source) =>
      Experience.fromMap(json.decode(source));
}
