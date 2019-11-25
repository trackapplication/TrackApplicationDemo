import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/add_device.dart';
import 'package:trackapp/services/getDevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

FirebaseUser presentUser;
final usersRef = Firestore.instance.collection('users').document();

class DevicesPage extends StatefulWidget {
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDevice()));
        },
        icon: Icon(Icons.add),
        label: Text("Add a Device"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("users")
              .document(User().uid)
              .collection("devices")
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text("No Devices Yet "),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(35.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data.documents.map((item) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.data["Name"].toString()),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
