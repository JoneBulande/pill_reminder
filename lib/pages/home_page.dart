import 'package:flutter/material.dart';
import 'package:pill_reminder/core/app_colors.dart';
import 'package:pill_reminder/pages/login_page.dart';
import 'package:pill_reminder/widgets/home_card.dart';
import 'package:pill_reminder/core/app_text_style.dart';
import 'package:pill_reminder/pages/medication_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 17,
        bottomOpacity: 0.0,
        backgroundColor: AppColors.gray600,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.gray600,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.gray600,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 14),
                  child: Row(
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
                                width: 2,
                                color: AppColors.blueBase,
                              ),
                              color: AppColors.blueBase,
                              borderRadius: BorderRadius.circular(75),
                            ),
                            child: const CircleAvatar(
                              minRadius: 40,
                              backgroundColor: AppColors.blueBase,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.jpg'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Boas Vindas'),
                          Text('Helena Vasco', style: AppTextStyles.subHeading),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                size: 25,
                                Icons.logout_rounded,
                                color: AppColors.redLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.gray800,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(17),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MedicationList(),
                            ),
                          );
                        },
                        cardTitle: 'Minhas receitas',
                        cardImgUrl: 'assets/images/Paper.png',
                        cardSubtitle:
                            'Acompanhe os medicamentos e gerencie lembretes',
                      ),
                      const SizedBox(height: 17),
                      HomeCard(
                        onTap: () {},
                        cardTitle: 'Nova receita',
                        cardImgUrl: 'assets/images/Pills.png',
                        cardSubtitle: 'Cadastre novos lembretes de receitas',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width * .7,
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const HomePage(),
              //   ),
              // );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                AppColors.gray100,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, color: AppColors.gray800),
                SizedBox(width: 7),
                Text(
                  'Avaliar',
                  style: TextStyle(color: AppColors.gray800, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
