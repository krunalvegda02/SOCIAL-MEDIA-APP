import 'package:flutter/material.dart';
import 'package:sm/Models/user.dart';
import 'package:sm/Resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authMethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    //NOTIFY LISTENER NOTIFY ALL THE LESTENERS TO THEIR PROVIDER THAT THE
    //DATA OF OUR GLOBAL VARIABLE USER HAS CHANGED AND YOU NEED TO UPDATE YOUR VALUE
    notifyListeners();
  }
}
