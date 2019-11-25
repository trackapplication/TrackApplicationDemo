import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:trackapp/models/userModel.dart';
import 'package:trackapp/pages/signup_page.dart';
import 'package:trackapp/services/emailSignUp.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginEvent) {
      yield Checking();
      try {
        await signInWithEmailAndPassword(event.email, event.pass);
        var user = await FirebaseAuth.instance.currentUser();
        var docs = await usersRef.document(user.uid).get();
        User().fromJson(docs.data);
        yield Approved();
      } catch (e) {
        print("qwerty");
        yield SignInError();
      }
    }
    if (event is SignUpEvent) {
      yield Checking();
      try {
        await signUpWithEmailAndPassword(event.email, event.pass)
            .then((user) async {
          User().setDetails(
            event.email,
            event.firstname,
            event.lastname,
            event.phone,
            event.dob,
            user.uid,
          );
          await addToUsers();
        });

        yield SignUpComplete();
      } on PlatformException {
        yield SignUpError();
      } catch (e) {
        yield SignUpError();
        print(e.toString());
      }
    }
    if (event is DetailsCheckEvent) {
      if (event.dob.isEmpty ||
          event.firstname.isEmpty ||
          event.lastname.isEmpty ||
          event.phone.isEmpty ||
          event.email.isEmpty ||
          event.password.isEmpty ||
          event.passwordConfirm.isEmpty) {
        yield FieldsAreEmpty();
      } else {
        yield FieldsAreNotEmpty();
      }
    }
  }
}
