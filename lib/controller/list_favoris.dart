import 'package:flutter/material.dart';
import 'package:my_app/model/utilisateur.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/controller/globale.dart';

class ListFavoris extends StatefulWidget {
  const ListFavoris({Key? key}) : super(key: key);

  @override
  State<ListFavoris> createState() => _ListFavorisState();
}

class _ListFavorisState extends State<ListFavoris> {
  //
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: myUser.favoris.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          FirebaseManager().getUser(myUser.favoris[index]).then((value) {
            Utilisateur otherUser = value;
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(otherUser.avatar ?? defaultImage))),
            );
          });
        });
  }
}
