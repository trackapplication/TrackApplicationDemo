import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trackapp/blocs/authBloc/auth_bloc.dart';
import 'package:trackapp/blocs/authBloc/bloc.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/dashboard.dart';
import 'package:trackapp/pages/forgot_pass.dart';
import 'package:trackapp/pages/signup_page.dart';
import 'package:trackapp/services/emailSignUp.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/services/fbAuth.dart';
import 'package:trackapp/services/googleSignIn.dart';

Size size = Size(0, 0);

final GoogleSignIn googleSignIn = GoogleSignIn();
final facebookLogin = FacebookLogin();

class LoginProvider extends StatefulWidget {
  @override
  _LoginProviderState createState() => _LoginProviderState();
}

class _LoginProviderState extends State<LoginProvider> {
  @override
  Widget build(BuildContext context) => BlocProvider(
        builder: (context) => AuthBloc(),
        child: LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin fbLogin = new FacebookLogin();

  bool check = true;
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) =>
      setState(() => this.isLoggedIn = isLoggedIn);

  @override
  Widget build(BuildContext theContext) {
    //size = MediaQuery.of(context).size;
    Size size = MediaQuery.of(context).size;

    final loginButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: () async {
        try {
          showProgressBar();
          await signInWithEmailAndPassword(_email.text, _password.text);
          final user = await FirebaseAuth.instance.currentUser();
          //User person.uid = user.uid;
          final docs = await usersRef.document(user.uid).get();
          User().fromJson(docs.data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } catch (e) {}
      },
      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
      color: Colors.green.shade800,
      child: Text('Log In',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontFamily: "Product Sans")),
    );
    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPass()),
        );
      },
    );
    var googleSignInButton = FloatingActionButton(
      heroTag: 'google',
      child: Text('G',
          style: TextStyle(color: Colors.white, fontFamily: "Product Sans")),
      backgroundColor: Colors.redAccent,
      elevation: 0,
      onPressed: () async {
        final firebaseUser = await signInWithGoogle();
        if (firebaseUser != null) {
          final docs = await usersRef
              .where("userID", isEqualTo: firebaseUser.uid)
              .getDocuments();
          if (docs.documents.length == 0) {
            User().setDetails(
                firebaseUser.email,
                firebaseUser.displayName.split(" ")[0],
                firebaseUser.displayName.split(" ")[1],
                "9999999999",
                "1999-11-21",
                firebaseUser.uid);
            await addToUsers();
          } else {
            User().fromJson(docs.documents[0].data);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } else {
          Flushbar(
            duration: Duration(seconds: 3),
            title: "Error",
            message: "Feature coming soon",
          ).show(theContext);
        }
      },
    );
    var facebookSignInButton = FloatingActionButton(
        heroTag: 'facebook',
        child: Text('f',
            style: TextStyle(color: Colors.white, fontFamily: "Product Sans")),
        backgroundColor: Colors.blue,
        elevation: 0,
        onPressed: () async {
          final user = await signInWithFB();
          if (user != null) {
            final docs = await usersRef
                .where("userID", isEqualTo: user.uid)
                .getDocuments();
            if (docs.documents.length == 0) {
              User().setDetails(
                  user.email,
                  user.displayName.split(" ")[0],
                  user.displayName.split(" ")[1],
                  "9999999999",
                  "1999-11-21",
                  user.uid);
              await addToUsers();
            } else {
              User().fromJson(docs.documents[0].data);
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          } else {
            Flushbar(
              duration: Duration(seconds: 3),
              title: "Error",
              message: "Feature coming soon",
            ).show(theContext);
          }
        });

    return BlocListener(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (BuildContext context, AuthState state) {
        if (state is SignInError) {
          print('Login Failed');
          Flushbar(
            duration: Duration(seconds: 5),
            title: "Error Signing In",
            icon: Icon(
              Icons.error,
              color: Colors.blue,
            ),
            message: "Invalid Email or Password",
          )..show(theContext);
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (context, AuthState s) {
          print(s);
          if (s is Approved) {
            return Dashboard();
          } else {
            if (s is SignInError) {
              print('hello');
            }

            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Stack(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.white, Colors.blue],
                            begin: Alignment.topCenter,
                            stops: [0.0, 0.75, 1.0],
                            end: Alignment.bottomCenter)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SafeArea(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: size.width,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                      fontSize: 24,
                                      color: Colors.white),
                                )),
                              ),
                              Container(
                                width: size.width,
                                height: size.height*2.31/100,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.0))),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        style: new TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        controller: _email,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                          hintText: "Enter your Email",
                                          hintStyle: TextStyle(color: Colors.white54),
                                          alignLabelWithHint: true,
                                          enabledBorder: OutlineInputBorder(
                                              gapPadding: 0.0,
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                        ),
                                      )),
                                ),
                              ),
                              Container(
                                width: size.width,
                                height: size.height*2.31/100,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Password",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.0))),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        style: new TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        controller: _password,
                                        obscureText: true,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.white,
                                          ),
                                          hintText: "Enter your Password",
                                          hintStyle: TextStyle(color: Colors.white54),
                                          alignLabelWithHint: true,
                                          enabledBorder: OutlineInputBorder(
                                              gapPadding: 0.0,
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                        ),
                                      )),
                                ),
                              ),
                              Container(
                                width: size.width,
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Colors.indigo[600],
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Container(
                                width: size.width,
                                height: size.height*2.31/100,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool) {},
                                      checkColor: Colors.white,
                                      activeColor: Colors.white,
                                    ),
                                    Text(
                                      "Remember Me",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                child: Container(
                                    width: size.width * 0.8,
                                    height: 45,
                                    child: Center(
                                        child: BlocBuilder(
                                      bloc: BlocProvider.of<AuthBloc>(context),
                                      builder: (context, AuthState state) {
                                        if (state is Checking) {
                                          return (CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                          ));
                                        } else if (state is SignInError) {
                                          return (Text(
                                            "LOGIN",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: 1.1,
                                                color: Colors.blue),
                                          ));
                                        } else {
                                          return (Text(
                                            "LOGIN",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: 1.1,
                                                color: Colors.blue),
                                          ));
                                        }
                                      },
                                    ))),
                                color: Colors.white,
                                onPressed: () {
                                  final loginbloc =
                                      BlocProvider.of<AuthBloc>(context);
                                  loginbloc
                                      .add(LoginEvent(_email.text, _password.text));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0))),
                              ),
                              Container(
                                height: size.height*2.31/100,
                              ),
                              Text(
                                "OR",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                height: size.height*2.31/100,
                              ),
                              Text(
                                "Sign In With",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                height: size.height*2.31/100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FloatingActionButton(
                                    heroTag: "hero1",
                                    backgroundColor: Colors.white,
                                    elevation: 1.0,
                                    onPressed: () async {
                                      showProgressBar();
                                      try {
                                        final firebaseUser = await signInWithGoogle();
                                        if (firebaseUser != null) {
                                          final docs = await usersRef
                                              .where("userID",
                                                  isEqualTo: firebaseUser.uid)
                                              .getDocuments();
                                          if (docs.documents.length == 0) {
                                            User().setDetails(
                                                firebaseUser.email,
                                                firebaseUser.displayName
                                                    .split(" ")[0],
                                                firebaseUser.displayName
                                                    .split(" ")[1],
                                                "9999999999",
                                                "1999-11-21",
                                                firebaseUser.uid);
                                            await addToUsers();
                                          } else {
                                            Navigator.of(context).pop();
                                            User().fromJson(docs.documents[0].data);
                                          }
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Dashboard()),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          Flushbar(
                                            duration: Duration(seconds: 3),
                                            title: "Error",
                                            message: "Feature coming soon",
                                          ).show(theContext);
                                        }
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        Flushbar(
                                          duration: Duration(seconds: 3),
                                          title: "Error",
                                          message: "Error Signing in",
                                        ).show(theContext);
                                      }
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.google,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                  ),
                                  FloatingActionButton(
                                    heroTag: "hero2",
                                    backgroundColor: Colors.white,
                                    elevation: 1.0,
                                    onPressed: () async {
                                      showProgressBar();
                                      try {
                                        final user = await signInWithFB();
                                        if (user != null) {
                                          final docs = await usersRef
                                              .where("userID", isEqualTo: user.uid)
                                              .getDocuments();
                                          if (docs.documents.length == 0) {
                                            User().setDetails(
                                                user.email,
                                                user.displayName.split(" ")[0],
                                                user.displayName.split(" ")[1],
                                                "9999999999",
                                                "1999-11-21",
                                                user.uid);
                                            await addToUsers();
                                          } else {
                                            Navigator.of(context).pop();
                                            User().fromJson(docs.documents[0].data);
                                          }
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Dashboard()),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          Flushbar(
                                            duration: Duration(seconds: 3),
                                            title: "Error",
                                            message: "Feature coming soon",
                                          ).show(theContext);
                                        }
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.facebookF,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: size.height*2.31/100*2,
                              ),
                              RichText(
                                  maxLines: 1,
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 18),
                                      children: [
                                        TextSpan(
                                            text: "Don't have an account? ",
                                            style: TextStyle(color: Colors.white)),
                                        TextSpan(
                                            text: "Sign Up",
                                            style: TextStyle(color: Colors.indigo),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignUpProvider()));
                                              })
                                      ]))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void showProgressBar() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          //backgroundColor: Colors.deepOrange.withOpacity(10),
          title: Container(child: Center(child: CircularProgressIndicator())),
          content: Text(
            'Signing in Please Wait',
            textAlign: TextAlign.center,
          ),
        ),
      );
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.white, Colors.blue],
                    begin: Alignment.topCenter,
                    stops: [0.0, 0.75, 1.0],
                    end: Alignment.bottomCenter)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: size.width,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.1,
                            fontSize: 24,
                            color: Colors.white),
                      )),
                    ),
                    Container(
                      width: size.width,
                      height: size.height*2.31/100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              enabled: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: "Enter your Email",
                                hintStyle: TextStyle(color: Colors.white54),
                                alignLabelWithHint: true,
                                enabledBorder: OutlineInputBorder(
                                    gapPadding: 0.0,
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: size.height*2.31/100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Password",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              enabled: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                hintText: "Enter your Password",
                                hintStyle: TextStyle(color: Colors.white54),
                                alignLabelWithHint: true,
                                enabledBorder: OutlineInputBorder(
                                    gapPadding: 0.0,
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.indigo[600],
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Container(
                      width: size.width,
                      height: size.height*2.31/100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: false,
                            onChanged: (bool) {},
                            checkColor: Colors.white,
                            activeColor: Colors.white,
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Container(
                        width: size.width * 0.8,
                        height: 45,
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.1,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                      color: Colors.white,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    ),
                    Container(
                      height: size.height*2.31/100,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: size.height*2.31/100,
                    ),
                    Text(
                      "Sign In With",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: size.height*2.31/100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: "hero1",
                          backgroundColor: Colors.white,
                          elevation: 1.0,
                          onPressed: () {},
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                        ),
                        Container(
                          width: 60,
                        ),
                        FloatingActionButton(
                          heroTag: "hero2",
                          backgroundColor: Colors.white,
                          elevation: 1.0,
                          onPressed: () {},
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: size.height*2.31/100*2,
                    ),
                    FlatButton(
                      onPressed: () {
                        print("Hello");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpProvider()));
                      },
                      child: RichText(
                          maxLines: 1,
                          text: TextSpan(
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                              children: [
                                TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Colors.indigo),
                                )
                              ])),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
