import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/base_compoments/button/custom_icon_button.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        break;
      case FacebookLoginStatus.error:
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logo.png'),
          ),
          GradientButton(
            title: 'Register',
            callBack: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginNewPage()));
              // Navigator.pushNamed(context, '/register');
            },
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
    );
  }

  void saveDataUser(FirebaseUser user) {
    var name = user.displayName.split(" ");

    AppString.uid = user.uid;
    AppString.firstname = name[0];
    AppString.lastname = name[1];
    AppString.email = user.email;
    AppString.dateTime = dateTime;
    AppString.displayName = user.displayName;
    AppString.phoneNumber = "null";
    AppString.roles = TypeStatus.USER.toString();
    AppString.photoUrl = user.photoUrl;
    Navigator.pushNamed(context, '/data');

    // if (user.phoneNumber == null) {
    //   _databaseReference
    //       .collection("Users")
    //       .getDocuments()
    //       .then((QuerySnapshot snapshot) {
    //     snapshot.documents.forEach((value) {
    //       if (value.documentID == user.uid) {
    //         _databaseReference
    //             .collection('Users')
    //             .document(user.uid)
    //             .get()
    //             .then((value) {
    //           var userModel = UserModel.fromJson(value.data);
    //           AppString.displayName = userModel.displayName;
    //           AppString.firstname = userModel.firstName;
    //           AppString.lastname = userModel.lastName;
    //           AppString.birthDate = userModel.birthDate;
    //           AppString.email = userModel.email;
    //           AppString.notiToken = userModel.notiToken;
    //           AppString.phoneNumber = userModel.phoneNumber;
    //           AppString.roles = userModel.roles;
    //           AppString.dateTime = userModel.updatedAt;
    //           AppString.isActive = userModel.isActive;
    //           AppString.gender = userModel.gender;

    // if (AppString.roles == '${TypeStatus.USER}') {
    //             Navigator.of(context).pushReplacementNamed('/navuserhome');
    //           } else {
    //             Navigator.of(context).pushReplacementNamed('/navhome');
    //           }
    //         });
    //       } else {
    //         AppString.uid = user.uid;
    //         AppString.firstname = name[0];
    //         AppString.lastname = name[1];
    //         AppString.email = user.email;
    //         AppString.dateTime = dateTime;
    //         AppString.displayName = user.displayName;
    //         AppString.phoneNumber = "null";
    //         AppString.roles = TypeStatus.USER.toString();
    //         AppString.photoUrl = user.photoUrl;
    //
    //       }
    //     });
    //   });
    // } else {
    //   var data = UserModel(
    //     firstName: "${name[0]}",
    //     lastName: "${name[1]}",
    //     notiToken: AppString.notiToken,
    //     phoneNumber: "${user.phoneNumber}",
    //     email: "${user.email}",
    //     displayName: "${user.displayName}",
    //     gender: "ไม่ระบุ",
    //     birthDate: "ไม่ระบุ",
    //     isActive: false,
    //     roles: TypeStatus.USER.toString(),
    //     createdAt: dateTime,
    //     updatedAt: dateTime,
    //     avatarUrl: user.photoUrl,
    //   );
    //   _databaseReference
    //       .collection("Users")
    //       .document(user.uid)
    //       .setData(data.toJson());
    // }
  }
}
