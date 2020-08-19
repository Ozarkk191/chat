import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/button/custom_icon_button.dart';
import 'package:chat/src/screen/register/data_collect_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();
  final _databaseReference = Firestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  bool isLogged = false;
  bool _loadingOverlay = false;

  var toDay = new DateTime.now();
  String dateTime = "";

  Future<String> _signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    saveDataUser(user);
    return 'signInWithGoogle succeeded: $user';
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

  void _logout() async {
    FirebaseAuth.instance.signOut();
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
  }

  @override
  void initState() {
    super.initState();
    _logout();
    AppModel.user = null;
    _messaging.getToken().then((token) {
      AppString.notiToken = token;
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
            // GradientButton(
            //   title: 'Register',
            //   callBack: () {
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (context) => LoginNewPage()));
            //     // Navigator.pushNamed(context, '/register');
            //   },
            // ),
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
          AppString.displayName = AppModel.user.displayName;
          AppString.firstname = AppModel.user.firstName;
          AppString.lastname = AppModel.user.lastName;
          AppString.birthDate = AppModel.user.birthDate;
          AppString.email = AppModel.user.email;
          // AppString.notiToken = userModel.notiToken;
          AppString.phoneNumber = AppModel.user.phoneNumber;
          AppString.roles = AppModel.user.roles;
          AppString.photoUrl = AppModel.user.avatarUrl;
          AppString.dateTime = AppModel.user.updatedAt;
          // AppString.isActive = userModel.isActive;
          AppString.gender = AppModel.user.gender;
          AppString.coverUrl = AppModel.user.coverUrl;

          AppModel.user.lastTimeUpdate = DateTime.now().toString();
          _databaseReference
              .collection('Users')
              .document(AppModel.user.uid)
              .updateData({
            "lastTimeUpdate": DateTime.now().toString(),
            "notiToken": AppString.notiToken,
            "isActive": true
          });

          if (AppString.roles == '${TypeStatus.USER}') {
            Navigator.of(context).pushReplacementNamed('/navuserhome');
          } else {
            Navigator.of(context).pushReplacementNamed('/navhome');
          }
        }
      });
    } else {
      _savePhoneNumber(user: user);
    }
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
    AppModel.user.notiToken = AppString.notiToken;
    AppModel.user.displayName = user.displayName;
    AppModel.user.phoneNumber = "null";
    AppModel.user.roles = TypeStatus.USER.toString();
    AppModel.user.avatarUrl = user.photoUrl;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DataCollectPage(
                  user: user,
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
