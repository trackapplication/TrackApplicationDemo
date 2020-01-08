import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trackapp/main.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/add_device.dart';
import 'package:trackapp/pages/edit_device_page.dart';
import 'package:trackapp/services/getDevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:trackapp/services/deleteDevice.dart';

FirebaseUser presentUser;
final usersRef = Firestore.instance.collection('users').document();

class DevicesPage extends StatefulWidget {
  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool delete = false;

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
      appBar: AppBar(
        leading: Icon(Icons.menu),
      ),
      body: Container(
        child: StreamBuilder<Device>(
          stream: fetchDevice().asStream(),
          builder: (BuildContext context, snapshot) {
            List<Item> list = List();
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.items.length == 0) {
              return Center(
                child: Text("No Devices Yet "),
              );
            } else {
              list.addAll(snapshot.data.items);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list.map((item) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Radio(
                              groupValue: radioDeviceSelector,
                              value: item.deviceId.toString(),
                              onChanged: (val) {
                                setState(() {
                                  radioDeviceSelector = val;
                                });
                              },
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text(item.deviceId.toString()),
                                  IconButton(

                                    onPressed: () {
                                      print(item.toJson());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDevice(item.deviceId)));
                                    },
                                    color: Colors.green,
                                    icon: Icon(Icons.edit),
                                  )
                                ],
                              ),
                            ),
                            trailing:                               IconButton(
                              onPressed: () async {
                                await deleteDevice(
                                    item.deviceId.toString());
                                setState(() {
                                  delete = true;
                                });
                              },
                              color: Colors.red,
                              icon: Icon(Icons.delete),
                            )
                            ,
                          ),
                        ],
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
