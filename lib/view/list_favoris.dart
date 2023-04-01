import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/user_provider.dart';
import 'package:my_app/model/utilisateur.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/controller/globale.dart';
import 'package:provider/provider.dart';

class ListFavoris extends StatefulWidget {
  const ListFavoris({Key? key}) : super(key: key);

  @override
  State<ListFavoris> createState() => _ListFavorisState();
}

class _ListFavorisState extends State<ListFavoris> {
  final FirebaseManager firebaseManager = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Utilisateur>(
        future: firebaseManager.getCurrentUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          Utilisateur? myUser = snapshot.data;
          print({"myUser": myUser});

          if (myUser == null) {
            return const Text("Veuillez vous connecter");
          }

          return GridView.builder(
            itemCount: myUser.favoris.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return FutureBuilder<Utilisateur>(
                future: FirebaseManager().getUser(myUser.favoris[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erreur de chargement des données');
                  } else if (!snapshot.hasData) {
                    return const Text('Pas de données');
                  } else {
                    Utilisateur otherUser = snapshot.data!;
                    return Card(
                        elevation: 5.0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    otherUser.avatar ?? defaultImage),
                              ),
                              const SizedBox(height: 10,),
                              Center(child: Text(otherUser.email)),
                            ],
                          ),
                        ));
                  }
                },
              );
            },
          );
        });
  }
}
