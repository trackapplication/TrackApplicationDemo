import 'dart:convert';

import 'package:http/src/response.dart';
import 'package:trackapp/models/apiModel/data_exception.dart';

DataException getErrorBasedOnStatusCode(int statusCode, String message) {
  // If that response was not OK, throw an error.
  if (statusCode == 500 || statusCode == 404) {
    return new DataException(
        "Unable to login. Internal Server error. Kindly report to system admin.",
        statusCode);
  } else if (statusCode == 503) {
    return new DataException(
        "Unable to login. Server is down for maintainence. Kindly try after some time.",
        statusCode);
  } else if (message.contains("SocketException")) {
    return new DataException(
        "Unable to authenticate user [StatusCode:$statusCode, Error:$message]",
        statusCode);
  }

  return new DataException(
      "Unable to authenticate user [StatusCode:$statusCode, Error:$message]",
      statusCode);
}

DataException getErrorBasedOnResponse(Response response) {
  Map responseData = json.decode(response.body);
  int statusCode = response.statusCode;

  // If that response was not OK, throw an error.
  if (statusCode == 500) {
    return new DataException("Internal Server error.", statusCode);
  } else if (statusCode == 404) {
    return new DataException(responseData['message'], statusCode);
  }
  return new DataException("Internal Server error.", statusCode);
}
