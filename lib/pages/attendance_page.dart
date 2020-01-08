import 'package:flutter/material.dart';
import 'package:trackapp/models/userModel.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final longController = TextEditingController();
  final latController = TextEditingController();
  List<String> longitude = [];
  List<String> latitude = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return new Container(
                    child: new Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: new Container(
                            height: 150,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: longController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Enter Longitude',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: latController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Enter Latitude',
                                      ),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(5.0),
                                    ),
                                    color: Colors.blue,
                                    onPressed: () {
                                      setState(() {
                                        longitude.add(longController.text);
                                        latitude.add(latController.text);
                                        //longitude = longController.text;
                                        //latitude = latController.text;
                                      });
                                      //print("hee"+longitude+latitude);
                                    },
                                    child: Text(
                                      "Enter",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ))));
              });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: longitude.length == 0 && latitude.length == 0
              ? ListTile()
              : ListView.builder(
              itemCount: longitude.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: Text(User().firstName+" "+User().lastName),
                  subtitle: Text(longitude[index] + " : " + latitude[index]),
                );
              })),
    );
  }
}
