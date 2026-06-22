import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TrilhaService {
  bool _trilhaAtiva = false;

  // ------------------------------------------------------------
  //  INICIAR TRILHA
  // ------------------------------------------------------------
  Future<void> iniciarTrilha() async {
    _trilhaAtiva = true;
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // ------------------------------------------------------------
  //  ENCERRAR TRILHA — SALVA ARQUIVO GPX NO DIRETÓRIO INTERNO
  // ------------------------------------------------------------
  Future<File> encerrarTrilha() async {
    _trilhaAtiva = false;

    // Diretório interno seguro do app (Android/iOS)
    final dir = await getApplicationDocumentsDirectory();

    final arquivo = File('${dir.path}/trilha_simulada.gpx');

    await arquivo.writeAsString('<gpx>Simulação</gpx>');

    return arquivo;
  }

  // ------------------------------------------------------------
  //  LIMPAR TRILHA
  // ------------------------------------------------------------
  void limparTrilha() {
    _trilhaAtiva = false;
  }
}
