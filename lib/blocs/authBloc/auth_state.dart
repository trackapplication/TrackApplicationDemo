import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class Checking extends AuthState {}

class Approved extends AuthState {}

class SignInError extends AuthState {}

class SignUpComplete extends AuthState {}

class FieldsAreEmpty extends AuthState {}

class FieldsAreNotEmpty extends AuthState {}

class SignUpError extends AuthState {}
