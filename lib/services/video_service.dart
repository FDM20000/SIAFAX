import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class VideoService {
  // ------------------------------------------------------------
  //  SINGLETON — garante que TelaCam e TelaR usem o MESMO objeto
  // ------------------------------------------------------------
  static final VideoService _instancia = VideoService._interno();
  factory VideoService() => _instancia;
  VideoService._interno();

  // ------------------------------------------------------------
  //  VARIÁVEIS INTERNAS
  // ------------------------------------------------------------
  CameraController? controller;
  bool _gravando = false;

  // Caminho final do vídeo salvo
  String? ultimoVideoPath;

  // ------------------------------------------------------------
  //  RECEBE O CONTROLLER DA TELA_CAM
  // ------------------------------------------------------------
  void setController(CameraController c) {
    controller = c;
  }

  // ------------------------------------------------------------
  //  INICIAR CAPTURA
  // ------------------------------------------------------------
  Future<void> iniciarCaptura() async {
    if (_gravando) return;
    if (controller == null) throw Exception("Controller não definido.");

    await controller!.startVideoRecording();
    _gravando = true;
  }

  // ------------------------------------------------------------
  //  PARAR CAPTURA
  // ------------------------------------------------------------
  Future<void> pararCaptura() async {
    if (!_gravando || controller == null) return;

    // Arquivo temporário gerado pelo plugin
    final file = await controller!.stopVideoRecording();

    // Diretório final do app
    final dir = await getApplicationDocumentsDirectory();

    // Caminho final DEFINITIVO
    final destino = File(
      '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );

    // Move o arquivo temporário para o destino final
    await File(file.path).copy(destino.path);

    // Guarda o caminho para exportação
    ultimoVideoPath = destino.path;

    _gravando = false;
  }
}
