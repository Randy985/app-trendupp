import 'package:cloud_firestore/cloud_firestore.dart';

class IdeaModel {
  final String id;
  final String topic;
  final String idea;
  final String descripcion;
  final String hashtags;
  final String musica;
  final DateTime createdAt;

  IdeaModel({
    this.id = '',
    required this.topic,
    required this.idea,
    required this.descripcion,
    required this.hashtags,
    required this.musica,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'idea': idea,
      'descripcion': descripcion,
      'hashtags': hashtags,
      'musica': musica,
      'createdAt': createdAt,
    };
  }

  factory IdeaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IdeaModel(
      id: doc.id,
      topic: data['topic'] ?? '',
      idea: data['idea'] ?? '',
      descripcion: data['descripcion'] ?? '',
      hashtags: data['hashtags'] ?? '',
      musica: data['musica'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
