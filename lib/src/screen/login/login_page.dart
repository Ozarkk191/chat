import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/button/custom_icon_button.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:chat/src/screen/register/data_collect_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  final String link;

  const LoginPage({Key key, this.link}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  // GoogleSignInAccount _currentUser;
  FacebookLogin facebookLogin = FacebookLogin();
  final _databaseReference = Firestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  bool isLogged = false;
  bool _loadingOverlay = false;
  String _token;

  var toDay = new DateTime.now();
  String dateTime = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      saveDataUser(user);
      return 'signInWithGoogle succeeded: $user';
    } catch (error) {
      print(error);
    }
  }

  _loginWithFacebook() async {
    setState(() {
      _loadingOverlay = true;
    });
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;

        await _auth.signInWithCredential(
            FacebookAuthProvider.getCredential(accessToken: token));
        final FirebaseUser user = await _auth.currentUser();
        // Navigator.of(context).pushReplacementNamed('/navhome');

        saveDataUser(user);
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          _loadingOverlay = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          _loadingOverlay = false;
        });
        break;
      default:
    }
  }

  // void _logout() async {
  //   FirebaseAuth.instance.signOut();
  //   await FacebookLogin().logOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  void initState() {
    super.initState();
    // _logout();
    _messaging.getToken().then((token) {
      _token = token;
    });
    var date = toDay.toString().split(".");
    dateTime = date[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: LoadingOverlay(
        isLoading: _loadingOverlay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomIconButton(
                  path: 'assets/images/ic_facebook.png',
                  callBack: _loginWithFacebook,
                ),
                SizedBox(width: 20),
                CustomIconButton(
                  path: 'assets/images/ic_email.png',
                  callBack: _signInWithGoogle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveDataUser(FirebaseUser user) async {
    setState(() {
      _loadingOverlay = true;
    });
    List<String> _memberList = List<String>();

    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) => {
              snapshot.documents.forEach((value) {
                if (value != null) {
                  _memberList.add(value.documentID);
                } else {
                  _savePhoneNumber(user: user);
                }
              })
            });
    var member = _memberList.where((element) => element == user.uid);
    if (member.length != 0) {
      await _databaseReference
          .collection('Users')
          .document(user.uid)
          .get()
          .then((value) {
        // var userModel = UserModel.fromJson(value.data);
        AppModel.user = UserModel.fromJson(value.data);
        if (AppModel.user.banned) {
          _dialogShow(title: "แจ้งเตือน", content: "คุณถูกแบนออกจากระบบ");
        } else {
          AppModel.user.lastTimeUpdate = DateTime.now().toString();
          _databaseReference
              .collection('Users')
              .document(AppModel.user.uid)
              .updateData({
            "lastTimeUpdate": DateTime.now().toString(),
            "notiToken": _token,
            "isActive": true
          });
          log("id :: ${widget.link}");
          if (widget.link != null) {
            _goToGroup(widget.link);
          } else {
            if (AppModel.user.roles == '${TypeStatus.USER}') {
              Navigator.of(context).pushReplacementNamed('/navuserhome');
            } else {
              Navigator.of(context).pushReplacementNamed('/navhome');
            }
          }
        }
      });
    } else {
      _savePhoneNumber(user: user);
    }
  }

  void _goToGroup(String link) async {
    if (link != null) {
      List<String> _groupID = List<String>();
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
          }
        } else {
          _getGroup(link);
        }
        setState(() {});
      });
    }
  }

  _getGroup(String groupID) async {
    List<dynamic> _memberList = List<String>();
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(groupID)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      _memberList = group.memberUIDList;

      var member =
          _memberList.where((element) => element == AppModel.user.uid).toList();
      if (member.length == 0) {
        _memberList.add(AppModel.user.uid);
        _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(groupID)
            .updateData({"memberUIDList": _memberList}).then((value) {
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
      } else {
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
      }
    });
  }

  void _savePhoneNumber({@required FirebaseUser user}) {
    List<dynamic> grouplist = [];
    AppModel.user = UserModel(
      firstName: "null",
      lastName: "null",
      notiToken: "null",
      phoneNumber: "null",
      email: "null",
      displayName: "null",
      gender: "null",
      birthDate: "null",
      isActive: true,
      roles: "null",
      createdAt: "null",
      updatedAt: "null",
      avatarUrl: "null",
      groupKey: grouplist,
      coverUrl: "null",
      uid: "null",
      lastTimeUpdate: "null",
      banned: false,
    );
    if (user.displayName.contains(" ")) {
      var name = user.displayName.split(" ");
      AppModel.user.firstName = name[0];
      AppModel.user.lastName = name[1];
    } else {
      AppModel.user.firstName = user.displayName;
      AppModel.user.lastName = "";
    }
    AppModel.user.uid = user.uid;
    AppModel.user.email = user.email;
    AppModel.user.createdAt = dateTime;
    AppModel.user.updatedAt = dateTime;
    AppModel.user.displayName = user.displayName;
    AppModel.user.phoneNumber = "null";
    AppModel.user.roles = TypeStatus.USER.toString();
    AppModel.user.avatarUrl = user.photoUrl;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DataCollectPage(
                  user: user,
                  link: widget.link,
                )));
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
                  setState(() {
                    AuthService().signOut();
                    _loadingOverlay = false;
                  });
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
}
