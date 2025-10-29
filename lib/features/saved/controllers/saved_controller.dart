import '../../../services/firebase/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedController {
  final _firestore = FirestoreService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getSavedIdeas() {
    return _firestore.getSavedIdeas();
  }

  Future<void> deleteIdea(String id) async {
    await _firestore.deleteIdea(id);
  }
}
