import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String email;
  String pass;
  LoginEvent(this.email, this.pass);
}

class SignUpEvent extends AuthEvent {
  String email;
  String pass;
  String firstname;
  String lastname;
  String dob;
  String phone;

  SignUpEvent(this.email, this.pass, this.firstname, this.lastname, this.dob,
      this.phone);
}

class DetailsCheckEvent extends AuthEvent {
  String email;
  String password;
  String firstname;
  String lastname;
  String dob;
  String phone;
  String passwordConfirm;
  DetailsCheckEvent(
      {this.email,
      this.password,
      this.passwordConfirm,
      this.firstname,
      this.lastname,
      this.dob,
      this.phone});
}
