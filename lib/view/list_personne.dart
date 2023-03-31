import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:my_app/controller/globale.dart';
import 'package:my_app/model/user_provider.dart';
import 'package:my_app/model/utilisateur.dart';
import 'package:my_app/view/chat_view.dart';
import 'package:provider/provider.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({Key? key}) : super(key: key);

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
  final FirebaseManager firebaseManager = FirebaseManager();

  void startNewConversation(String otherUserId) async {
    String currentUserId = firebaseManager.currentUser!.uid;
    // Vérifie s'il y a déjà une conversation entre ces deux utilisateurs
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CHATS')
        .where('user1Id', isEqualTo: currentUserId)
        .where('user2Id', isEqualTo: otherUserId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('CHATS')
          .where('user1Id', isEqualTo: otherUserId)
          .where('user2Id', isEqualTo: currentUserId)
          .get();
    }
    if (querySnapshot.docs.isNotEmpty) {
      // Si une conversation existe déjà, ouvrez la vue de discussion existante
      String chatId = querySnapshot.docs[0].id;
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatView(
            chatId: chatId,
            recipientName: 'recipientName : $otherUserId',
          ),
        ),
      );
    } else {
      String chatId =
          await FirebaseManager().createChat(currentUserId, otherUserId);

      // Sinon, créez une nouvelle conversation
      await FirebaseManager().addMessage(chatId, "", currentUserId);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatView(
            chatId: chatId,
            recipientName: 'recipientName : $otherUserId',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Utilisateur myUser = Provider.of<UserProvider>(context).myUser;

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
                  if (otherUser.uid == myUser.uid) {
                    return Container();
                  } else {
                    return Card(
                      elevation: 5.0,
                      color: Color.fromARGB(255, 255, 255, 255),
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
                        onTap: () {
                          startNewConversation(otherUser.uid);
                        },
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: myUser.favoris.contains(otherUser.uid)
                                ? Colors.red
                                : Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              if (!myUser.favoris.contains(otherUser.uid)) {
                                myUser.favoris.add(otherUser.uid);
                              } else {
                                myUser.favoris.remove(otherUser.uid);
                              }
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
