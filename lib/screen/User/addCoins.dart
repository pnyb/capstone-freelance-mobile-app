import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flutter/material.dart';

class addCoins extends StatefulWidget {
  final String accountId;
  final int existingCoin;

  const addCoins({
    Key? key,
    required this.accountId,
    required this.existingCoin,
  });

  @override
  _addCoinsState createState() => _addCoinsState();
}

class _addCoinsState extends State<addCoins> {
  TextEditingController coins = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Center(
              child: Text(
            "Add Coins",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Text(
                    'Enter Amount',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: coins,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          coins.text = "20";
                        });
                      },
                      child: Text(
                        '₱20',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the primary color to transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                            width: 4.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),

                     Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              coins.text = "50";
                            });
                          },
                          child: Text(
                            '₱50',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Set the primary color to transparent
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                                width: 4.0, // Set the border width
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          coins.text = "100";
                        });
                      },
                      child: Text(
                        '₱100',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the primary color to transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                            width: 4.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                   Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          coins.text = "200";
                        });
                      },
                      child: Text(
                        '₱200',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the primary color to transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                            width: 4.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          coins.text = "500";
                        });
                      },
                      child: Text(
                        '₱500',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the primary color to transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                            width: 4.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                   Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          coins.text = "1000";
                        });
                      },
                      child: Text(
                        '₱1000',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the primary color to transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color.fromRGBO(255, 222, 89, 1), // Set the border color
                            width: 4.0, // Set the border width
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (coins.text.isNotEmpty) {
                          if (int.tryParse(coins.text) != null) {
                            int finalAmount =
                                int.tryParse(coins.text)! + widget.existingCoin;

                            final userData = FirebaseFirestore.instance
                                .collection('Account Profile')
                                .doc(widget.accountId);
                            final data = {"myCoins": finalAmount};

                            userData.update(data).then((_) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserPage(indexNo: 0)));
                            }).catchError((error) {
                              print("Error updating user data: $error");
                              // Handle the error as needed (e.g., showing an error message).
                            });
                          } else {
                            // Handle the case where coins.text is not numeric
                            print('Coins input is not a valid number.');
                            // You might want to show a message to the user about invalid input.
                          }
                        }
                      },
                      child: Text(
                        'Add Coin',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
        ));
  }
}
