// ------------------------------------------------------------
//  TELA CAM — Layout FIEL ao modelo enviado
//  Landscape, preview 70% x 70%, botões à direita,
//  barra superior com instruções, barra inferior livre.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import '../services/video_service.dart';
import '../services/trilha_service.dart';

class TelaCam extends StatefulWidget {
  const TelaCam({super.key});

  @override
  State<TelaCam> createState() => _TelaCamState();
}

class _TelaCamState extends State<TelaCam> {
  final VideoService _videoService = VideoService();
  final TrilhaService _trilhaService = TrilhaService();

  CameraController? _controller;
  bool _inicializando = true;

  @override
  void initState() {
    super.initState();

    // Travar landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _iniciarCamera();
  }

  Future<void> _iniciarCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();

      // *** IMPORTANTE ***
      // Passa o controller para o VideoService
      _videoService.setController(_controller!);

      if (!mounted) return;

      setState(() => _inicializando = false);
    } catch (e) {
      debugPrint("Erro ao iniciar câmera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  //  BOTÕES (mesmo estilo da tela_r)
  // ------------------------------------------------------------
  Widget botaoAzul(String texto, VoidCallback onPressed) {
    return SizedBox(
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
    );
  }

  Widget botaoLaranja(String texto, VoidCallback onPressed) {
    return SizedBox(
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
    );
  }

  // ------------------------------------------------------------
  //  INTERFACE
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A2A4A),

      body: Column(
        children: [

          // ------------------------------------------------------------
          //  BARRA SUPERIOR COM INSTRUÇÕES
          // ------------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF0A2A4A),
            child: const Text(
              "POSICIONE na HORIZONTAL  ►  ENQUADRE  ►  FIXE  ►  INICIE ▼",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ------------------------------------------------------------
          //  ÁREA PRINCIPAL: PREVIEW + BOTÕES
          // ------------------------------------------------------------
          Expanded(
            child: Row(
              children: [

                // --------------------------------------------------------
                //  PREVIEW DA CÂMERA (lado esquerdo, 70% x 70%)
                // --------------------------------------------------------
                Expanded(
                  child: Center(
                    child: Container(
                      width: largura * 0.70,
                      height: altura * 0.70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _inicializando
                          ? const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CameraPreview(_controller!),
                            ),
                    ),
                  ),
                ),

                // --------------------------------------------------------
                //  COLUNA DE BOTÕES (lado direito)
                // --------------------------------------------------------
                Container(
                  width: 240,
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      botaoAzul("Inicie Trilha", () async {
                        await _trilhaService.iniciarTrilha();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Trilha iniciada!")),
                        );
                      }),

                      const SizedBox(height: 6),

                      botaoAzul("Inicie Captura de Vídeo", () async {
                        try {
                          await _videoService.iniciarCaptura();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Vídeo iniciado!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erro ao iniciar vídeo: $e")),
                          );
                        }
                      }),

                      const SizedBox(height: 6),

                      botaoLaranja("Pare Captura de Vídeo", () async {
                        try {
                          await _videoService.pararCaptura();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Vídeo salvo!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erro ao parar vídeo: $e")),
                          );
                        }
                      }),

                      const SizedBox(height: 6),

                      botaoLaranja("Encerre a Trilha", () async {
                        await _trilhaService.encerrarTrilha();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Trilha encerrada!")),
                        );
                      }),

                      const SizedBox(height: 6),

                      // ----------------------------------------------------
                      //  BOTÃO FECHAR
                      // ----------------------------------------------------
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            SystemChrome.setPreferredOrientations(
                              DeviceOrientation.values,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text("Fechar Câmera"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
