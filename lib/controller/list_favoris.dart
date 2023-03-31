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
  //

  @override
  Widget build(BuildContext context) {
    Utilisateur myUser = Provider.of<UserProvider>(context).myUser;
    return GridView.builder(
        itemCount: myUser.favoris.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(otherUser.avatar ?? defaultImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(child: Text(otherUser.email)),
        );
      }
    },
  );
},






      );
  }
}
