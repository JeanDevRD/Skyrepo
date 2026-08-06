import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/observacion.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../services/media_service.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/filter_bar.dart' show categoriasCielo;

class NewObservationScreen extends StatefulWidget {
  const NewObservationScreen({super.key});

  @override
  State<NewObservationScreen> createState() => _NewObservationScreenState();
}

class _NewObservationScreenState extends State<NewObservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _duracionCtrl = TextEditingController();
  final _ubicacionTextoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  String _categoria = categoriasCielo.first;
  String _condicionesCielo = 'Despejado';
  DateTime _fechaHora = DateTime.now();

  double? _lat;
  double? _lng;
  bool _buscandoUbicacion = false;

  String? _fotoPath;
  String? _audioPath;
  bool _grabando = false;
  bool _guardando = false;

  static const _condiciones = ['Despejado', 'Nublado', 'Bruma', 'Lluvia ligera'];

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _duracionCtrl.dispose();
    _ubicacionTextoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _capturarUbicacion() async {
    setState(() => _buscandoUbicacion = true);
    final ubicacion = await context.read<LocationService>().getCurrentLocation();
    setState(() {
      _buscandoUbicacion = false;
      if (ubicacion != null) {
        _lat = ubicacion.lat;
        _lng = ubicacion.lng;
      }
    });
    if (ubicacion == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el GPS. Escribe la ubicación manualmente.')),
      );
    }
  }

  Future<void> _tomarFoto() async {
    final path = await context.read<MediaService>().tomarFoto();
    if (path != null) setState(() => _fotoPath = path);
  }

  Future<void> _alternarGrabacion() async {
    final audio = context.read<AudioService>();
    if (!_grabando) {
      final ruta = await context.read<StorageService>().nuevaRutaAudio();
      await audio.iniciarGrabacion(ruta);
      setState(() => _grabando = true);
    } else {
      final path = await audio.detenerGrabacion();
      setState(() {
        _grabando = false;
        _audioPath = path;
      });
    }
  }

  Future<void> _elegirFechaHora() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHora,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (fecha == null || !mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fechaHora),
    );
    if (hora == null) return;
    setState(() {
      _fechaHora = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null && _ubicacionTextoCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Captura el GPS o escribe una ubicación en texto')),
      );
      return;
    }

    setState(() => _guardando = true);
    final observacion = Observacion(
      titulo: _tituloCtrl.text.trim(),
      fechaHora: _fechaHora.toIso8601String(),
      lat: _lat,
      lng: _lng,
      ubicacionTexto:
          _ubicacionTextoCtrl.text.trim().isEmpty ? null : _ubicacionTextoCtrl.text.trim(),
      duracionSeg: int.tryParse(_duracionCtrl.text.trim()),
      categoria: _categoria,
      condicionesCielo: _condicionesCielo,
      descripcion: _descripcionCtrl.text.trim(),
      fotoPath: _fotoPath,
      audioPath: _audioPath,
      creadoEn: DateTime.now().toIso8601String(),
    );

    await context.read<DatabaseService>().insertObservacion(observacion);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva observación')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título', hintText: 'Ej. Halo solar'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha y hora'),
              subtitle: Text(_fechaHora.toString().substring(0, 16)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _elegirFechaHora,
            ),
            const Divider(),
            DropdownButtonFormField<String>(
              value: _categoria,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: categoriasCielo.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _categoria = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _condicionesCielo,
              decoration: const InputDecoration(labelText: 'Condiciones del cielo'),
              items: _condiciones.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _condicionesCielo = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _duracionCtrl,
              decoration: const InputDecoration(labelText: 'Duración estimada (segundos, opcional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            Text('Ubicación', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: _buscandoUbicacion
                  ? const SizedBox(
                      height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.my_location_outlined),
              label: Text(_lat != null ? 'GPS capturado ✓' : 'Capturar ubicación GPS'),
              onPressed: _buscandoUbicacion ? null : _capturarUbicacion,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ubicacionTextoCtrl,
              decoration: const InputDecoration(
                labelText: 'Ubicación en texto (si no hay GPS)',
                hintText: 'Sector / municipio / provincia',
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descripcionCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Qué se vio, dirección (N/S/E/O), altura estimada',
              ),
              maxLines: 4,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(_fotoPath != null ? Icons.check : Icons.camera_alt_outlined),
                    label: Text(_fotoPath != null ? 'Foto agregada' : 'Agregar foto'),
                    onPressed: _tomarFoto,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(_grabando ? Icons.stop : Icons.mic_none_outlined),
                    label: Text(_grabando
                        ? 'Detener'
                        : (_audioPath != null ? 'Audio agregado' : 'Nota de voz')),
                    onPressed: _alternarGrabacion,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Guardar observación'),
            ),
          ],
        ),
      ),
    );
  }
}