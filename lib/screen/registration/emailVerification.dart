import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/checkUserDeactivation.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/Admin/checkAdmin.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/Trainer/checkTrainerInfo.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  bool isTrainer = false;
  bool isUser = false;
  Timer? timer;
  bool isloaded = false;
  final user = FirebaseAuth.instance.currentUser!;
  final List<Account> _profiles = [];
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Account.fromJson(doc.data());
        _profiles.add(myOrder);
        print(_profiles);
        setState(() {
          if (_profiles.first.accountType == "Trainer") {
            setState(() {
              isTrainer = true;
              isloaded = true;
            });
          } else if (_profiles.first.accountType == "User") {
            setState(() {
              isUser = true;
              isloaded = true;
            });
          } else {
            setState(() {
              isloaded = true;
            });
          }
        });
      });

      // Move the print statement inside the then() block
    });

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      await user.sendEmailVerification();

      setState((() => canResendEmail = false));
      await Future.delayed(const Duration(seconds: 60));
      setState((() => canResendEmail = true));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => isloaded
      ? (isEmailVerified
          ? (isTrainer ? CheckTrainerAccount() : (isUser ? CheckUserDeactivation() : CheckAdmin()))

          // ? (isTrainer ? CheckTrainerAccount() : CheckUserDeactivation())
          : Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                title:
                    Center(child: Image.asset('assets/images/yellowLogo.png')),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/emailPic.png'),
                    const SizedBox(height: 10),
                    const Text('One more step...',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Divider(
                      indent: 80,
                      endIndent: 80,
                      color: Colors.black,
                      thickness: 2,
                    ),
                    const SizedBox(height: 15),
                    const Text('Check you Email for Verification!',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    const Text('Your Journey Awaits,',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFDE683)),
                        textAlign: TextAlign.center),
                    const Text('Just a Click Away. Let’s Get Started!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFDE683)),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ))
      : Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 300,
                ),
                SizedBox(height: 50),
                SpinKitFadingCircle(
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ));

  Stream<List<Account>> readAccount() {
    return FirebaseFirestore.instance
        .collection('Account Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['emailAddress'].toString().contains(user.email!))
            .map((doc) => Account.fromJson(doc.data()))
            .toList());
  }
}
