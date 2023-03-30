import 'package:flutter/material.dart';
import 'package:my_app/controller/permission_handler.dart';
import 'package:my_app/view/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(const MyApp());
  PermissionHandler().start();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginPage());
  }
}
