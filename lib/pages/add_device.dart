import 'package:flutter/material.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/services/addDevice.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = Firestore.instance;
final usersRef = firestore.collection('users');

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  TextEditingController deviceIDCtrl = TextEditingController();
  TextEditingController deviceNameCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  List<String> genders = ["Male", "Female", "Others"];
  String selectedGender;

  String dob = "1999-12-21";
  DateTime selectedDate = DateTime.now();
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    selectedGender = genders[0];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  controller: deviceIDCtrl,
                  maxLengthEnforced: true,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.devices_other,
                      ), // icon is 48px widget.
                    ), // icon is 48px widget.
                    hintText: 'Device ID',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  controller: deviceNameCtrl,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.device_unknown,
                      ), // icon is 48px widget.
                    ), // icon is 48px widget.
                    hintText: 'Device Name',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      //padding: EdgeInsets.all(9),
                      //height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Gender",
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              child: DropdownButton(
                                isExpanded: true,
                                // icon: Icon(Icons.person_outline),
                                items: genders.map((gender) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        gender,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    value: gender,
                                  );
                                }).toList(),
                                value: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                                hint: Text("Gender"),
                              ),
                            ),
                          ),
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimeField(
                  format: format,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.calendar_today,
                      ), // icon is 48px widget.
                    ), // icon is 48px widget.
                    hintText: 'Date Of Birth',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                onPressed: () async {
                  int responseCode =
                      await addDevice(deviceIDCtrl.text, deviceNameCtrl.text);
                  print(responseCode);

                  if (responseCode == 1) {
                    usersRef
                        .document(User().uid)
                        .collection('devices')
                        .document(deviceIDCtrl.text)
                        .setData({
                      'DOB': dob,
                      'DeviceId': deviceIDCtrl.text,
                      'Gender': selectedGender,
                      'Name': deviceNameCtrl.text
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"))
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              title: Text("Success"),
                              //responseCode==1 ? Text("addddded"): responseCode==2 ? Text("sameee haiii"):Text("bad request"),
                              content: Text("Device added successfully."));
                        });
                  } else if (responseCode == 2) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"))
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              title: Text("Error"),
                              //responseCode==1 ? Text("addddded"): responseCode==2 ? Text("sameee haiii"):Text("bad request"),
                              content:
                                  Text("The device has already been added."));
                        });
                  } else if (responseCode == 3) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"))
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              title: Text("Error"),
                              //responseCode==1 ? Text("addddded"): responseCode==2 ? Text("sameee haiii"):Text("bad request"),
                              content: Text(
                                  "The device ID you entered is incorrent, please check."));
                        });
                  }
                },
                color: Colors.green,
                textColor: Colors.white,
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
