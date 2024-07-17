class Account {
  String firstName;
  String lastName;
  String username;
  String emailAddress;
  String password;
  String gender;
  String contactNumber;
  String dateOfBirth;
  String id;
  String suffix;
  String accountType;
  String typeOfId;
  bool isDeactivated;
  bool isIDApproved;
  String proofIdImage;
  String profileImage;
  int myCoins;

  Account(
      {required this.firstName,
      required this.lastName,
      required this.emailAddress,
      required this.username,
      required this.password,
      required this.typeOfId,
      required this.gender,
      required this.contactNumber,
      required this.dateOfBirth,
      required this.isDeactivated,
      required this.isIDApproved,
      required this.id,
      required this.suffix,
      required this.accountType,
      required this.proofIdImage,
      required this.profileImage,
      required this.myCoins});

  static Account fromJson(Map<String, dynamic> json) => Account(
        firstName: json['firstName'],
        dateOfBirth: json['dateOfBirth'],
        emailAddress: json['emailAddress'],
        username: json['username'],
        typeOfId: json['typeOfId'],
        contactNumber: json['contactNumber'],
        isDeactivated: json['isDeactivated'],
        isIDApproved: json['isIDApproved'],
        gender: json['gender'],
        id: json['id'],
        lastName: json['lastName'],
        password: json['password'],
        suffix: json['suffix'],
        accountType: json['accountType'],
        proofIdImage: json['proofIdImage'],
        profileImage: json['profileImage'],
        myCoins: json['myCoins'],
      );
}
