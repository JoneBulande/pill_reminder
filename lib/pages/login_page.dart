import 'package:flutter/material.dart';
import 'package:pill_reminder/core/app_colors.dart';
import 'package:pill_reminder/pages/home_page.dart';
import 'package:pill_reminder/core/app_text_style.dart';
import 'package:pill_reminder/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.redBase,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.redBase,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 170,
                ),
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.gray800,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(17),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 32, 18.0, 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entre para acessar suas receitas',
                          style: AppTextStyles.subHeading,
                        ),
                        const SizedBox(
                          height: 37,
                        ),
                        MyTextField(
                          label: 'E-mail',
                          controller: emailController,
                          hintText: 'email@example.com',
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Text('Senha', style: AppTextStyles.label),
                        const SizedBox(height: 7),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: AppColors.gray400,
                                )),
                            hintStyle: AppTextStyles.input,
                            suffixIcon: const Icon(Icons.visibility_outlined,
                                color: AppColors.blueBase),
                            hintText: 'senha',
                          ),
                        ),
                        const SizedBox(
                          height: 27,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColors.redBase)),
            child: Text(
              'Entrar',
              style: AppTextStyles.subHeadingBTN1,
            ),
          ),
        ),
      ),
    );
  }
}
