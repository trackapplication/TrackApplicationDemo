import 'dart:convert';
import 'package:trackapp/models/apiModel/base_repo.dart';
import 'package:http/http.dart' as http;
import 'package:trackapp/models/apiModel/api_config.dart';

Future<int> addDevice(String deviceId, String deviceName) async {
  final response = await http.post(Uri.encodeFull(ApiConfig.devices),
      headers: await ApiConfig.getHeader(),
      body: {'deviceId': deviceId, 'name': deviceName});

//  print(response.reasonPhrase);
//  print(response.body);
//  print(response.statusCode);

  //added this code so that we could perform hardcoded login in staging server
  if (response.statusCode == 201 ) {
    print(response.statusCode);
    return 1;
  }
  else if (response.statusCode == 200){
    print(response.statusCode);
    return 2;
  }
  else{
    return 3;
    //throw throw getErrorBasedOnResponse(response);
  }
}
