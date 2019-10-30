import 'package:flutter/material.dart';
import 'package:trackapp/models/userModel.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(User().firstName),
              Text(User().lastName),
              Text(User().email),
              Text(User().phone),
              Text(User().dob)
            ],
          ),
        ));
  }
}
