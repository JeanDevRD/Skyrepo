// services/profile_service.dart
import '../models/perfil.dart';
import 'database_service.dart';

class ProfileService {
  final _db = DatabaseService.instance;

  Future<Perfil?> getPerfil() => _db.getPerfil();

  Future<void> guardarPerfil({
    required String nombre,
    required String apellido,
    required String matricula,
    String? fotoPath,
    required String frase,
  }) async {
    if (nombre.trim().isEmpty || apellido.trim().isEmpty || matricula.trim().isEmpty) {
      throw ArgumentError('Nombre, apellido y matrícula son obligatorios');
    }
    await _db.savePerfil(Perfil(
      nombre: nombre.trim(),
      apellido: apellido.trim(),
      matricula: matricula.trim(),
      fotoPath: fotoPath,
      frase: frase.trim(),
    ));
  }

  Future<bool> tienePerfilConfigurado() async => (await getPerfil()) != null;
}