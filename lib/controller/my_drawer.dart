import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'globale.dart';
import 'package:file_picker/file_picker.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //variable
  String? urlImage;
  String? nameImage;
  Uint8List? dataImage;

  //méthode
  openImage() async {
    FilePickerResult? resultat = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (resultat != null) {
      nameImage = resultat.files.first.name;
      dataImage = resultat.files.first.bytes;
      confirmationPop();
    }
  }

  confirmationPop() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(nameImage!),
            content: Image.memory(dataImage!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Annulation")),
              TextButton(
                  onPressed: () {
                    //enregistrer dans la base de donnée
                    FirebaseManager()
                        .Upload(myUser.uid, nameImage!, dataImage!)
                        .then((value) {
                      setState(() {
                        urlImage = value;
                        myUser.avatar = urlImage;
                      });

                      Map<String, dynamic> map = {"AVATAR": urlImage};
                      FirebaseManager().updateUser(myUser.uid, map);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Confimration"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            openImage();
          },
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(myUser.avatar ?? defaultImage),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: [Text(myUser.pseudo ?? ""), Text(myUser.email)],
        ),
        TextButton(
            onPressed: () {
              //déconnexion
            },
            child: const Text("Déconnexion")),
      ],
    ));
  }
}
