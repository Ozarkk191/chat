import 'dart:developer';

import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/src/base_compoments/navigation/navigation_bar.dart';
import 'package:chat/src/base_compoments/navigation/navigation_bar_item.dart';
import 'package:chat/src/base_compoments/navigation/navigation_bay_theme.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/group/user_group_page.dart';
import 'package:chat/src/screen/home/user_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserNavBottom extends StatefulWidget {
  // final titles = ['Home', 'Group', 'Chat'];

  // final icons = [
  //   AssetImage('assets/images/ic_home_nav.png'),
  //   AssetImage('assets/images/ic_group.png'),
  //   AssetImage('assets/images/ic_chat.png'),
  // ];
  final int currentIndex;

  UserNavBottom({Key key, this.currentIndex = 0}) : super(key: key);

  @override
  _UserNavBottomState createState() => _UserNavBottomState();
}

enum UniLinksType { string, uri }

class _UserNavBottomState extends State<UserNavBottom>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  // final _databaseReference = Firestore.instance;
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var _messages;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      return null;
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      setState(() {
        payload = _messages['data']['data'].toString();
        log(payload.toString());
        var data = payload.split("&&");
        GroupModel group;
        Firestore.instance
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(data[1])
            .get()
            .then((value) {
          group = GroupModel.fromJson(value.data);
        }).then((value) {
          if (data[2] == "group") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatGroupPage(
                  groupID: data[1],
                  groupName: data[0],
                  id: data[3],
                  group: group,
                ),
              ),
            );
          }
        });
      });
      return null;
    });

    _menuPositionController =
        MenuPositionController(initPosition: _currentIndex);
    _pageController = PageController();

    _pageController = PageController(
        initialPage: _currentIndex, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(_handlePageChange);

    initFirebaseMessaging();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _messages = message;
        setState(() {});
        sendNotification(
          title: message['notification']['title'],
          body: message['notification']['body'],
        );
      },
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});

    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });
  }

  void sendNotification({String title, String body}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(111, title, body, platformChannelSpecifics, payload: "");
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        AppModel.user.isActive = false;
        updateIsActive();
        break;
      case AppLifecycleState.resumed:
        AppModel.user.isActive = true;
        updateIsActive();
        break;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void updateIsActive() async {
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection('Users')
        .document(AppModel.user.uid)
        .setData(AppModel.user.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
            return;
          },
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              UserHomePage(),
              UserGruopPage(),
            ],
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        bottomNavigationBar: NavigationBar(
          theme: NavigationBarTheme(
            barBackgroundColor: Colors.black,
            selectedItemBorderColor: Color(0xffaaaaaa),
            selectedItemBackgroundColor: Color(0xffffffff),
            selectedItemIconColor: Colors.black,
            selectedItemLabelColor: Colors.white,
          ),
          selectedIndex: _currentIndex,
          onSelectTab: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: [
            NavigationBarItem(
              iconData: 'assets/images/ic_home_nav.png',
              label: 'Home',
            ),
            NavigationBarItem(
              iconData: 'assets/images/ic_chat.png',
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
