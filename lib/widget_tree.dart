import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseManager().authStateChanges,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
