// import 'package:flutter/foundation.dart';
// import 'package:sm/Models/user.dart';
// import 'package:sm/Resources/auth_methods.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethod _authMethod = AuthMethod();

//   User get getUser => _user!;

//   Future<void> FetchUser() async {
//     User user = await _authMethod.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:sm/Models/user.dart';
import 'package:sm/Resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final AuthMethod _authMethod = AuthMethod();

  User get getUser => _user!;
  bool get isLoading => _isLoading;

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      User user = await _authMethod.getUserDetails();
      _user = user;
    } catch (e) {
      print("Error fetching user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
