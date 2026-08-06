import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/security_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _borrando = false;

  Future<void> _confirmarBorrarTodo() async {
    final controller = TextEditingController();
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Esto eliminará TODAS las observaciones y sus fotos/audios de este dispositivo. '
              'Esta acción no se puede deshacer.',
            ),
            const SizedBox(height: 12),
            const Text('Escribe BORRAR para confirmar:'),
            const SizedBox(height: 8),
            TextField(controller: controller, autofocus: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim().toUpperCase() == 'BORRAR'),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    setState(() => _borrando = true);
    await context.read<SecurityService>().borrarTodo();
    if (!mounted) return;
    setState(() => _borrando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todos los datos fueron eliminados')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('CieloObs'),
            subtitle: Text('App de observación del cielo — funciona sin conexión a internet'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: const Text('Borrar todo', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Elimina todas las observaciones, fotos y audios del dispositivo'),
            trailing: _borrando
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _borrando ? null : _confirmarBorrarTodo,
          ),
        ],
      ),
    );
  }
}