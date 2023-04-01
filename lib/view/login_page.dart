import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/model/user_provider.dart';
import 'package:my_app/view/dash_board.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

  Future<void> signInWithEmailAndPassword(UserProvider userProvider) async {
    try {
      await FirebaseManager().connect(email.text, password.text);

      await userProvider.getCurrentUser();
      
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DashBoard();
      }));
    } on FirebaseAuthException catch (e) {
      popError(errorMessage: e.message);
    } catch (e) {
      popError(
          errorMessage: 'Une erreur s\'est produite lors de l\'inscription.');
    }
  }

  Future<void> createUserWithEmailAndPassword(UserProvider userProvider) async {
    try {
      await FirebaseManager().inscription(email.text, password.text);
      await userProvider.getCurrentUser();
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DashBoard();
      }));
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'invalid-email':
          errorMessage =
              "Votre adresse email n'est pas reconnue dans notre système interstellaire, veuillez réessayer avec une adresse valide.";
          break;
        case 'email-already-in-use':
          errorMessage =
              "Cette adresse email est déjà occupée par une autre entité interstellaire.";
          break;
        case 'weak-password':
          errorMessage =
              'Désolé, votre mot de passe est trop faible pour affronter les attaques des extraterrestres, il faut au moins 6 caractères pour le renforcer.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'L\'inscription par e-mail et mot de passe n\'est pas autorisée pour le moment.';
          break;
        default:
          errorMessage =
              "Oups, quelque chose s'est mal passé lors de votre inscription : c'est l'inconvénient d'explorer de nouveaux horizons";
      }
      popError(errorMessage: errorMessage);
    } catch (e) {
      popError(
          errorMessage:
              "Oups, quelque chose s'est mal passé lors de votre inscription : c'est l'inconvénient d'explorer de nouveaux horizons");
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  Widget _submitButton(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // UserProvider userProvider =
    //     Provider.of<UserProvider>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        if (isLogin) {
          await signInWithEmailAndPassword(userProvider);
        } else {
          await createUserWithEmailAndPassword(userProvider);
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, //couleur du texte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), //bordure arrondie
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        minimumSize: const Size(double.infinity,
            50), // utilisation de minimumSize pour définir la largeur minimale et la hauteur du bouton
      ),
      child: Text(
        isLogin ? "SE CONNECTER" : "S'INSCRIRE",
        style: const TextStyle(fontSize: 18),
      ),
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
              title: const Text("Erreur de connexion intergalactique"),
              content: Column(children: [
                const SizedBox(height: 10),
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
              title: const Text("Erreur de connexion intergalactique"),
              content: Column(children: [
                const SizedBox(height: 10),
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
          //Nom de l'app
          const Text(
            'SpaceChat',
            style: TextStyle(
              fontSize: 36,
              color: Color.fromARGB(255, 16, 151, 255),
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 10),
          //logo
          Container(
            width: 250,
            height: 150,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/vaisseau.png"),
                    fit: BoxFit.fitWidth)),
          ),
          const SizedBox(height: 40),

          //toogleButton
          ToggleButtons(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.white,
            borderColor: Colors.grey, // Couleur de la bordure non sélectionnée
            color: Colors.grey, // Couleur du texte non sélectionné
            fillColor: Colors.blue,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            onPressed: (value) {
              setState(() {
                isLogin = value == 0;
              });
            },
            isSelected: [isLogin, !isLogin],
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Connexion"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Inscription"),
              ),
            ],
          ),

          const SizedBox(height: 30),

          //adresse mail
          _entryField(
              email, "Entrer votre adresse mail", const Icon(Icons.email)),
          const SizedBox(height: 20),
          //password
          _entryField(
              password, 'Entrer votre mot de passe', const Icon(Icons.lock),
              textObscured: true),
          const SizedBox(height: 30),
          //boutton
          _submitButton(context),
        ],
      ),
    );
  }
}
