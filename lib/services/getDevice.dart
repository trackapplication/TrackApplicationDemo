import 'dart:convert';
import 'package:trackapp/models/apiModel/base_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trackapp/models/apiModel/api_config.dart';
import 'package:trackapp/models/deviceModel.dart';
//import 'package:trackapp/models/index.dart';

Future<Device> fetchDevice() async {
  //print('yolaaa');
  print(ApiConfig.devices);
  final response = await http.get(Uri.encodeFull(ApiConfig.devices),
      headers: await ApiConfig.getHeader());

  if (response.statusCode == 200 || response.statusCode == 201) {
    //print('response of add device data ==>  ${response.body.length}');
    Map responseData = jsonDecode(response.body);
    // print(response.body);
    // print(responseData.length);
    //print(GetDevices.fromJson(json.decode(response.body)));
    //print("hiiiiii" + responseData.to);
    //getErrorBasedOnStatusCode(response.statusCode, responseData['message']);
  }

  return Device.fromJson(json.decode(response.body));
}

Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

String deviceToJson(Device data) => json.encode(data.toJson());
