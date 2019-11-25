import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:trackapp/models/userModel.dart';

final facebookLogin = FacebookLogin();

Future<FirebaseUser> signInWithFB() async {
  final result = await facebookLogin.logIn(['email']);
  switch (result.status) {
    case FacebookLoginStatus.error:
      print("Error");

      return null;
      break;
    case FacebookLoginStatus.cancelledByUser:
      print("Cancelled by user");
      return null;
      break;
    case FacebookLoginStatus.loggedIn:
      print("Logged in");
      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: myToken.token);
      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();
      assert(user.uid == currentUser.uid);
      return user;

      break;
  }
}
