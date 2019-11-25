import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/pages/signup_page.dart';
import 'package:trackapp/services/getDevice.dart';

class User {
  User._internal();

  static final User _singleton = User._internal();

  factory User() => _singleton;

  String firstName;
  String lastName;
  String email;
  String phone;
  String dob;
  String uid;
  Device listOfDevices;
  // TODO: Auto-serialize this
  toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "phone": this.phone,
      "dob": this.dob,
      "email": this.email,
      "userID": this.uid,
    };
  }

  // TODO: Auto-deserialize this
  fromJson(Map<String, dynamic> json) {
    this.email = json["email"];
    this.firstName = json["firstName"];
    this.lastName = json["lastName"];
    this.dob = json["dob"];
    this.phone = json["phone"];
    this.uid = json["userID"];
  }

  setDetails(
    String email,
    String firstName,
    String lastName,
    String phone,
    String dob,
    String uid,
  ) {
    this.email = email;
    this.phone = phone;
    this.dob = dob;
    this.firstName = firstName;
    this.lastName = lastName;
    this.uid = uid;
  }
}

Future addToUsers() async {
  await usersRef.document(User().uid).setData(User().toJson());
}
