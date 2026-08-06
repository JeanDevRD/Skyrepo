import 'package:image_picker/image_picker.dart';
import 'storage_service.dart';

class MediaService {
  final _picker = ImagePicker();

  Future<String?> tomarFoto() async {
    final xfile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (xfile == null) return null;
    return StorageService.instance.guardarArchivo(xfile.path, carpeta: 'fotos');
  }
}