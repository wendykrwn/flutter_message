import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/model/utilisateur.dart';

class FirebaseManager {
  //attributs
  final FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudChats = FirebaseFirestore.instance.collection("CHATS");
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");

  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  //ajoouter un utlisateur
  addUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).set(map);
  }

  Future<Utilisateur> getCurrentUser() async {
    DocumentSnapshot snapshot = await cloudUsers.doc(currentUser!.uid).get();
    return Utilisateur(snapshot);
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
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? uid = authResult.user?.uid;
      if (uid == null) {
        return Future.error("Erreur lors de la création de l'utilisateur");
      } else {
        Map<String, dynamic> map = {"EMAIL": email, "FAVORIS": []};
        await addUser(uid, map);
        Utilisateur user = await getUser(uid);
        return user;
      }
    } catch (e) {
        return Future.error(e);
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
    final DocumentReference chatDocRef = cloudChats.doc('$user1Id-$user2Id');
    final Map<String, dynamic> chatData = {
      'user1Id': user1Id,
      'user2Id': user2Id,
    };
    await chatDocRef.set(chatData);
    return chatDocRef.id;
  }


  Future<String?> getChatId(String user1Id, String user2Id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('CHAT_LIST')
        .where('UTILISATEURS', arrayContainsAny: [user1Id, user2Id]).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      // Pas de conversation existante pour ces deux utilisateurs
      return null;
    }
  }


  // Ajouter un message dans une conversation

  Future<void> addMessage(String chatId, String text, String senderId) async {
    final DocumentReference messagesDocRef =
        cloudChats.doc(chatId).collection('MESSAGES').doc();
    final Map<String, dynamic> messageData = {
      'text': text,
      'senderId': senderId,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
    };
    await messagesDocRef.set(messageData);
  }


  //Recuperes une liste de conversation de l'utilisateur actuel
  Stream<QuerySnapshot> getChats() {
    if (currentUser?.uid == null) {
      return const Stream.empty();
    }
    else{
      return cloudChats
          .where('user1Id', isEqualTo: currentUser?.uid)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots();
    }
  }

  //Recuperes une liste de conversation d'un chat specifique
  Stream<QuerySnapshot> getMessages(String chatId) {
    return cloudChats
        .doc(chatId)
        .collection('MESSAGES')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }



}
