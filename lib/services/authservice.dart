import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Handles Auth
  // handleAuth() {
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.aauthStateChanges(),
  //       builder: (BuildContext context, snapshot) {
  //         if (snapshot.hasData) {
  //           return UserNavBottom();
  //         } else {
  //           return LoginPage();
  //         }
  //       });
  // }

  signOut() async {
    FirebaseAuth.instance.signOut();
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}
