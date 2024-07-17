import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexedfitness/model/account.dart';
import 'package:flexedfitness/model/class.dart';
import 'package:flexedfitness/screen/Trainer/bottomTrainerNavigation.dart';
import 'package:flexedfitness/screen/User/bottomUserNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

const appId = "08ec38b65e064d048ee1b3f6ec648a1f";
const token =
    "007eJxTYMhvXaMzJ7ar4HxjqbXdvKT3B3Sq11tHXn7868othzMhSicVGAwsUpONLZLMTFMNzExSDEwsUlMNk4zTzFKTzUwsEg3TbK6lpTYEMjK8CWVjYIRCEJ+bISQjtTizWNclNTefgQEAuVMjbg==";
const channel = "Thesis-Demo";

class VideoCall extends StatefulWidget {
  final String classId;
  final String email;
  final bool isUser;
  const VideoCall({
    required this.classId,
    required this.email,
    required this.isUser,
    Key? key,
  });

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  late final AgoraClient client;
  bool isClicked = false;
  bool isLoaded = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController descriptionControllerFB = TextEditingController();
  double rating = 0.0;
  
  
  double consisRate = 0.0;
  double formTechRate = 0.0;
  double enduRate = 0.0;
  double balStabRate =  0.0;
  double commRate = 0.0;
  double adaptRate = 0.0;

  var uuid = const Uuid();
  var uuid2 = const Uuid();
  String _uid = "";
  String _uid2 = "";

