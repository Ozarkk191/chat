import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/login/login_page.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String tokenCheck = "";
  String _initialLink;
  Uri _initialUri;
  String _latestLink = 'Unknown';
  Uri _latestUri;

  StreamSubscription _sub;

  UniLinksType _type = UniLinksType.string;

  @override
  void initState() {
    super.initState();
    if (_initialUri != null) {
      log(_initialUri.toString());
    }
    initPlatformState();
    _messaging.getToken().then((token) {
      tokenCheck = token;
    });
  }

  @override
  void dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  _checkInternet({String link}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _check(link: link);
      }
    } on SocketException catch (_) {
      _dialogInternetShow(
          title: "แจ้งเตือน", content: "ไม่พบสัญญาณอินเตอร์เน็ต");
    }
  }

  _check({String link}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    List<String> _listUID = List<String>();
    if (user != null) {
      await _databaseReference
          .collection('Users')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          _listUID.add(value.documentID);
        });
      }).then((value) {
        var uid = _listUID.where((element) => element == user.uid);
        if (uid.length != 0) {
          _getPorfile(link: link);
        } else {
          AuthService().signOut();
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          });
        }
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      });
    }
  }

  _getPorfile({String link}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    _databaseReference
        .collection('Users')
        .document(user.uid)
        .get()
        .then((value) {
      // var userModel = UserModel.fromJson(value.data);
      AppModel.user = UserModel.fromJson(value.data);
      if (AppModel.user.banned) {
        _dialogShow(title: "แจ้งเตือน", content: "คุณถูกแบนออกจากระบบ");
      } else {
        if (AppModel.user.notiToken != tokenCheck) {
          AppModel.user.notiToken = tokenCheck;
          _databaseReference
              .collection('Users')
              .document(user.uid)
              .setData(AppModel.user.toJson());
        }
        AppModel.user.isActive = true;
        AppModel.user.lastTimeUpdate = DateTime.now().toString();
        _databaseReference
            .collection('Users')
            .document(user.uid)
            .setData(AppModel.user.toJson());

        if (link == null) {
          if (AppModel.user.roles == TypeStatus.USER.toString()) {
            Navigator.of(context).pushReplacementNamed('/navuserhome');
          } else {
            Navigator.of(context).pushReplacementNamed('/navhome');
          }
        } else {
          _goToGroup(link);
        }
      }
    });
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
      log('got link: $link');
      // _checkLink = true;
    }, onError: (Object err) {
      print('got err: $err');
    });

    // Get the latest link
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _initialLink = await getInitialLink();
      _checkInternet(link: _initialLink);
      log('initial link: $_initialLink');
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
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: Center(
        child: Container(
          width: 200,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }

  Future<bool> _dialogShow({String title, String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('$title'),
            content: new Text('$content'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ตกลง"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _dialogInternetShow({String title, String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('$title'),
            content: new Text('$content'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ตกลง"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _goToGroup(String link) async {
    if (link != null) {
      List<String> _groupID = List<String>();
      var str = link.split("uid=");
      link = str[1];
      log(link);
      Firestore _databaseReference = Firestore.instance;
      await _databaseReference
          .collection("Rooms")
          .document("chats")
          .collection("Group")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          _groupID.add(value.documentID);
        });
      }).then((value) {
        var id = _groupID.where((element) => element == link).toList();
        log(id.length.toString());
        if (id.length == 0) {
          if (AppModel.user.roles == TypeStatus.USER.toString()) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserNavBottom()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TestNav()));
            // Navigator.of(context).pushReplacementNamed('/navhome');
          }
        } else {
          _getGroup(link);
        }
        setState(() {});
      });
    }
  }

  _getGroup(String groupID) async {
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(groupID)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatGroupPage(
            groupName: group.nameGroup,
            groupID: group.groupID,
            id: group.id,
          ),
        ),
      );
    });
  }
}
