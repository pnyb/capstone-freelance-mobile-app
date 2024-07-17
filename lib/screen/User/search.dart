import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexedfitness/model/service.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/screen/User/ViewService.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  final List<Services> _services = [];
  List<Services> _searchServices = [];
  List<Services> _searchPlacesQuery = [];
  final List<Account> _account = [];
  final User user = FirebaseAuth.instance.currentUser!;
  bool isBeginner = false;
  bool isIntermediate = false;
  bool isAdvanced = false;
  bool isloaded = false;
  String query = '';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Services')
        .where('isDeactivated', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final service = Services.fromJson(doc.data());
        _services.add(service);
        setState(() {
          _searchServices = _services;
        });
      });
      // Move the print statement inside the then() block
    });

    FirebaseFirestore.instance
        .collection('Account Profile')
        .where('emailAddress',
            isEqualTo: user.email) // Replace with the desired email address
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final account = Account.fromJson(doc.data());
        _account.add(account);
      });
      setState(() {
        isloaded = true;
      });
      // Move the print statement inside the then() block
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });

    super.initState();
  }

  void search(String value) {
    _searchServices.clear;
    _searchPlacesQuery.clear();

    for (int i = 0; i < _services.length; i++) {
      if (_services[i]
          .serviceName
          .toLowerCase()
          .contains(value.toLowerCase())) {
        _searchPlacesQuery.add(_services[i]);
      }
    }

    if (isBeginner == true) {
      List<Services> _filterBeginner = [];
      for (int i = 0; i < _searchPlacesQuery.length; i++) {
        if (_searchPlacesQuery[i].isBeginner == true) {
          _filterBeginner.add(_searchPlacesQuery[i]);
        }
      }

      setState(() {
        _searchServices = _filterBeginner;
      });
    } else if (isIntermediate == true) {
      List<Services> _filterIntermediate = [];
      for (int i = 0; i < _searchPlacesQuery.length; i++) {
        if (_searchPlacesQuery[i].isIntermediate == true) {
          _filterIntermediate.add(_searchPlacesQuery[i]);
        }
      }

      setState(() {
        _searchServices = _filterIntermediate;
      });
    } else if (isAdvanced == true) {
      List<Services> _filterAdvanced = [];
      for (int i = 0; i < _searchPlacesQuery.length; i++) {
        if (_searchPlacesQuery[i].isAdvanced == true) {
          _filterAdvanced.add(_searchPlacesQuery[i]);
        }
      }

      setState(() {
        _searchServices = _filterAdvanced;
      });
    } else {
      setState(() {
        _searchServices = _searchPlacesQuery;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Search',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  onSubmitted: search,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: '',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => search(query),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: (() {
                      setState(() {
                        if (isBeginner == true) {
                          isBeginner = false;
                          _searchPlacesQuery.clear();
                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }

                          setState(() {
                            _searchServices = _searchPlacesQuery;
                          });
                        } else {
                          _searchPlacesQuery.clear();

                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }

                          List<Services> _filterBeginner = [];
                          for (int i = 0; i < _searchPlacesQuery.length; i++) {
                            if (_searchPlacesQuery[i].isBeginner == true) {
                              _filterBeginner.add(_searchPlacesQuery[i]);
                            }
                          }

                          setState(() {
                            _searchServices = _filterBeginner;
                          });

                          isBeginner = true;
                          isIntermediate = false;
                          isAdvanced = false;
                        }
                      });
                    }),
                    style: (isBeginner == true)
                        ? ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))))
                        : ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                    child: const Text(
                      'Beginner',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: (() {
                      setState(() {
                        if (isIntermediate == true) {
                          _searchPlacesQuery.clear();
                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }
                          setState(() {
                            _searchServices = _searchPlacesQuery;
                          });
                          isIntermediate = false;
                        } else {
                          _searchPlacesQuery.clear();

                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }

                          List<Services> _filterIntermediate = [];
                          for (int i = 0; i < _searchPlacesQuery.length; i++) {
                            if (_searchPlacesQuery[i].isIntermediate == true) {
                              _filterIntermediate.add(_searchPlacesQuery[i]);
                            }
                          }

                          setState(() {
                            _searchServices = _filterIntermediate;
                          });

                          isIntermediate = true;
                          isBeginner = false;
                          isAdvanced = false;
                        }
                      });
                    }),
                    style: (isIntermediate == true)
                        ? ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))))
                        : ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                    child: const Text(
                      'Intermediate',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: (() {
                      setState(() {
                        if (isAdvanced == true) {
                          isAdvanced = false;
                          _searchPlacesQuery.clear();
                          ;
                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }
                          setState(() {
                            _searchServices = _searchPlacesQuery;
                          });
                        } else {
                          _searchPlacesQuery.clear();
                          for (int i = 0; i < _services.length; i++) {
                            if (_services[i]
                                .serviceName
                                .toLowerCase()
                                .contains(query.toLowerCase())) {
                              _searchPlacesQuery.add(_services[i]);
                            }
                          }
                          List<Services> _filterAdvanced = [];
                          for (int i = 0; i < _searchPlacesQuery.length; i++) {
                            if (_searchPlacesQuery[i].isAdvanced == true) {
                              _filterAdvanced.add(_searchPlacesQuery[i]);
                            }
                          }

                          setState(() {
                            _searchServices = _filterAdvanced;
                          });

                          isAdvanced = true;
                          isBeginner = false;
                          isIntermediate = false;
                        }
                      });
                    }),
                    style: (isAdvanced == true)
                        ? ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))))
                        : ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                    child: const Text(
                      'Advanced',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _searchServices.length,
              itemBuilder: (context, index) {
                return buildSearchItem(_searchServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchItem(Services item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewServiceScreen(
                  serviceId: item.id,
                  trainerName: item.trainer,
                  clientEmail: _account.first.emailAddress,
                  serviceName: item.serviceName,
                )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.network(
              item.serviceBgPhoto,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '${item.serviceName}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            'Instructor: ${item.trainer}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
            ),
          ),
          if (item.isBeginner == true &&
              item.isIntermediate == false &&
              item.isAdvanced == false)
            Text(
              "Beginner",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == true &&
              item.isIntermediate == true &&
              item.isAdvanced == false)
            Text(
              "Beginner - Intermediate",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == true &&
              item.isIntermediate == false &&
              item.isAdvanced == true)
            Text(
              "Beginner - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == true &&
              item.isAdvanced == false)
            Text(
              "Intermediate",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == true &&
              item.isAdvanced == true)
            Text(
              "Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else if (item.isBeginner == false &&
              item.isIntermediate == false &&
              item.isAdvanced == true)
            Text(
              "Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            )
          else
            Text(
              "Beginner - Intermediate - Advanced",
            overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}