  @override
  void initState() {
    super.initState();
    initAgora();
    setState(() {
      isLoaded = true;
    });
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "08ec38b65e064d048ee1b3f6ec648a1f",
        channelName: "Thesis-Demo",
        username: widget.email,
        tempToken:
            "007eJxTYMhvXaMzJ7ar4HxjqbXdvKT3B3Sq11tHXn7868othzMhSicVGAwsUpONLZLMTFMNzExSDEwsUlMNk4zTzFKTzUwsEg3TbK6lpTYEMjK8CWVjYIRCEJ+bISQjtTizWNclNTefgQEAuVMjbg==",
      ),
    );

    // Retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }
  
  void feedbackFunction(String description, double consisRate, 
  double formTechRate, double enduRate, double balStabRate, double commRate, double adaptRate ) async {
    final List<ClientClass> _class = [];

    // Implement your logic here, e.g., sending the rating to a server

    // Add your logic for handling the rating and description

    FirebaseFirestore.instance
        .collection('Client Class')
        .where('id',
            isEqualTo: widget.classId) // Replace with the desired email address
        .get()
        .then((querySnapshot) async {
          querySnapshot.docs.forEach((doc) {
            final account = ClientClass.fromJson(doc.data());
            _class.add(account);
      });

      if (_class.isNotEmpty) {
        print('Description: $description');
        print('Rating: $rating');

        _uid2 = uuid2.v4();

        final trainerFeedback =
            FirebaseFirestore.instance.collection('Trainer Feedback').doc(_uid2);

        final dataFB = {
          'id': _uid2,
          'clientEmail': _class.first.userEmail,
          "clientName": _class.first.clientName,
          
          "trainerName": _class.first.trainer,
          'trainerEmail': _class.first.trainerEmail,
          
          "dateFeedback": Timestamp.now(),

          'classID': _class.first.id,
          'serviceName': _class.first.serviceName,
          'serviceLevel': _class.first.serviceLevel,

          "consisRate": consisRate.toString(),
          "formTechRate": formTechRate.toString(),
          "enduRate": enduRate.toString(),
          "balStabRate": balStabRate.toString(),
          "commRate": commRate.toString(),
          "adaptRate": adaptRate.toString(),

          "description": description,

          
        };
        trainerFeedback.set(dataFB);  
        

        // await FirebaseFirestore.instance
        //     .collection('Client Class')
        //     .doc(widget.classId)
        //     .update({'status:': 'Completed'});
      } else {
        print('Error in fetching account information');
      }
      // Move the print statement inside the then() block
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });
  }

  void rateFunction(String description, double rating) async {
    final List<ClientClass> _class = [];

    // Implement your logic here, e.g., sending the rating to a server

    // Add your logic for handling the rating and description

    FirebaseFirestore.instance
        .collection('Client Class')
        .where('id',
            isEqualTo: widget.classId) // Replace with the desired email address
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((doc) {
        final account = ClientClass.fromJson(doc.data());
        _class.add(account);
      });

      if (_class.isNotEmpty) {
        print('Description: $description');
        print('Rating: $rating');

        _uid = uuid.v4();

        final userReviews =
            FirebaseFirestore.instance.collection('User Reviews').doc(_uid);

        final data = {
          'id': _uid,
          'serviceName': _class.first.serviceName,
          'userEmail': _class.first.userEmail,
          'trainerEmail': _class.first.trainerEmail,
          "serviceImage": _class.first.serviceBgPhoto,
          "dateReviewed": Timestamp.now(),
          "rating": rating.toString(),
          "trainerName": _class.first.trainer,
          "description": description,
          "clientName": _class.first.clientName,
        };
        userReviews.set(data);

        await FirebaseFirestore.instance
            .collection('Client Class')
            .doc(widget.classId)
            .update({'status:': 'Completed'});
      } else {
        print('Error in fetching account information');
      }
      // Move the print statement inside the then() block
    }).catchError((error) {
      print('Error getting documents: $error');
      // Handle the error as needed (e.g., showing an error message).
    });
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoaded == true)
        ? WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(
                      child: _remoteVideo(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: Center(
                          child: _localUserJoined
                              ? AgoraVideoView(
                                  controller: VideoViewController(
                                    rtcEngine: _engine,
                                    canvas: const VideoCanvas(uid: 0),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: AgoraVideoButtons(
                        client: client,
                        autoHideButtons: true,
                        autoHideButtonTime: 10,
                        onDisconnect: () async {
                          await _engine.muteLocalAudioStream(true);
                          BuildContext dialogContext = context;
                          if (widget.isUser) {
                            await showDialog(
                              context: dialogContext,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Rate Your Experience'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: descriptionController,
                                        maxLines: 3,
                                        decoration:
                                            InputDecoration(labelText: 'Description'),
                                      ),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            rating = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Client Class')
                                            .doc(widget.classId)
                                            .update({'status:': 'Completed'});
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No Thanks'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        rateFunction(
                                            descriptionController.text, rating);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Rate'),
                                    ),
                                  ],
                                );
                              },
                            );

                            Navigator.of(dialogContext).push(
                              MaterialPageRoute(
                                builder: (context) => UserPage(indexNo: 0),
                              ),
                            );
                          } else {
                            await showDialog(
                              context: dialogContext,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Give Feedback for Client'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //CONSISTENCY RATING
                                      SizedBox(height: 10),
                                      Text("Consistency"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: consisRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            consisRate = value;
                                          });
                                        },
                                      ),
                                      //CONSISTENCY RATING

                                      //FORM & TECHNIQUE
                                      SizedBox(height: 10),
                                      Text("Form & Technique"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: formTechRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            formTechRate = value;
                                          });
                                        },
                                      ),

                                      //ENDURANCE
                                      SizedBox(height: 10),
                                      Text("Endurance"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: enduRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            enduRate = value;
                                          });
                                        },
                                      ),

                                      //BALANCE AND STABILITY
                                      SizedBox(height: 10),
                                      Text("Balance & Stability"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: balStabRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            balStabRate = value;
                                          });
                                        },
                                      ),

                                        //ADAPTABILITY
                                      SizedBox(height: 10),
                                      Text("Adaptability"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: adaptRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            adaptRate = value;
                                          });
                                        },
                                      ),

                                      //COMMUNICATION
                                      SizedBox(height: 10),
                                      Text("Communication"),
                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: commRate,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            commRate = value;
                                          });
                                        },
                                      ),

                                      TextField(
                                        controller: descriptionControllerFB,
                                        maxLines: 6,
                                        decoration:
                                            InputDecoration(labelText: 'Comments'),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  actions: [
                                    
                                    ElevatedButton(
                                      onPressed: () {
                                        feedbackFunction(
                                            descriptionControllerFB.text, consisRate, formTechRate, enduRate, balStabRate, adaptRate, commRate);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Send Feedback'),
                                    ),
                                  ],
                                );
                              },
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TrainerPage(indexNo: 0),
                              ),
                            );
                          }
                          
                          dispose();
                        },
                       

                        // addScreenSharing: (widget.isUser == false)
                        //     ? true
                        //     : false,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                )),
          );
  }

  @override
  void dispose() async{
    await _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }
}
