class Services {
  String beginnerAmount;
  String body;
  String emailAddress;
  String hardAmount;
  String header;
  String id;
  List<String> imageUrls;
  String intermediateAmount;
  String serviceBgPhoto;
  String serviceName;
  String trainer;
  String trainerId;
  String advancedCoaching;
  bool dietPlan;
  String advancedNumExercise;
  String advancedOngoingSupp;
  bool progressTrack;
  String advancedSessionDuration;
  String beginnerCoaching;
  String beginnerNumExercise;
  String beginnerOngoingSupp;
  String beginnerSessionDuration;
  String intermediateCoaching;
  String intermediateNumExercise;
  String intermediateOngoingSupp;
  String intermediateSessionDuration;
  String advancedBody;
  String advancedHeader;
  String beginnerBody;
  String beginnerHeader;
  String intermediateBody;
  String intermediateHeader;
  String dietPlanAmount;
  String progressTrackAmount;
  bool isBeginner;
  bool isIntermediate;
  bool isAdvanced;
  bool isFeatured;
  bool isDeactivated;
  Services({
    required this.beginnerAmount,
    required this.body,
    required this.emailAddress,
    required this.hardAmount,
    required this.header,
    required this.id,
    required this.imageUrls,
    required this.intermediateAmount,
    required this.serviceBgPhoto,
    required this.serviceName,
    required this.trainer,
    required this.trainerId,
    required this.advancedCoaching,
    required this.dietPlan,
    required this.advancedNumExercise,
    required this.advancedOngoingSupp,
    required this.progressTrack,
    required this.advancedSessionDuration,
    required this.beginnerCoaching,
    required this.dietPlanAmount,
    required this.beginnerNumExercise,
    required this.beginnerOngoingSupp,
    required this.progressTrackAmount,
    required this.beginnerSessionDuration,
    required this.intermediateCoaching,
    required this.intermediateNumExercise,
    required this.intermediateOngoingSupp,
    required this.intermediateSessionDuration,
    required this.advancedBody,
    required this.advancedHeader,
    required this.beginnerBody,
    required this.beginnerHeader,
    required this.intermediateBody,
    required this.intermediateHeader,
    required this.isBeginner,
    required this.isIntermediate,
    required this.isAdvanced,
    required this.isFeatured,
    required this.isDeactivated,
  });

  static Services fromJson(Map<String, dynamic> json) => Services(
        beginnerAmount: json['beginnerAmount'] ?? "",
        body: json['body'],
        emailAddress: json['emailAddress'],
        hardAmount: json['hardAmount'] ?? "",
        header: json['header'],
        id: json['id'],
        imageUrls: List<String>.from(json['imageUrls'] ?? []),
        intermediateAmount: json['intermediateAmount'] ?? "",
        serviceBgPhoto: json['serviceBgPhoto'],
        serviceName: json['serviceName'],
        trainer: json['trainer'],
        trainerId: json['trainerId'],
        advancedCoaching: json['AdvancedCoaching'],
        dietPlan: json['dietPlan'],
        advancedNumExercise: json['AdvancedNumExercise'],
        advancedOngoingSupp: json['AdvancedOngoingSupp'],
        progressTrack: json['progressTrack'],
        advancedSessionDuration: json['AdvancedSessionDuration'],
        beginnerCoaching: json['beginnerCoaching'],
        dietPlanAmount: json['dietPlanAmount'] ?? "",
        beginnerNumExercise: json['beginnerNumExercise'],
        beginnerOngoingSupp: json['beginnerOngoingSupp'],
        progressTrackAmount: json['progressTrackAmount'] ?? "",
        beginnerSessionDuration: json['beginnerSessionDuration'],
        intermediateCoaching: json['IntermediateCoaching'],
        intermediateNumExercise: json['IntermediateNumExercise'],
        intermediateOngoingSupp: json['IntermediateOngoingSupp'],
        intermediateSessionDuration: json['IntermediateSessionDuration'],
        advancedBody: json['advancedBody'] ?? "",
        advancedHeader: json['advancedHeader'] ?? "",
        beginnerBody: json['beginnerBody'] ?? "",
        beginnerHeader: json['beginnerHeader'] ?? "",
        intermediateHeader: json['intermediateHeader'] ?? "",
        intermediateBody: json['intermediateBody'] ?? "",
        isAdvanced: json['isAdvanced'],
        isBeginner: json['isBeginner'],
        isIntermediate: json['isIntermediate'],
        isFeatured: json['isFeatured'],
        isDeactivated: json['isDeactivated'],
      );
}
