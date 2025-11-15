import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/firebase/auth_service.dart';
import '../../../services/firebase/storage_service.dart';
import '../../../services/firebase/firestore_service.dart';
import 'package:trendup_app/widgets/app_background.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _auth = FirebaseAuth.instance;
  File? _imageFile;

  final _storageService = StorageService();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  // ✅ Método actualizado: pide permiso y abre galería correctamente
  Future<void> _pickImage() async {
    try {
      // Abrir la galería directamente
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() => _imageFile = file);

        final user = _auth.currentUser;
        if (user == null) return;

        // Subir a Storage
        final url = await _storageService.uploadProfileImage(
          uid: user.uid,
          file: file,
        );

        // Actualizar Auth
        await _authService.updateUserPhoto(url);

        // Actualizar Firestore
        await _firestoreService.updateUserPhoto(user.uid, url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil actualizada'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        debugPrint('📸 No se seleccionó ninguna imagen');
      }
    } catch (e) {
      debugPrint('❌ Error al abrir galería: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al abrir galería: $e')));
      }
    }
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Stack(
      children: [
        AppBackground(
          child: const SizedBox.expand(), // requerido
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Perfil',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (user?.photoURL != null
                                    ? NetworkImage(user!.photoURL!)
                                    : null)
                                as ImageProvider?,
                      child: (user?.photoURL == null && _imageFile == null)
                          ? const Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigoAccent,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  user?.displayName ?? 'Usuario sin nombre',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  user?.email ?? 'Correo no disponible',
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          Icons.calendar_today_rounded,
                          'Cuenta creada',
                          user?.metadata.creationTime != null
                              ? "${user!.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}"
                              : 'Desconocida',
                        ),
                        const Divider(),
                        _infoRow(
                          Icons.verified_user_rounded,
                          'UID',
                          user?.uid ?? '',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    label: const Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigoAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
