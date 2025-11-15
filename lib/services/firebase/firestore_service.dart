import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // 🔹 Guarda datos del usuario
  Future<void> saveUser(User user) async {
    final userRef = _db.collection('users').doc(user.uid);

    await userRef.set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photo': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // 🔹 Guarda una idea generada por el usuario
  Future<void> saveIdea({
    required String topic,
    required String idea,
    required String descripcion,
    required String hashtags,
    required String musica,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");

    await _db.collection('users').doc(user.uid).collection('saved_ideas').add({
      'topic': topic,
      'idea': idea,
      'descripcion': descripcion,
      'hashtags': hashtags,
      'musica': musica,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔹 Obtiene todas las ideas guardadas del usuario actual
  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedIdeas() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('saved_ideas')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 🔹 Elimina una idea guardada
  Future<void> deleteIdea(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('saved_ideas')
        .doc(id)
        .delete();
  }

  Future<void> updateUserPhoto(String uid, String photoUrl) async {
    await _db.collection('users').doc(uid).set({
      'photo': photoUrl,
    }, SetOptions(merge: true));
  }
}
