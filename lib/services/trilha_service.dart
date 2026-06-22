import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

class TrilhaService {
  static final TrilhaService _instancia = TrilhaService._interno();
  factory TrilhaService() => _instancia;
  TrilhaService._interno();

  bool _trilhaAtiva = false;
  final List<Position> _pontos = [];
  StreamSubscription<Position>? _gpsStream;

  String? ultimoArquivoGPX;

  // ------------------------------------------------------------
  //  INICIAR TRILHA — versão compatível com Android 11+
  // ------------------------------------------------------------
  Future<void> iniciarTrilha() async {
    // 1) GPS ligado?
    final gpsAtivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsAtivo) {
      throw Exception("GPS desativado. Ative o GPS para iniciar a trilha.");
    }

    // 2) Permissão foreground (suficiente para trilha com tela ligada)
    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw Exception("Permissão de localização negada.");
    }

    // *** IMPORTANTE ***
    // NÃO pedir background aqui — Android 11+ bloqueia.
    // Com a tela ligada, whileInUse funciona perfeitamente.

    _trilhaAtiva = true;
    _pontos.clear();

    await _gpsStream?.cancel();

    // 3) Inicia stream de localização
    _gpsStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 3,
      ),
    ).listen(
      (pos) {
        if (_trilhaAtiva) {
          _pontos.add(pos);
          print("📍 Ponto capturado: ${pos.latitude}, ${pos.longitude}");
        }
      },
      onError: (e) {
        print("❌ Erro no stream de GPS: $e");
      },
    );
  }

  // ------------------------------------------------------------
  //  ENCERRAR TRILHA — gerar GPX
  // ------------------------------------------------------------
  Future<File> encerrarTrilha() async {
    _trilhaAtiva = false;

    await _gpsStream?.cancel();
    _gpsStream = null;

    final dir = await getApplicationDocumentsDirectory();
    final arquivo = File(
      '${dir.path}/trilha_${DateTime.now().millisecondsSinceEpoch}.gpx',
    );

    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<gpx version="1.1" creator="SIAFAX Mobile">');
    buffer.writeln('<trk><name>Trilha SIAFAX</name><trkseg>');

    for (final p in _pontos) {
      final tempo = p.timestamp?.toUtc().toIso8601String() ?? "";
      buffer.writeln(
        '<trkpt lat="${p.latitude}" lon="${p.longitude}">'
        '<ele>${p.altitude}</ele>'
        '<time>$tempo</time>'
        '</trkpt>',
      );
    }

    buffer.writeln('</trkseg></trk></gpx>');

    await arquivo.writeAsString(buffer.toString());
    ultimoArquivoGPX = arquivo.path;

    return arquivo;
  }

  void limparTrilha() {
    _trilhaAtiva = false;
    _pontos.clear();
    _gpsStream?.cancel();
    _gpsStream = null;
    ultimoArquivoGPX = null;
  }
}
