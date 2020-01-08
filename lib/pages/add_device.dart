import 'package:flutter/material.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/services/addDevice.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';

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
  List<String> genders = ["Select Gender", "Male", "Female", "Others"];
  String selectedGender;

  String dob = "1999-12-21";
  DateTime selectedDate = DateTime.now();
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Add Device",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      controller: deviceIDCtrl,
                      decoration: InputDecoration(
                        labelText: "Device ID",
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
                          // icon is 48px widget.

                          labelText: "Device Name"),
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
                              Container(
                                height: 60,
                                child: DropdownButton(
                                  isExpanded: true,
                                  // icon: Icon(Icons.person_outline),
                                  items: genders.map((gender) {
                                    return DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8.0, right: 8.0),
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
                            ],
                          ))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                        // icon is 48px widget.
                        hintText: 'Date Of Birth',
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                onPressed: () async {
                  if (selectedGender == null) {
                    selectedGender = "Select Gender";
                  }
                  print(dob);
                  print(selectedGender);

                  /*if (selectedGender == null) {
                    return;
                  }*/
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
                    Navigator.of(context).pop();
                  } else if (responseCode == 3) {
                    Flushbar(
                      duration: Duration(seconds: 3),
                      title: "Error",
                      message: "Invalid Device ID",
                    ).show(context);
                  } else {
                    Flushbar(
                      duration: Duration(seconds: 3),
                      title: "Error",
                      message: "Device ID has already been added",
                    ).show(context);
                  }
                },
                color: Colors.green,
                textColor: Colors.white,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    child: Center(
                        child: Text(
                      "Submit Details",
                      style: TextStyle(fontSize: 18),
                    ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
