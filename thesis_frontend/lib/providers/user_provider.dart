import 'package:flutter/material.dart';
import 'package:thesis_frontend/extensions/response_result_extension.dart';
import '../models/user_mdl.dart';
import '../services/auth_api_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? _relatedUser;

  UserModel? get user => _user;
  UserModel? get relatedUser => _relatedUser;

  bool get hasConnection => _relatedUser != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void setRelatedUser(UserModel relatedUser) {
    _relatedUser = relatedUser;
    notifyListeners();
  }

  void clear() {
    _user = null;
    _relatedUser = null;
    notifyListeners();
  }

  // Main function to call for latest user info
  Future<void> refreshUserInfo() async {
    final data =
        (await AuthService.getUserFullInfo())
            .successOrThrow<Map<String, dynamic>>();

    _user = UserModel.fromJson(data['user']);
    _relatedUser =
        data['relatedUser'] != null
            ? UserModel.fromJson(data['relatedUser'])
            : null;

    notifyListeners();
  }

  String get userAvatarAsset {
    if (_user == null) return 'assets/images/avatars/1.png';

    switch (_user!.role) {
      case 'child':
        return 'assets/images/avatars/1.png'; // boy bear
      case 'parent':
        return 'assets/images/avatars/3.png'; // papa bear
      default:
        return 'assets/images/avatars/1.png';
    }
  }

  String get relatedUserAvatarAsset {
    if (_relatedUser == null) return 'assets/images/avatars/1.png';

    switch (_relatedUser!.role) {
      case 'child':
        return 'assets/images/avatars/1.png';
      case 'parent':
        return 'assets/images/avatars/3.png';
      default:
        return 'assets/images/avatars/1.png';
    }
  }

  // Testing related functions below

  void setMockChildUser() {
    _user = UserModel(
      id: 1,
      username: "Bearl Benson",
      email: "a@mail.com",
      role: "child",
      relatedUserId: 2,
      expPoints: 0,
    );

    _relatedUser = UserModel(
      id: 2,
      username: "Mama Bear",
      email: "b@mail.com",
      role: "parent",
      relatedUserId: 1,
      expPoints: 0,
    );
  }

  void setMockParentUser() {
    _user = UserModel(
      id: 2,
      username: "Mama Bear",
      email: "b@mail.com",
      role: "parent",
      relatedUserId: 1,
      expPoints: 0,
    );

    _relatedUser = UserModel(
      id: 1,
      username: "Bearl Benson",
      email: "a@mail.com",
      role: "child",
      relatedUserId: 2,
      expPoints: 0,
    );
  }

  void setMockParentUserNoRelation() {
    _user = UserModel(
      id: 2,
      username: "Mama Bear",
      email: "b@mail.com",
      role: "parent",
      relatedUserId: null,
      expPoints: 0,
    );
    _relatedUser = null;
  }
}
