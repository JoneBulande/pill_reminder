import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/pages/about_page.dart';
import 'package:pill_reminder/pages/login_page.dart';
import 'package:pill_reminder/widgets/home_card.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/widgets/dialog_box.dart';
import 'package:pill_reminder/pages/add_medication.dart';
import 'package:pill_reminder/widgets/my_container.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/pages/medication_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> _getUserName() async {
    return Provider.of<AuthProvider>(context, listen: false).userName!;
  }

  

  @override
  void initState() {
    super.initState();
  }

  Future<void> logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          dialogTitle: 'Deseja realmente sair?',
          onConfirm: () async {
            final authProvider = context.read<AuthProvider>();
            authProvider.logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.userName == null) {
          // Se o usuário não estiver logado, redireciona para a tela de login
          Future.microtask(
            () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                // Substitua "NovaPagina" pela página desejada
                builder: (context) => const LoginPage(),
              ),
              // Isso remove todas as páginas anteriores
              (Route<dynamic> route) => false,
            ),
          );
          return Center(child: const CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 17,
            bottomOpacity: 0.0,
            backgroundColor: AppColors.gray600,
          ),
          body: FutureBuilder<String>(
            future: _getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar o nome'));
              }

              String userName = snapshot.data ?? 'Usuário';

              return MyContainer(
                headerColor: AppColors.gray600,
                headerPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
                headerContent: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 67,
                          height: 67,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: .5,
                              color: AppColors.blueBase,
                            ),
                            color: AppColors.gray700,
                            borderRadius: BorderRadius.circular(75),
                          ),
                          child: const CircleAvatar(
                            minRadius: 67,
                            backgroundColor: AppColors.gray500,
                            backgroundImage: AssetImage('assets/images/profile.png'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Boas Vindas'),
                        Text(userName, style: AppTextStyles.subHeading),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PopupMenuButton(
                            color: Colors.white,
                            iconColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const AboutPage()),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 92,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(size: 15, Icons.info, color: AppColors.blueBase),
                                        const SizedBox(width: 7),
                                        Text('Sobre o App', style: AppTextStyles.tag),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: logout,
                                  child: SizedBox(
                                    width: 92,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          size: 15,
                                          Icons.logout_rounded,
                                          color: AppColors.redLight,
                                        ),
                                        const SizedBox(width: 7),
                                        Text('Sair', style: AppTextStyles.tag),
                                      ],
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bodyColor: AppColors.gray800,
                flex: 2,
                bodyPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32),
                bodyContent: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicationListPage(),
                          ),
                        );
                      },
                      cardTitle: 'Minhas receitas',
                      cardImgUrl: 'assets/images/Paper.png',
                      cardSubtitle: 'Acompanhe os medicamentos e gerencie lembretes',
                    ),
                    const SizedBox(height: 17),
                    HomeCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMedication(),
                          ),
                        );
                      },
                      cardTitle: 'Nova receita',
                      cardImgUrl: 'assets/images/Pills.png',
                      cardSubtitle: 'Cadastre novos lembretes de receitas',
                    ),
                  ],
                ),
              );
            },
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(14.0),
          //   child: SizedBox(
          //     height: 56,
          //     width: MediaQuery.of(context).size.width * .7,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         // Ação de avaliar
          //       },
          //       style: ButtonStyle(
          //         backgroundColor: WidgetStateProperty.all<Color>(
          //           AppColors.gray100,
          //         ),
          //       ),
          //       child: const Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(Icons.star_border, color: AppColors.gray800),
          //           SizedBox(width: 7),
          //           Text(
          //             'Avaliar',
          //             style: TextStyle(color: AppColors.gray800, fontSize: 16),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
