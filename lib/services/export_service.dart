import 'package:share_plus/share_plus.dart';

class ExportService {
  // ------------------------------------------------------------
  //  SINGLETON — garante que todas as telas usem o MESMO objeto
  // ------------------------------------------------------------
  static final ExportService _instancia = ExportService._interno();
  factory ExportService() => _instancia;
  ExportService._interno();

  // ------------------------------------------------------------
  //  EXPORTAR UM ARQUIVO
  // ------------------------------------------------------------
  Future<void> exportarArquivo(String caminho) async {
    await Share.shareXFiles([XFile(caminho)]);
  }

  // ------------------------------------------------------------
  //  EXPORTAR VÁRIOS ARQUIVOS
  // ------------------------------------------------------------
  Future<void> exportarMultiplos(List<String> caminhos) async {
    await Share.shareXFiles(
      caminhos.map((c) => XFile(c)).toList(),
    );
  }
}
