import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/userModel.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  AuthMethods authMethods = AuthMethods();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await authMethods.getCurrentUser();
    _user = user;
    notifyListeners();
  }
}
