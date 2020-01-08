import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trackapp/blocs/mapPageBloc/containerBloc.dart';
import 'package:trackapp/pages/devices_page.dart';
import 'package:trackapp/pages/history_page.dart';
import 'package:trackapp/pages/locate_page.dart';
import 'package:trackapp/pages/safezone_page.dart';
import 'package:trackapp/pages/attendance_page.dart';
import 'package:trackapp/models/userModel.dart';

import 'attendance_page.dart';

Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      DevicesPage(),
      LocatePage(),
      SafeZonePage(),
      HistoryPage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        FirebaseAuth.instance.signOut();
        GoogleSignIn().signOut();
        FacebookLogin().logOut();
        return true;
      },
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName:
                      new Text(User().firstName + " " + User().lastName),
                  accountEmail: new Text(User().email),
                  currentAccountPicture: CircleAvatar(),
                ),
                ListTile(
                    title: Text("Attendance"),
                    leading: Icon(Icons.stars),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendancePage()));
                    })
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (i) {
              setState(() {
                _index = i;
              });
              print(_index);
            },
            backgroundColor: Colors.green,
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(color: Colors.white),
            selectedLabelStyle: TextStyle(color: Colors.white),
            showSelectedLabels: true,
            currentIndex: _index,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.devices), title: Text("Devices")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on), title: Text("Location")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.security), title: Text("Safety Zone")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), title: Text("History")),
            ],
          ),
          body: pages[_index]),
    );
  }
}
