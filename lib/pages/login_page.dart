import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
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
    size = MediaQuery.of(context).size;

    final email = TextField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        hintText: 'Email',
        contentPadding: EdgeInsets.all(18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextField(
      controller: _password,
      autofocus: false,
      obscureText: check,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          color: check ? Colors.grey : Colors.blue,
          onPressed: () => setState(() => check = !check),
        ),
        contentPadding: EdgeInsets.all(18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

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
        } catch (e) {
          //Navigator.of(context).pop();
          // Flushbar(
          //   duration: Duration(seconds: 5),
          //   title: "Error Signing In",
          //   icon: Icon(
          //     Icons.error,
          //     color: Colors.blue,
          //   ),
          //   message: "Invalid Email or Password",
          // )..show(context);
        }
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
    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(
            color: Colors.green.shade800, decoration: TextDecoration.underline),
      ),
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpProvider()));
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
              backgroundColor: Colors.white,
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    SizedBox(height: 48.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: email,
                    ),
                    password,
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () {
                              final loginbloc =
                                  BlocProvider.of<AuthBloc>(context);
                              loginbloc
                                  .add(LoginEvent(_email.text, _password.text));
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 15),
                            color: Colors.green.shade800,
                            child: BlocBuilder(
                              bloc: BlocProvider.of<AuthBloc>(context),
                              builder: (context, AuthState state) {
                                if (state is Checking) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                } else if (state is SignInError) {
                                  return Text('Log In',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "Product Sans"));
                                } else {
                                  return Text('Log In',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "Product Sans"));
                                }
                              },
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: forgotLabel,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "-\tor\t-",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: signUpLabel,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        googleSignInButton,
                        facebookSignInButton
                      ],
                    )
                  ],
                ),
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
