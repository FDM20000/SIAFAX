import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaX extends StatelessWidget {
  const TelaX({super.key});

  // BOTÃO PADRÃO (AZUL)
  Widget novoBotao(String texto) {
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
          onPressed: () {},
          child: Text(texto),
        ),
      ),
    );
  }

  // BOTÃO LARANJA (AÇÕES CRÍTICAS)
  Widget botaoLaranja(String texto) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722), // LARANJÃO AVERMELHADO
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text(texto),
        ),
      ),
    );
  }

  // BOTÃO PARA DOWNLOAD DO MÓDULO DESKTOP
  Widget botaoModuloDesktop() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: 220,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5722),
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final url = Uri.parse("https://seu-link-do-modulo-desktop.com");

            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          child: const Text("Módulo - Desktop"),
        ),
      ),
    );
  }

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

              // LOGO
              Image.asset(
                "assets/logo_siafax.png",
                height: 160,
              ),

              const SizedBox(height: 20),

              // TÍTULO
              const Text(
                "Módulo Mobile\n\nSistema de Inspeção por Inteligência Artificial da Faixa de Domínio",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // TEXTO INSTITUCIONAL
              const Text(
                "Este aplicativo auxilia a fiscalização rodoviária na identificação de objetos "
                "que possam representar risco ao usuário da rodovia.\n\n"
                "O sistema detecta automaticamente Árvores de porte, Postes, Placas e Obstáculos "
                "localizados dentro da Zona Livre (9 metros a contar da borda do pavimento).",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // CONFIGURAÇÕES INICIAIS
              const Text(
                "CONFIGURAÇÕES INICIAIS:",
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
                "• Coloque o celular na horizontal\n"
                "• Fixe o celular no suporte\n"
                "• Faça o enquadramento 50/50 \n(metade pista, metade paisagem)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // IMAGEM DO ENQUADRAMENTO
              Image.asset(
                "assets/enquadramento.png",
                height: 260,
              ),

              const SizedBox(height: 20),

              // BOTÕES
              novoBotao("Inicie Trilha"),
              novoBotao("Inicie Captura de Vídeo"),

              // BOTÕES LARANJA
              botaoLaranja("Pare Captura de Vídeo"),
              botaoLaranja("Encerre a Trilha"),

              // RESTO DOS BOTÕES
              novoBotao("Exporte Trilha"),
              novoBotao("Exporte Vídeo"),
              novoBotao("Reiniciar"),

              const SizedBox(height: 20),

              const Text(
                "IMPORTANTE: O processamento da IA é no seu PC \n Baixe o Módulo - Desktop.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFFFCC33),
                ),
              ),

              // BOTÃO DO MÓDULO DESKTOP
              botaoModuloDesktop(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
