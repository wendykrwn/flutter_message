import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controller/firebase_manager.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.chatId, required this.recipientName})
      : super(key: key);

  final String chatId;
  final String recipientName;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: bodyPage(context, widget.chatId),
    ));
  }

  Widget bodyPage(BuildContext context, String chatId) {
   final Query query =
        FirebaseManager().cloudChats.doc(chatId).collection('MESSAGES').orderBy('timestamp');

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            final String text =
                (document.data() as Map<String, dynamic>)['text'];
            final String senderId =
                (document.data() as Map<String, dynamic>)['senderId'];


            return ListTile(
              title: Text(text),
              subtitle: Text(senderId),
            );
          }).toList(),
        );
      },
    );
  }
}
