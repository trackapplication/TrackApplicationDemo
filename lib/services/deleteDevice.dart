import 'dart:convert';
import 'package:trackapp/models/apiModel/base_repo.dart';
import 'package:http/http.dart' as http;
import 'package:trackapp/models/apiModel/api_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackapp/models/userModel.dart';

final firestore = Firestore.instance;

Future<void> deleteDevice(String deviceId) async {
  String deleteDev = ApiConfig.deviceLogByDeviceId + "/" + deviceId;
  print(deleteDev);
  final response = await http.delete(
    Uri.encodeFull(deleteDev),
    headers: await ApiConfig.getHeader(),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    firestore
        .collection('users')
        .document(User().uid.toString())
        .collection('devices')
        .document(deviceId)
        .delete();
    print("yaay");
  }
  print(response.body.toString());
}
