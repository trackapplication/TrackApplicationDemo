import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackapp/blocs/authBloc/auth_state.dart';
import 'package:trackapp/blocs/authBloc/bloc.dart';

import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/dashboard.dart';
import 'package:trackapp/pages/login_page.dart';
import 'package:trackapp/services/emailSignUp.dart';
import 'package:trackapp/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

final firestore = Firestore.instance;
final usersRef = firestore.collection('users');

class SignUpProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => AuthBloc(),
      child: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _passwordConfirmation =
      new TextEditingController();
  String dob = "";
  bool check = true;
  bool _autoValidate = false;
  DateTime selectedDate = DateTime.now();
  final format = DateFormat("yyyy-MM-dd");

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext theContext) {
    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
          ), // icon is 48px widget.
        ), // icon is 48px widget.

        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final lastName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
          ), // icon is 48px widget.
        ), // icon is 48px widget.

        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final phoneNumber = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.phone,
      controller: _phone,
      validator: validateMobile,
      maxLengthEnforced: true,
      maxLength: 10,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.phone,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: check,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
          ), // icon is 48px widget.
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          color: check ? Colors.grey : Colors.blue,
          onPressed: () {
            setState(() {
              check = !check;
            });
          },
        ),
        // icon is 48px widget.
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final passwordConfirmation = TextFormField(
      autofocus: false,
      obscureText: check,
      controller: _passwordConfirmation,
      validator: validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
          ), // icon is 48px widget.
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          color: check ? Colors.grey : Colors.blue,
          onPressed: () {
            setState(() {
              check = !check;
            });
          },
        ),
        // icon is 48px widget.
        hintText: 'Confirm Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        'Have an Account? Sign In.',
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
            context, MaterialPageRoute(builder: (context) => LoginProvider()));
      },
    );

    return BlocListener(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (BuildContext context, AuthState state) {
        if (state is SignUpComplete) {
          print('SignUp Successful');
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (context, AuthState s) {
          if (s is SignUpComplete) {
            return Dashboard();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 48.0),
                          Row(
                            children: <Widget>[
                              Expanded(flex: 1, child: firstName),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(flex: 1, child: lastName)
                            ],
                          ),
                          SizedBox(height: 24.0),
                          phoneNumber,
                          SizedBox(height: 24.0),
                          DateTimeField(
                            format: format,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.calendar_today,
                                ), // icon is 48px widget.
                              ), // icon is 48px widget.
                              hintText: 'Date Of Birth',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onShowPicker: (context, currentValue) async {
                              final DateTime dateTime = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));

                              dob = dateTime.toString().split(" ")[0];

                              return dateTime;
                            },
                          ),
                          SizedBox(height: 24.0),
                          email,
                          SizedBox(height: 24.0),
                          password,
                          SizedBox(height: 24.0),
                          passwordConfirmation,
                          SizedBox(height: 12.0),
                          BlocBuilder(
                            bloc: BlocProvider.of<AuthBloc>(context),
                            builder: (context, AuthState state) {
                              print("State is : " + state.toString());

                              if (state is SignUpError) {
                                Flushbar(
                                  duration: Duration(seconds: 5),
                                  title: "Error Signing you Up",
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.blue,
                                  ),
                                  message:
                                      "Please try again or Check your internet connection",
                                )..show(theContext);
                                return Container();
                              } else if (state is SignUpComplete) {
                                return Dashboard();
                              } else {
                                if (state is InitialAuthState) {
                                  if (_email.text.isEmpty ||
                                      _firstName.text.isEmpty ||
                                      _lastName.text.isEmpty ||
                                      dob.isEmpty ||
                                      _password.text.isEmpty ||
                                      _passwordConfirmation.text.isEmpty ||
                                      _phone.text.isEmpty) {
                                    return signUpButton(
                                        state, theContext, false);
                                  } else {
                                    return signUpButton(
                                        state, theContext, true);
                                  }
                                } else {
                                  return signUpButton(state, theContext, true);
                                }
                              }
                            },
                          ),
                          signInLabel
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Enter a valid mobile number';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value != _password.text) {
      return 'Enter same password in both the fields';
    }
    else
      return null;
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
              'Signing you up',
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  Widget signUpButton(
      AuthState state, BuildContext theContext, bool isEnabled) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: isEnabled
          ? () {
              if (_formKey.currentState.validate() &&
                  _password.text == _passwordConfirmation.text) {
                final signupbloc = BlocProvider.of<AuthBloc>(context);
                signupbloc.add(SignUpEvent(
                  _email.text,
                  _password.text,
                  _firstName.text,
                  _lastName.text,
                  dob,
                  _phone.text,
                ));
              } else {
                Flushbar(
                  duration: Duration(seconds: 5),
                  title: "Error",
                  icon: Icon(
                    Icons.error,
                    color: Colors.blue,
                  ),
                  message: "Error Signing you Up",
                )..show(theContext);
              }
            }
          : null,
      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
      color: Colors.green.shade800,
      child: (state is Checking)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Text('SIGN UP',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Product Sans")),
    );
  }
}
