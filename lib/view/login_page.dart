import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/controller/globale.dart';
import 'package:my_app/model/utilisateur.dart';
import 'package:my_app/view/dash_board.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //variable
  List<bool> selection = [true, false];
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLogin = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      Utilisateur userConnected =
          await FirebaseManager().connect(email.text, password.text);
      if (!mounted) return;
      setState(() {
        myUser = userConnected;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DashBoard();
      }));
    } on FirebaseAuthException catch (e) {
      popError(errorMessage: e.message);
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      Utilisateur userConnected =
          await FirebaseManager().inscription(email.text, password.text);

      if (!mounted) return;
      setState(() {
        myUser = userConnected;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DashBoard();
      }));
    } on FirebaseAuthException catch (e) {
      popError(errorMessage: e.message);
    }
  }

  Widget _entryField(
      TextEditingController controller, String hintText, Icon icon,
      {bool textObscured = false}) {
    return TextField(
      controller: controller,
      obscureText: textObscured,
      decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLogin ? "Connexion" : "Inscription"));
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? "S'inscrire ?" : "Se connecter ?"),
    );
  }

  //méhode interne
  popError({String? errorMessage}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            return CupertinoAlertDialog(
              title: const Text("Erreur"),
              content: Column(children: [
                Lottie.asset("assets/error.json"),
                Text(errorMessage ?? 'Une erreur est survenue'),
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("Erreur"),
              content: Column(children: [
                Lottie.asset("assets/error.json"),
                Text(errorMessage ?? 'Une erreur est survenue'),
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: bodyPage(),
    ));
  }

  Widget bodyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
                //color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: AssetImage("assets/messenger.png"),
                    fit: BoxFit.contain)),
          ),
          const SizedBox(height: 10),

          //toogleButton

          ToggleButtons(
              onPressed: (value) {
                if (isLogin) {
                  setState(() {
                    isLogin = false;
                  });
                } else {
                  setState(() {
                    isLogin = true;
                  });
                }
              },
              isSelected: [isLogin, !isLogin],
              children: const [Text("Connexion"), Text("Inscription")]),

          const SizedBox(height: 10),

          //adresse mail
          _entryField(
              email, "Entrer votre adresse mail", const Icon(Icons.email)),
          const SizedBox(height: 10),
          //password
          _entryField(
              password, 'Entrer votre mot de passe', const Icon(Icons.lock),
              textObscured: true),
          const SizedBox(height: 10),
          //boutton
          _submitButton(),
        ],
      ),
    );
  }
}
