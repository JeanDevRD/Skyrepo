// services/audio_service.dart — nota de voz con record + audioplayers
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'storage_service.dart';

class AudioService {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  Future<void> iniciarGrabacion(String path) async {
    if (await _recorder.hasPermission()) {
      await _recorder.start(const RecordConfig(), path: path);
    }
  }

  Future<String?> detenerGrabacion() => _recorder.stop();

  Future<void> reproducir(String path) => _player.play(DeviceFileSource(path));
}