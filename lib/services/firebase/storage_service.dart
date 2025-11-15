import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$uid/profile.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
