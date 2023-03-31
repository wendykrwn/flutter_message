import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/model/utilisateur.dart';

class FirebaseManager {
  //attributs
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudMessages = FirebaseFirestore.instance.collection("MESSAGES");
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  //ajoouter un utlisateur
  addUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).set(map);
  }

  //récuperer un utilisateur
  Future<Utilisateur> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return Utilisateur(snapshot);
  }

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    return cloudUsers.doc(userId).get();
  }

  //connecter avec un utilisateur
  Future<Utilisateur> connect(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String? uid = userCredential.user?.uid;
    if (uid == null) {
      return Future.error(("problème de connexion"));
    } else {
      return getUser(uid);
    }
  }

  //creer un utilisateur
  Future<Utilisateur> inscription(String email, String password) async {
    UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = authResult.user?.uid;
    if (uid == null) {
      return Future.error(("error"));
    } else {
      Map<String, dynamic> map = {"EMAIL": email, "FAVORIS": []};
      addUser(uid, map);
      return getUser(uid);
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  // mise à jour d'un utlisateur
  updateUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).update(map);
  }

  // Upload d'une image sur Firebase Storage
  Future<String> upload(
      String destination, String nameImage, Uint8List bytes) async {
    String imagePath = '$destination/$nameImage';
    TaskSnapshot snapshot = await storage.ref().child(imagePath).putData(bytes);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Creer une conversation
  Future<String> createChat(String user1Id, String user2Id) async {
    final DocumentReference chatDocRef = cloudMessages.doc('$user1Id-$user2Id');
    final Map<String, dynamic> chatData = {
      'user1Id': user1Id,
      'user2Id': user2Id,
    };
    await chatDocRef.set(chatData);
    return chatDocRef.id;
  }

  // Ajouter un message dans une conversation

  Future<void> addMessage(String chatId, String text, String senderId) async {
    final Timestamp timestamp = Timestamp.now();

    await cloudMessages.doc(chatId).collection('MESSAGES').add({
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
    });

    await cloudMessages.doc(chatId).update({
      'lastMessageText': text,
      'lastMessageSenderId': senderId,
      'lastMessageTimestamp': timestamp,
    });
  }

  //Recuperes une liste de conversation de l'utilisateur actuel
  Stream<QuerySnapshot> getChats() {
    if (currentUser?.uid == null) {
      return const Stream.empty();
    }
    else{
      return cloudMessages
          .where('user1Id', isEqualTo: currentUser?.uid)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots();
    }
  }

  //Recuperes une liste de conversation d'un chat specifique
  Stream<QuerySnapshot> getMessages(String chatId) {
    return cloudMessages
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }



}
