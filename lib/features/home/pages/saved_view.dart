import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firebase/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:trendup_app/widgets/app_background.dart';
import 'package:flutter/services.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore.getSavedIdeas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "💾 No tienes ideas guardadas aún",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }

            final ideas = snapshot.data!.docs;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ideas.length,
              itemBuilder: (context, index) {
                final data = ideas[index].data();
                final id = ideas[index].id;

                final timestamp = data['createdAt'] as Timestamp?;
                final date = timestamp != null
                    ? DateFormat('d MMM yyyy, HH:mm').format(timestamp.toDate())
                    : 'Sin fecha';

                return Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Color(0xFF6A11CB),
                        size: 26,
                      ),
                      title: Text(
                        data['topic'] ?? 'Sin tema',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Eliminar idea"),
                                  content: const Text(
                                    "¿Seguro que quieres eliminar esta idea guardada?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await firestore.deleteIdea(id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Idea eliminada 🗑️'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const Icon(Icons.expand_more),
                        ],
                      ),
                      subtitle: Text(
                        date,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (data['idea'] != null) ...[
                                _section(context, "🎬 Idea", data['idea']),
                                _softDivider(),
                              ],
                              if (data['descripcion'] != null) ...[
                                _section(
                                  context,
                                  "📹 Qué hacer",
                                  data['descripcion'],
                                ),
                                _softDivider(),
                              ],
                              if (data['hashtags'] != null) ...[
                                _section(
                                  context,
                                  "🔖 Hashtags",
                                  data['hashtags'],
                                ),
                                _softDivider(),
                              ],
                              if (data['musica'] != null)
                                _section(context, "🎵 Música", data['musica']),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String text) {
    final isHashtags = title.contains("Hashtags");

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A11CB),
                ),
              ),

              if (isHashtags) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hashtags copiados')),
                    );
                  },
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _softDivider() {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 12),
      height: 1,
      color: Colors.black12,
    );
  }
}
