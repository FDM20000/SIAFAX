// ------------------------------------------------------------
//  TELA R — Módulo Mobile SIAFAX (VERSÃO REORGANIZADA)
//  Botões 1–4 removidos, 5–8 reposicionados
//  Layout preservado 100%
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../services/trilha_service.dart';
import '../services/video_service.dart';
import '../services/export_service.dart';
import 'tela_cam.dart';

class TelaR extends StatefulWidget {
  const TelaR({super.key});

  @override
  State<TelaR> createState() => _TelaRState();
}

class _TelaRState extends State<TelaR> with WidgetsBindingObserver {
  final TrilhaService _trilhaService = TrilhaService();
  final VideoService _videoService = VideoService();
  final ExportService _exportService = ExportService();

  bool _exportando = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {
          _exportando = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  //  BOTÕES ESTILIZADOS
  // ------------------------------------------------------------
  Widget novoBotao(String texto, {VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF265A99),
            foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
          child: Text(texto),
        ),
      ),
    );
  }

  Widget botaoLaranja(String texto, {VoidCallback? onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
            foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
          child: Text(texto),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  //  BOTÃO 8 — MÓDULO DESKTOP
  // ------------------------------------------------------------
  Widget botaoModuloDesktop() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: 220,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
            foregroundColor: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Módulo Desktop'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Disponível na Windows Store do seu PC.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/images/logo_win_store.png',
                        height: 60,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text("Módulo - Desktop"),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  //  INTERFACE COMPLETA (layout preservado)
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2A4A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Image.asset("assets/images/logo_SIAFAX.png", height: 160),
              const SizedBox(height: 20),

              const Text(
                "Módulo Mobile\n\n\nSistema de Inspeção por \nInteligência Artificial \nda Faixa de Domínio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "\n\nEste aplicativo auxilia a fiscalização rodoviária na identificação de objetos "
                "que possam representar risco ao usuário da rodovia.\n\n"
                "O sistema detecta automaticamente Árvores, Postes, Placas e Obstáculos "
                "localizados dentro da Zona Livre (9 metros a contar da borda do pavimento).",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 260,
                child: Image.asset("assets/images/seta_para_baixo2.png"),
              ),

              const SizedBox(height: 20),

              const Text(
                "CONFIGURAÇÕES INICIAIS\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "• Ative o GPS do smartphone\n"
                "• Pressione o Botão 'Abrir Câmera'\n"
                "• Coloque o celular na horizontal\n"
                "• Fixe o celular no suporte\n"
                "• Faça o enquadramento,\nconforme exemplo abaixo.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 200,
                child: Image.asset("assets/images/enquadramento.png"),
              ),

              const SizedBox(height: 15),

              const Text(
               "Finalizadas as Configurações Iniciais,"
                "\nprossiga clicando em 'Abrir Câmera' !\n",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------------------------
              //  BOTÃO 0 — ABRIR CÂMERA
              // ------------------------------------------------------------
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TelaCam()),
                    );
                  },
                  child: const Text("Abrir Câmera"),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------------------
              //  BOTÃO 5 — EXPORTAR TRILHA
              // ------------------------------------------------------------
              novoBotao("Exporte Trilha", onPressed: () async {
                try {
                  if (_trilhaService.ultimoArquivoGPX == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nenhuma trilha para exportar.')),
                    );
                    return;
                  }

                  setState(() => _exportando = true);

                  await _exportService.exportarArquivo(
                    _trilhaService.ultimoArquivoGPX!,
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao exportar trilha: $e')),
                  );
                }
              }),

              // ------------------------------------------------------------
              //  BOTÃO 6 — EXPORTAR VÍDEO
              // ------------------------------------------------------------
              novoBotao("Exporte Vídeo", onPressed: () async {
                try {
                  if (_videoService.ultimoVideoPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nenhum vídeo para exportar.')),
                    );
                    return;
                  }

                  setState(() => _exportando = true);

                  await _exportService.exportarArquivo(
                    _videoService.ultimoVideoPath!,
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao exportar vídeo: $e')),
                  );
                }
              }),

              // ------------------------------------------------------------
              //  BOTÃO 7 — REINICIAR
              // ------------------------------------------------------------
              novoBotao("Reiniciar", onPressed: () {
                _trilhaService.limparTrilha();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trilha limpa.')),
                );
              }),

              const SizedBox(height: 20),

              const Text(
                "IMPORTANTE \n O processamento da IA é no seu PC \n Baixe o Módulo - Desktop aqui.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFFFFCC33)),
              ),

              // ------------------------------------------------------------
              //  BOTÃO 8 — MÓDULO DESKTOP
              // ------------------------------------------------------------
              botaoModuloDesktop(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
