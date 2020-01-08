import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:flushbar/flushbar.dart';

final firestore = Firestore.instance;
final usersRef = firestore.collection('users');

class EditDevice extends StatefulWidget {
  String deviceID;
  Map selectedDevice;
  EditDevice(this.deviceID);
  @override
  _EditDeviceState createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  TextEditingController deviceIDCtrl = TextEditingController();
  TextEditingController deviceNameCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  List<String> genders = ["Select Gender", "Male", "Female", "Others"];
  String selectedGender = "Male";

  String dob = "1999-12-21";
  DateTime selectedDate = DateTime.now();
  final format = DateFormat("yyyy-MM-dd");
  bool visited=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance
              .collection("users")
              .document(User().uid)
              .collection("devices")
              .document(widget.deviceID)
              .get(),
          builder: (context, snapshot) {
            
            if (snapshot.hasData) {
              if(!visited){
              widget.selectedDevice=snapshot.data.data;
              
              deviceIDCtrl.text = widget.selectedDevice["DeviceId"].toString();
              deviceNameCtrl.text = widget.selectedDevice["Name"].toString();
              dobCtrl.text = widget.selectedDevice["DOB"].toString();
              genderCtrl.text = widget.selectedDevice["Gender"].toString();
              selectedGender = genderCtrl.text;
              dob = dobCtrl.text;

              selectedDate = DateTime.parse(dobCtrl.text);
              visited=true;
              }
              return Padding(
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
                                "Edit Device",
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
                              enabled: false,
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
                              //enabled: false,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    top: 8.0,
                                                    left: 8.0,
                                                    right: 8.0),
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
                                hintText: dob,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        onPressed: () async {
                          if (selectedGender == null) {
                            return;
                          }

                          usersRef
                              .document(User().uid)
                              .collection('devices')
                              .document(deviceIDCtrl.text)
                              .updateData({
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    title: Text("Success"),
                                    //responseCode==1 ? Text("addddded"): responseCode==2 ? Text("sameee haiii"):Text("bad request"),
                                    content:
                                        Text("Device added successfully."));
                              });
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            child: Center(
                                child: Text(
                              "Save Changes",
                              style: TextStyle(fontSize: 18),
                            ))),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
