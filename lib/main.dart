import 'package:flutter/material.dart';
//import 'package:trackapp/pages(new)/login_page.dart';
import 'package:trackapp/pages/dashboard.dart';
import 'package:trackapp/pages/login_page.dart';
import 'package:trackapp/pages/printdeets.dart';

String radioDeviceSelector = '';
void main() => runApp(
      MaterialApp(
        title: 'demo',
        home: LoginProvider(),
//        home: printdeets(),
      ),
    );
