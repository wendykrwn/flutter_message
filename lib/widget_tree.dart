import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/model/user_provider.dart';
import 'package:my_app/view/dash_board.dart';
import 'package:my_app/view/login_page.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    userProvider.getCurrentUser();
    return StreamBuilder(
      stream: FirebaseManager().authStateChanges,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return const DashBoard();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
