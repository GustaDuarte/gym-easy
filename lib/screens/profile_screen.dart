import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/_core/my_snackbar.dart';
import 'package:flutter_projects/service/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isSaving = false;
  bool _isUploadingPhoto = false;

  final ProfileService _profileService = ProfileService();
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.user.displayName ?? "");
    _emailController = TextEditingController(text: widget.user.email ?? "");
    _photoUrl = widget.user.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundApp,
      appBar: AppBar(
        backgroundColor: MyColors.strongOranje,
        iconTheme: const IconThemeData(color: MyColors.textCards),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        title: const Text(
          "Meu Perfil",
          style: TextStyle(
            color: MyColors.textCards,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColors.backgroundApp,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 8),

              // FOTO DE PERFIL (CLICÁVEL)
              Center(
                child: GestureDetector(
                  onTap: _isUploadingPhoto ? null : _changePhoto,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: MyColors.backgroundCards,
                        backgroundImage: (_photoUrl != null &&
                            _photoUrl!.isNotEmpty)
                            ? NetworkImage(_photoUrl!)
                            : const AssetImage("assets/logo.png")
                        as ImageProvider,
                      ),
                      if (_isUploadingPhoto)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                MyColors.strongOranje,
                              ),
                            ),
                          ),
                        ),
                      if (!_isUploadingPhoto)
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: MyColors.strongOranje,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Usuário",
                style: TextStyle(
                  color: MyColors.textCards,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // NOME (título branco + campo embaixo)
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: MyColors.backgroundCards,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nome",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      cursorColor: MyColors.strongOranje,
                      decoration: const InputDecoration(
                        hintText: "Digite seu nome",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "O nome não pode ser vazio";
                        }
                        if (value.trim().length < 3) {
                          return "O nome é muito curto";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // E-MAIL (SOMENTE LEITURA, mensagem fora da "label")
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: MyColors.backgroundCards,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "E-mail",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "O e-mail não pode ser alterado.",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Alterar senha (opcional)",
                style: TextStyle(
                  color: MyColors.textCards,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Se não quiser trocar a senha, deixe os campos abaixo em branco.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              // NOVA SENHA
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.backgroundCards,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: MyColors.textCards),
                  cursorColor: MyColors.strongOranje,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nova senha",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return "A senha deve ter pelo menos 6 caracteres";
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 8),

              // CONFIRMAR SENHA
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.backgroundCards,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  style: const TextStyle(color: MyColors.textCards),
                  cursorColor: MyColors.strongOranje,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirmar nova senha",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (_passwordController.text.isNotEmpty) {
                      if (value == null || value.isEmpty) {
                        return "Confirme a nova senha";
                      }
                      if (value != _passwordController.text) {
                        return "As senhas não coincidem";
                      }
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.strongOranje,
                    foregroundColor: MyColors.textCards,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    "Salvar alterações",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      showSnackBar(
        context: context,
        text: "Usuário não encontrado. Faça login novamente.",
      );
      return;
    }

    setState(() {
      _isUploadingPhoto = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (!mounted) return;

      if (picked == null) {
        setState(() {
          _isUploadingPhoto = false;
        });
        return;
      }

      final file = File(picked.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(user.uid)
          .child("profile.jpg");

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await user.updatePhotoURL(url);
      await user.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      setState(() {
        _photoUrl = updatedUser?.photoURL ?? url;
        _isUploadingPhoto = false;
      });

      showSnackBar(
        context: context,
        text: "Foto de perfil alterada!",
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploadingPhoto = false;
      });
      showSnackBar(
        context: context,
        text: "Erro ao atualizar a foto de perfil.",
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final String newName = _nameController.text.trim();
    final String newPassword = _passwordController.text.trim();

    final String? error = await _profileService.updateProfile(
      newName: newName,
      newPassword: newPassword.isNotEmpty ? newPassword : null,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (error != null) {
      showSnackBar(context: context, text: error);
    } else {
      showSnackBar(
        context: context,
        text: "Dados atualizados com sucesso!",
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final updatedUser = FirebaseAuth.instance.currentUser;
      Navigator.pop<User?>(context, updatedUser);
    }
  }
}
