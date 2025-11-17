import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:trendup_app/services/ads/ads_service.dart';
import 'package:trendup_app/widgets/app_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _topicCtrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  String? _selectedCategory;

  final List<String> _categories = [
    "🕺 Humor",
    "❤️ Pareja",
    "🍳 Cocina",
    "💄 Belleza",
    "💬 Frases",
    "🎮 Retos",
    "💪 Fitness",
    "💻 Tecnología",
    "👗 Moda",
    "🎵 Música",
    "✈️ Viajes",
    "🎬 Cine",
    "📚 Educación",
    "🤯 Curiosidades",
    "🐶 Mascotas",
    "🏡 Vida diaria",
    "🛒 Recomendaciones",
    "😮 Storytime",
    "🤑 Emprendimiento",
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _topicCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _generateIdea() {
    // Contar idea para anuncios
    AdsService.instance.onIdeaGenerated();

    String topic = _topicCtrl.text.trim();

    if (topic.isEmpty) {
      topic = (_selectedCategory ?? '')
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .trim();
    }

    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un tema o elige una categoría'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/generate', arguments: topic);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: const Text(
                            "✨ Inspírate con una idea nueva",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(),
                        const SizedBox(height: 20),
                        _buildCategoryWrap(),
                        const Spacer(),
                        _buildGenerateButton(size),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _topicCtrl,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Escribe tu tema o elige una categoría",
          hintStyle: const TextStyle(color: Colors.black45),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 38,
            maxWidth: 38,
            maxHeight: 38,
          ),
          prefixIcon: Lottie.asset(
            'assets/lottie/Idea.json',
            fit: BoxFit.contain,
          ),

          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = selected ? cat : null;
              _topicCtrl.text = _selectedCategory != null
                  ? cat.replaceAll(RegExp(r'[^\w\s]'), '')
                  : '';
            });
          },
          labelPadding: const EdgeInsets.only(left: 4, right: 4),

          labelStyle: TextStyle(
            color: isSelected ? Colors.grey[800] : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          checkmarkColor: Colors.grey[800],

          backgroundColor: Colors.white,
          selectedColor: const Color(0xFFFFBE5D),
          side: const BorderSide(color: Color(0xFFFFBE5D)),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton(Size size) {
    return SizedBox(
      width: size.width,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF5F8CFF), Color(0xFF7B7EFF), Color(0xFF9B6CFF)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _generateIdea,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: Lottie.asset(
                    'assets/lottie/chatbot_animation.json',
                    fit: BoxFit.contain,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(['**'], value: Color(0xFFF8F9FF)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Generar idea con IA",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
