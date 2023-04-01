import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/model/utilisateur.dart';

class UserProvider with ChangeNotifier {
  Utilisateur _myUser = Utilisateur.empty();

  Utilisateur get myUser => _myUser;

  void updateMyUser(User? user) async {
    if (user != null) {
      _myUser = await FirebaseManager().getUser(user.uid);
    }
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    updateMyUser(firebaseUser);
  }
}
