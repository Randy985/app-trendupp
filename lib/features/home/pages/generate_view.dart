import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:trendup_app/services/firebase/firestore_service.dart';
import '../../../services/firebase/functions_service.dart';
import 'package:trendup_app/services/ads/ads_service.dart';
import 'package:trendup_app/widgets/app_background.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class GenerateView extends StatefulWidget {
  const GenerateView({super.key});

  @override
  State<GenerateView> createState() => _GenerateViewState();
}

class _GenerateViewState extends State<GenerateView> {
  bool _loading = true;
  Map<String, String> _idea = {};
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final topic = ModalRoute.of(context)?.settings.arguments as String?;
      if (topic != null) _generateIdea(topic);
    });
  }

  Future<void> _generateIdea(String topic) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final response = await FunctionsService().generateIdea(topic);
      if (!mounted) return;
      setState(() {
        _idea = _parseIdea(response);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Error generando idea: $e')),
      );
    }
  }

  Map<String, String> _parseIdea(String text) {
    final Map<String, String> data = {};

    final ideaMatch = RegExp(
      r'🎬\s*Idea[:：]?(.*?)(?=📹|🔖|🎵|$)',
      dotAll: true,
    ).firstMatch(text);
    final descMatch = RegExp(
      r'📹\s*Qué hacer(?: \(paso a paso\))?[:：]?(.*?)(?=🔖|🎵|$)',
      dotAll: true,
    ).firstMatch(text);
    final hashMatch = RegExp(
      r'🔖\s*Hashtags(?: recomendados)?[:：]?(.*?)(?=🎵|$)',
      dotAll: true,
    ).firstMatch(text);
    final musicMatch = RegExp(
      r'🎵\s*Música(?: recomendada| sugerida)?[:：]?(.*)',
      dotAll: true,
    ).firstMatch(text);

    if (ideaMatch != null) data['idea'] = ideaMatch.group(1)!.trim();
    if (descMatch != null) data['descripcion'] = descMatch.group(1)!.trim();
    if (hashMatch != null) data['hashtags'] = hashMatch.group(1)!.trim();
    if (musicMatch != null) data['musica'] = musicMatch.group(1)!.trim();

    return data;
  }

  void _newIdea() {
    final topic = ModalRoute.of(context)?.settings.arguments as String?;
    if (topic != null) {
      setState(() {
        _loading = true;
        _idea.clear();
        _saved = false;
      });
      _generateIdea(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topic = ModalRoute.of(context)?.settings.arguments ?? 'Tema';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 20,
                color: Colors.pinkAccent,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 180,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    'Idea para: $topic',
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: AppBackground(
        child: _loading
            ? _buildLoading(size)
            : _idea.isEmpty
            ? _buildEmptyState()
            : _buildIdeaContent(context),
      ),
    );
  }

  Widget _buildLoading(Size size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/loading_paperplane.json',
              width: size.width * 0.80,
            ),
            const SizedBox(height: 28),
            const Text(
              "Generando idea con IA...",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _section(Icons.movie_filter_rounded, "Idea", _idea["idea"]),
                    _softDivider(),
                    _section(
                      Icons.lightbulb_outline_rounded,
                      "Qué hacer",
                      _idea["descripcion"],
                    ),
                    _softDivider(),
                    _section(Icons.tag_rounded, "Hashtags", _idea["hashtags"]),
                    _softDivider(),
                    _section(
                      Icons.music_note_rounded,
                      "Música",
                      _idea["musica"],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _bottomButtons(context),
        ],
      ),
    );
  }

  Widget _section(IconData icon, String title, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigoAccent, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // BOTÓN COPIAR SOLO PARA HASHTAGS
              if (title == "Hashtags") ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Hashtags copiados")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 22,
                      color: Colors.indigoAccent,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15.5,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionButton(Icons.refresh_rounded, "Nueva idea", () {
          AdsService.instance.onIdeaGenerated();
          _newIdea();
        }, Colors.indigoAccent),

        _actionButton(
          Icons.bookmark_border_rounded,
          _saved ? "Guardado" : "Guardar",
          () async {
            if (_saved) return;

            final topic =
                ModalRoute.of(context)?.settings.arguments as String? ??
                'Sin tema';
            final firestore = FirestoreService();

            await firestore.saveIdea(
              topic: topic,
              idea: _idea["idea"] ?? '',
              descripcion: _idea["descripcion"] ?? '',
              hashtags: _idea["hashtags"] ?? '',
              musica: _idea["musica"] ?? '',
            );

            if (!mounted) return; // <-- evita usar context si el widget murió

            setState(() => _saved = true);

            showGeneralDialog(
              // ignore: use_build_context_synchronously
              context: context,
              barrierDismissible: true,
              barrierLabel: "alert",
              barrierColor: Colors.black54.withValues(alpha: 0.4),
              transitionDuration: const Duration(milliseconds: 240),
              pageBuilder: (_, __, ___) => const SizedBox.shrink(),
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    );

                    return Transform.scale(
                      scale: curved.value,
                      child: Opacity(
                        opacity: animation.value,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green,
                                  size: 64,
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  "Idea guardada",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Tu idea fue almacenada correctamente.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
            );
          },
          _saved ? Colors.grey : Colors.green,
        ),

        _actionButton(Icons.share_rounded, "Compartir", () {
          final ideaTexto =
              '''
Idea: ${_idea["idea"] ?? ""}

Qué hacer:
${_idea["descripcion"] ?? ""}

Hashtags:
${_idea["hashtags"] ?? ""}

Música:
${_idea["musica"] ?? ""}
'''
                  .trim();
          // ignore: deprecated_member_use
          Share.share(ideaTexto);
        }, Colors.pinkAccent),
      ],
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    Color color, {
    Key? key,
  }) {
    return Expanded(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: color,
            elevation: 1,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: color.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Sin resultado",
        style: TextStyle(fontSize: 16, color: Colors.black54),
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
