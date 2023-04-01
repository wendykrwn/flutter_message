import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/controller/firebase_manager.dart';
// import 'package:my_app/firebase_manager.dart';
// import 'package:my_app/chat_view.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({super.key});

  @override
  State<ListMessages> createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  final FirebaseManager firebaseManager = FirebaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseManager.getChats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;
          

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> chat =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              
              final otherUserId = chat['user1Id'] == firebaseManager.currentUser
                  ? chat['user2Id']
                  : chat['user1Id'];

              return FutureBuilder<DocumentSnapshot>(
                future: firebaseManager.getUserDocument(otherUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final Map<String, dynamic>? otherUser =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  // final lastMessage = chat['lastMessage'];
                 
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(otherUser!['email'][0]),
                    ),
                  );
                  // return ListTile(
                  //   leading: CircleAvatar(
                  //     child: Text(otherUser!['name'][0]),
                  //   ),
                  //   title: Text(otherUser['name']),
                  //   subtitle: Text(lastMessage['text']),
                  //   //Accéder à la conversation
                  //   // onTap: () {
                  //   //   Navigator.push(
                  //   //     context,
                  //   //     MaterialPageRoute(
                  //   //       builder: (context) => ChatView(
                  //   //         chatId: chats[index].id,
                  //   //         recipientName: otherUser['name'],
                  //   //       ),
                  //   //     ),
                  //   //   );
                  //   // },
                  // );
                },
              );
            },
          );
        },
      ),
    );
  }
}
