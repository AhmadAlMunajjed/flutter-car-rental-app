import 'dart:async';
import 'dart:io';
import 'package:car_rental_app_ui/constants/app_constants.dart';
import 'package:car_rental_app_ui/constants/color_constants.dart';
import 'package:car_rental_app_ui/model/user_chat.dart';
import 'package:car_rental_app_ui/pages/chat_screen/chat_page.dart';
import 'package:car_rental_app_ui/pages/chat_screen/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatList extends StatefulWidget {
  final String currentUserId;

  ChatList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State createState() => ChatListState(currentUserId: currentUserId);
}

class ChatListState extends State<ChatList> {
  ChatListState({Key? key, required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    Choice(title: 'Settings', icon: Icons.settings),
    Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance.collection('users').doc(currentUserId).update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = const IOSInitializationSettings();
    InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
     // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: ColorConstants.themeColor,
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(bottom: 10.0),
                    ),
                    const Text(
                      'Exit app',
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.cancel,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                    ),
                    const Text(
                      'CANCEL',
                      style: TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.check_circle,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: const EdgeInsets.only(right: 10.0),
                    ),
                    const Text(
                      'YES',
                      style: TextStyle(color: ColorConstants.primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

   /* await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();*/

    this.setState(() {
      isLoading = false;
    });

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        automaticallyImplyLeading: true,
        title: const Text(
          AppConstants.homeTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
     // drawer: DrawerSide(),
      body: Stack(
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').limit(_limit).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                    buildItem(context, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    controller: listScrollController,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.primaryColor),
                    ),
                  );
                }
              },
            ),
          ),

          // Loading
          Positioned(
            child: isLoading ? const Loading() : Container(),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                    userChat.photoUrl,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: ColorConstants.primaryColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: ColorConstants.greyColor,
                      );
                    },
                  )
                      : const Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: ColorConstants.greyColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Full Name: ${userChat.nickname}',
                            maxLines: 1,
                            style: const TextStyle(color: ColorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                       /* Container(
                          child: Text(
                            'About me: ${userChat.aboutMe}',
                            maxLines: 1,
                            style: const TextStyle(color: ColorConstants.primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        )*/
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    peerId: userChat.id,
                    peerAvatar: userChat.photoUrl,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
