import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/screen/chat/chat_page.dart';
import 'package:chat/src/screen/group/group_page.dart';
import 'package:chat/src/screen/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TestNav extends StatefulWidget {
  final titles = ['Home', 'Group', 'Chat'];

  final icons = [
    AssetImage('assets/images/ic_home_nav.png'),
    AssetImage('assets/images/ic_group.png'),
    AssetImage('assets/images/ic_chat.png'),
  ];

  @override
  _TestNavState createState() => _TestNavState();
}

class _TestNavState extends State<TestNav> with WidgetsBindingObserver {
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
    });
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message['notification']}");
        sendNotification(
          title: message['notification']['title'],
          body: message['notification']['body'],
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Token : $token");
    });
  }

  void sendNotification({String title, String body}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      111,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        AppModel.user.isActive = false;
        AppModel.user.lastTimeUpdate = DateTime.now().toString();
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
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void updateIsActive() {
    Firestore _databaseReference = Firestore.instance;
    _databaseReference
        .collection('Users')
        .document(AppString.uid)
        .setData(AppModel.user.toJson());
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
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[HomePage(), GroupPage(), ChatPage()],
              onPageChanged: (page) {},
            ),
          ),
          bottomNavigationBar: BubbledNavigationBar(
            controller: _menuPositionController,
            initialIndex: 0,
            itemMargin: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Color(0xff242424),
            defaultBubbleColor: Colors.blue,
            onTap: (index) {
              _pageController.animateToPage(index,
                  curve: Curves.easeInOutQuad,
                  duration: Duration(milliseconds: 600));
            },
            items: widget.titles.map((title) {
              var index = widget.titles.indexOf(title);

              return BubbledNavigationBarItem(
                icon: getIcon(index, Colors.white),
                activeIcon: getIcon(index, Colors.black),
                bubbleColor: Colors.white,
                title: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              );
            }).toList(),
          )),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ImageIcon(widget.icons[index], size: 35, color: color),
    );
  }
}
