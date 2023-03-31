import 'package:flutter/material.dart';
import 'package:my_app/controller/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/model/user_provider.dart';
import 'package:my_app/widget_tree.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // PermissionHandler().start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const WidgetTree() 
      )
    );
  }
}

