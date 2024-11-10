import 'package:flutter/foundation.dart';
import 'package:gamefan_app/entities/user.dart'; // Import your User class

class UserModel extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void login(User user) {
    _currentUser = user;
    notifyListeners(); // Notify listeners to update UI
  }
  void updateUser(User user) {
    _currentUser = user;
    notifyListeners(); // Notify listeners to update the UI
  }
  void logout() {
    _currentUser = null;
    notifyListeners(); // Notify listeners to update UI
  }
}
