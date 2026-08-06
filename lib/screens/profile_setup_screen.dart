import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/media_service.dart';
import '../services/profile_service.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _matriculaCtrl = TextEditingController();
  final _fraseCtrl = TextEditingController();
  String? _fotoPath;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _matriculaCtrl.dispose();
    _fraseCtrl.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    final path = await context.read<MediaService>().tomarFoto();
    if (path != null) setState(() => _fotoPath = path);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await context.read<ProfileService>().guardarPerfil(
            nombre: _nombreCtrl.text,
            apellido: _apellidoCtrl.text,
            matricula: _matriculaCtrl.text,
            fotoPath: _fotoPath,
            frase: _fraseCtrl.text.trim().isEmpty
                ? 'La curiosidad es el primer paso para entender el cielo.'
                : _fraseCtrl.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu perfil')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _tomarFoto,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: _fotoPath != null ? FileImage(File(_fotoPath!)) : null,
                    child: _fotoPath == null
                        ? const Icon(Icons.camera_alt_outlined, size: 32)
                        : null,
                  ),
                ),
              ),
              Center(child: TextButton(onPressed: _tomarFoto, child: const Text('Agregar foto'))),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _matriculaCtrl,
                decoration: const InputDecoration(labelText: 'Matrícula'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fraseCtrl,
                decoration: const InputDecoration(
                  labelText: 'Frase motivadora (opcional)',
                  hintText: 'Sobre la curiosidad científica y el cielo',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}