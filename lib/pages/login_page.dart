import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:trackapp/models/emailSignUp.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/dashboard.dart';
import 'package:trackapp/pages/signup_page.dart';
import 'package:trackapp/utils/validator.dart';

Size size = Size(0, 0);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  bool check = true;

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            setState(() {
              check = !check;
            });
          },
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
          final docs = await usersRef.document(user.uid).get();
          User().fromJson(docs.data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } catch (e) {
          Navigator.of(context).pop();
          Flushbar(
            duration: Duration(seconds: 5),
            title: "Error Signing In",
            icon: Icon(
              Icons.error,
              color: Colors.blue,
            ),
            message: "Invalid Email or Password",
          )..show(context);
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
      onPressed: () {},
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
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
    );
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
                loginButton,
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
                      color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: signUpLabel,
            ),
          ],
        ),
      ),
    );
  }

  void showProgressBar() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //backgroundColor: Colors.deepOrange.withOpacity(10),
            title: Container(
              child: Center(
                child: CircularProgressIndicator(
                    //backgroundColor: Colors.white,
                    ),
              ),
            ),
            content: Text(
              'Signing in Please Wait',
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
