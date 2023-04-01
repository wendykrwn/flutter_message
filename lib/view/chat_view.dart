import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/controller/firebase_manager.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.chatId, required this.recipientName})
      : super(key: key);

  final String chatId;
  final String recipientName;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseManager firebaseManager = FirebaseManager();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseManager.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final currentUserUid = firebaseManager.currentUser!.uid;
                    final isCurrentUser = message['senderId'] == currentUserUid;
                      return Container(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      margin:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Container(
                        constraints: const BoxConstraints(
                            maxWidth: 220, // largeur maximale
                          ),
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal:16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isCurrentUser ? Colors.blue : Color.fromARGB(255, 211, 211, 211),
                        ),
                        child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'],
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                timestampToHumanReadable(message['timestamp']),
                                style: const TextStyle(fontSize: 10, color:  Color.fromARGB(255, 93, 93, 93)),
                              ),
                            ],
                          ),
                      ) 
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildTextComposer(),
        ],
      ),
    );
  }

  String timestampToHumanReadable(int timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(dateTime);
  }


  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration.collapsed(
                    hintText: 'Tapez votre message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final text = _textEditingController.text.trim();
                if (text.isEmpty) {
                  return;
                }

                final senderId = firebaseManager.currentUser!.uid;
                await firebaseManager.addMessage(widget.chatId, text, senderId);

                _textEditingController.clear();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
            ),
          ],
        ),
      ),
    );
  }
}
