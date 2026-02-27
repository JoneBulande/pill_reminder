import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: AppColors.gray800,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.gray800,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset('assets/images/icon.png', width: 50),
                  title: const Text('Lembrete de remédio'),
                  subtitle: const Text('1.0.0+0'),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Lembrete de remédio',
                        applicationVersion: '1.0.0+0',
                        applicationIcon: Image.asset('assets/images/icon.png', width: 50),
                        children: <Widget>[
                          Text(
                            'Um aplicativo simples para ajudar você a nunca esquecer de tomar seus medicamentos.',
                            style: AppTextStyles.input,
                          )
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 17),
                const Text('Seja bem-vindo ao Lembrete de Remédio, o aplicativo que ajuda você a cuidar da sua saúde!'),
                const SizedBox(height: 7),
                const Text(
                    'Com o Lembrete de Remédio, você pode organizar facilmente seus horários de medicação e nunca mais esquecer de tomar seus remédios.'),
                const SizedBox(height: 17),
                RichText(
                  text: const TextSpan(
                    text: 'Funcionalidades principais:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '- Adicione medicamentos e horários personalizados;\n'
                            '- Receba notificações para cada lembrete programado;\n'
                            '- Gerencie seu histórico de medicação.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                RichText(
                  text: const TextSpan(
                    text: 'Por que usar o Lembrete de Remédio?\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Cuidar da sua saúde ficou mais fácil. Tenha total controle sobre seus medicamentos e certifique-se de seguir seu tratamento corretamente.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 27),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
