import 'package:flutter/material.dart';

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
    "🕹️ Gaming",
    "🤯 Curiosidades",
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
      body: Stack(
        children: [
          // Fondo con ondas suaves
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Color(0xFFEAEAFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Círculos difuminados (efecto ondas suaves)
          Positioned(
            top: -60,
            left: -60,
            child: _blurCircle(
              200,
              const Color(0xFF6A11CB).withValues(alpha: 0.2),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: _blurCircle(
              250,
              const Color(0xFFFF5E9C).withValues(alpha: 0.2),
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 60)],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _topicCtrl,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: "Escribe tu tema o elige una categoría",
        hintStyle: const TextStyle(color: Colors.black45),
        prefixIcon: const Icon(Icons.lightbulb_outline, color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
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
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: Colors.white,
          selectedColor: Colors.indigoAccent.withValues(alpha: 0.85),
          side: BorderSide(
            color: isSelected ? Colors.indigoAccent : Colors.black12,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton(Size size) {
    return SizedBox(
      width: size.width,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _generateIdea,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigoAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        label: const Text(
          "Generar idea con IA",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
