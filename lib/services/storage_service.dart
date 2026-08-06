import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  Future<String> guardarArchivo(String origenPath, {required String carpeta}) async {
    final dir = await getApplicationDocumentsDirectory();
    final destinoDir = Directory('${dir.path}/$carpeta')..createSync(recursive: true);
    final nombre = '${DateTime.now().millisecondsSinceEpoch}_${origenPath.split('/').last}';
    final destino = '${destinoDir.path}/$nombre';
    await File(origenPath).copy(destino);
    return destino;
  }

  Future<void> borrarTodosLosArchivos() async {
    final dir = await getApplicationDocumentsDirectory();
    for (final carpeta in ['fotos', 'audios']) {
      final d = Directory('${dir.path}/$carpeta');
      if (await d.exists()) await d.delete(recursive: true);
    }
  }
}