import 'package:flutter/material.dart';

import '../model/login/login_response.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  // Getter
  User? get user => _user;

  // Check Login
  bool get isLoggedIn => _user != null;

  // Set User

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Update User is Pending
  void updateUser({
    String? name,
    String? email,
    String? mobile,
  }) {
    if (_user == null) return;

    _user = User(
      id: _user!.id,
      name: name ?? _user!.name,
      email: email ?? _user!.email,
      mobile: mobile ?? _user!.mobile,
    );

    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
