import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/controller/globale.dart';
import 'package:my_app/model/utilisateur.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({Key? key}) : super(key: key);

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseManager().cloudUsers.snapshots(),
        builder: (context, snap) {
          List documents = snap.data?.docs ?? [];
          if (documents.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return ListView.builder(
                itemCount: documents.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  Utilisateur otherUser = Utilisateur(documents[index]);
                  print("otherUser");
                  print(myUser.email);
                  if (otherUser.uid == myUser.uid) {
                    return Container();
                  } else {
                    return Card(
                      elevation: 5.0,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(otherUser.avatar ?? defaultImage),
                        ),
                        title: Text(otherUser.pseudo ?? ""),
                        subtitle: Text(otherUser.email),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: myUser.favoris.contains(otherUser.uid)
                                ? Colors.red
                                : Colors.amber,
                          ),
                          onPressed: () {
                            print(myUser.uid);
                            print(myUser.favoris);
                            setState(() {
                              myUser.favoris.add(otherUser.uid);

                              Map<String, dynamic> map = {
                                "FAVORIS": myUser.favoris,
                              };
                              FirebaseManager().updateUser(myUser.uid, map);
                            });
                          },
                        ),
                      ),
                    );
                  }
                });
          }
        });
  }
}
