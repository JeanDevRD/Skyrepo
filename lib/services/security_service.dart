import 'database_service.dart';
import 'storage_service.dart';

class SecurityService {
 
  Future<void> borrarTodo({bool borrarPerfil = false}) async {
    await DatabaseService.instance.deleteAllObservaciones();
    await StorageService.instance.borrarTodosLosArchivos();
    if (borrarPerfil) {
      final db = await DatabaseService.instance.db;
      await db.delete('perfil');
    }
  }
}