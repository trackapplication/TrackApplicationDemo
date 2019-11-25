import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String pass;

  LoginEvent(this.email, this.pass);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String pass;
  final String firstname;
  final String lastname;
  final String dob;
  final String phone;

  SignUpEvent(
    this.email,
    this.pass,
    this.firstname,
    this.lastname,
    this.dob,
    this.phone,
  );
}

class DetailsCheckEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String dob;
  final String phone;
  final String passwordConfirm;

  DetailsCheckEvent({
    this.email,
    this.password,
    this.passwordConfirm,
    this.firstname,
    this.lastname,
    this.dob,
    this.phone,
  });
}
