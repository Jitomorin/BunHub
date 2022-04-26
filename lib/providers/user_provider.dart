import 'package:flutter/foundation.dart';
import 'package:bunhub_app/models/user_model.dart';

import '../authentication/authentication_methods.dart';

class UserProv extends ChangeNotifier {
  UserModel? _user;
  final AuthenticationMeth _authMeth = AuthenticationMeth();

  Future<void> reloadUser() async {
    UserModel? user = await _authMeth.getUserDetails();
    _user = user;
    notifyListeners();
    //adding listener to _user variable
  }

  UserModel? get getUser => _user;
}
