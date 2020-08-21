import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/chat/chat_page.dart';
import 'package:chat/src/screen/chat/chat_room_page.dart';
import 'package:chat/src/screen/group/group_page.dart';
import 'package:chat/src/screen/home/user_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

class UserNavBottom extends StatefulWidget {
  final titles = ['Home', 'Group', 'Chat'];

  final icons = [
    AssetImage('assets/images/ic_home_nav.png'),
    AssetImage('assets/images/ic_group.png'),
    AssetImage('assets/images/ic_chat.png'),
  ];

  @override
  _UserNavBottomState createState() => _UserNavBottomState();
}

enum UniLinksType { string, uri }

class _UserNavBottomState extends State<UserNavBottom>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var _messages;

  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  Uri _latestUri;

  StreamSubscription _sub;

  UniLinksType _type = UniLinksType.string;

  final List<String> _cmds = getCmds();
  final TextStyle _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
        var data = payload.split("&&");
        if (data[2] == "room") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomPage(
                keyRoom: data[0],
                uid: data[1],
              ),
            ),
          );
        } else if (data[2] == "group") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatGroupPage(
                groupID: data[1],
                groupName: data[0],
                id: data[3],
              ),
            ),
          );
        }
      });
      return null;
    });

    _menuPositionController = MenuPositionController(initPosition: 0);
    _pageController = PageController();

    if (_initialUri != null) {
      log(_initialUri.toString());
    }

    initFirebaseMessaging();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: ${message['data']}");
        _messages = message;
        setState(() {});
        sendNotification(
          title: message['notification']['title'],
          body: message['notification']['body'],
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      // print("Settings registered: $settings");
    });

    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // print("Token : $token");
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
    if (_sub != null) _sub.cancel();
    _pageController.dispose();
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

  Future<void> initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      if (_initialLink != null) _initialUri = Uri.parse(_initialLink);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = _initialLink;
      _latestUri = _initialUri;
    });
  }

  Future<void> initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (Object err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest Uri
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialUri = await getInitialUri();
      print('initial uri: ${_initialUri?.path}'
          ' ${_initialUri?.queryParametersAll}');
      _initialLink = _initialUri?.toString();
    } on PlatformException {
      _initialUri = null;
      _initialLink = 'Failed to get initial uri.';
    } on FormatException {
      _initialUri = null;
      _initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = _initialUri;
      _latestLink = _initialLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryParams = _latestUri?.queryParametersAll?.entries?.toList();
    queryParams?.map((item) {
      log('${item.key}');
      log('${item.value?.join(', ')}');
    })?.toList();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
            return;
          },
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              UserHomePage(),
              GroupPage(),
              ChatPage(),
            ],
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Color(0xff202020),
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: Text('Home'),
              textAlign: TextAlign.center,
              activeColor: Colors.white,
              icon: Image.asset('assets/images/ic_home_nav.png',
                  color: Colors.white),
            ),
            BottomNavyBarItem(
              title: Text('Group'),
              textAlign: TextAlign.center,
              activeColor: Colors.white,
              icon: Image.asset(
                'assets/images/ic_group.png',
                color: Colors.white,
              ),
            ),
            BottomNavyBarItem(
              title: Text('Chat'),
              textAlign: TextAlign.center,
              activeColor: Colors.white,
              icon: Image.asset(
                'assets/images/ic_chat.png',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ImageIcon(widget.icons[index], size: 35, color: color),
    );
  }

  Widget _cmdsCard(List<String> commands) {
    Widget platformCmds;

    if (commands == null) {
      platformCmds = const Center(child: const Text('Unsupported platform'));
    } else {
      platformCmds = new Column(
        children: <List<Widget>>[
          [
            const Text(
                'To populate above fields open a terminal shell and run:\n')
          ],
          intersperse(
              commands.map<Widget>((cmd) => new InkWell(
                    onTap: () => _printAndCopy(cmd),
                    child: new Text('\n$cmd\n', style: _cmdStyle),
                  )),
              const Text('or')),
          [
            new Text(
                '(tap on any of the above commands to print it to'
                ' the console/logger and copy to the device clipboard.)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption),
          ]
        ].expand((el) => el).toList(),
      );
    }

    return new Card(
      margin: const EdgeInsets.only(top: 20.0),
      child: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: platformCmds,
      ),
    );
  }

  Future<void> _printAndCopy(String cmd) async {
    print(cmd);

    await Clipboard.setData(new ClipboardData(text: cmd));
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: const Text('Copied to Clipboard'),
    ));
  }
}

List<String> getCmds() {
  String cmd;
  String cmdSuffix = '';

  if (Platform.isIOS) {
    cmd = '/usr/bin/xcrun simctl openurl booted';
  } else if (Platform.isAndroid) {
    cmd = '\$ANDROID_HOME/platform-tools/adb shell \'am start'
        ' -a android.intent.action.VIEW'
        ' -c android.intent.category.BROWSABLE -d';
    cmdSuffix = "'";
  } else {
    return null;
  }

  // https://orchid-forgery.glitch.me/mobile/redirect/
  return [
    '$cmd "unilinks://host/path/subpath"$cmdSuffix',
    '$cmd "unilinks://secretchat.store/path/portion/?uid=123&token=abc"$cmdSuffix',
    '$cmd "unilinks://secretchat.store/?arr%5b%5d=123&arr%5b%5d=abc'
        '&addr=1%20Nowhere%20Rd&addr=Rand%20City%F0%9F%98%82"$cmdSuffix',
  ];
}

List<Widget> intersperse(Iterable<Widget> list, Widget item) {
  final initialValue = <Widget>[];
  return list.fold(initialValue, (all, el) {
    if (all.length != 0) all.add(item);
    all.add(el);
    return all;
  });
}
