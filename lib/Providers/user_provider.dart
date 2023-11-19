import 'package:exampal/Firebase/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:exampal/Models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}