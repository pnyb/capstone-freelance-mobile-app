import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/main.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flexedfitness/screen/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool isLoading = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )),
          backgroundColor: Color.fromARGB(255, 244, 215, 178),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              // Add your logic here for the back button
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Image.asset(
                  'assets/images/logo.png'), // Replace with your actual image path
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
              ),

              SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your logic here for the login button
                      signIn();
                    },
                    child: (isLoading == true)
                        ? const CircularProgressIndicator()
                        : Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(255, 222, 89, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    bool hasError = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.message!.isNotEmpty) {
        hasError = true;
        print(e.message);
        print(hasError);
      }
      if (e.message == "Given String is empty or null") {
        MyUtils.errorSnackBar(
            Icons.error, "Please input your username and password");
      } else {
        MyUtils.errorSnackBar(Icons.error, e.message.toString());
      }
    }
    if (hasError == false) {
      Future.delayed(const Duration(seconds: 5), () {
        isLoading = false;
      });
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
