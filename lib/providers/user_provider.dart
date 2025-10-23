import 'package:flutter/material.dart';
import 'package:quick_slice/models/app_user.dart';

class UserProvider extends ChangeNotifier {
  AppUser _user = AppUser(
    id: '',
    name: '',
    phone: '',
    email: '',
    role: '',
    token: '',
    password: '',
  );

  AppUser get user => _user;

  void setUser(String user) {
    _user = AppUser.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(AppUser user) {
    _user = user;
    notifyListeners();
  }
}
