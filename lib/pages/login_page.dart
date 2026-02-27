import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/pages/home_page.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/services/db_service.dart';
import 'package:pill_reminder/widgets/my_container.dart';
import 'package:pill_reminder/widgets/my_text_field.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userName = _userNameController.text;
      final userEmail = _userEmailController.text;
      final password = _passwordController.text;

      if (isLogin) {
        final user = await DBService().loginUser(userEmail, password);
        if (user != null) {
          // Armazena o nome do usuário no Provider
          Provider.of<AuthProvider>(context, listen: false).login(user['username']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciais inválidas!')),
          );
        }
      } else {
        try {
          await DBService().registerUser(userName, userEmail, password);
          setState(() {
            isLogin = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro efetuado com Sucesso!, Pode Fazer o login')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Algo ocorreu errado!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.redBase,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: MyContainer(
          headerColor: AppColors.redBase,
          headerPadding: const EdgeInsets.all(18.0),
          headerContent: Image.asset(
            'assets/images/Logo.png',
            width: 170,
          ),
          bodyColor: AppColors.gray800,
          flex: isLogin ? 2 : 4,
          bodyPadding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 5),
          bodyContent: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entre para acessar suas receitas',
                    style: AppTextStyles.subHeading,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: !isLogin,
                    child: Column(
                      children: [
                        MyTextField(
                          label: 'Nome',
                          hintText: 'Nome de usuário',
                          controller: _userNameController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  MyTextField(
                    label: 'E-mail',
                    controller: _userEmailController,
                    hintText: 'email@example.com',
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text('Senha', style: AppTextStyles.label),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColors.gray400,
                        ),
                      ),
                      hintStyle: AppTextStyles.input,
                      suffixIcon: const Icon(Icons.visibility_outlined, color: AppColors.blueBase),
                      hintText: 'Sua senha',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite uma senha válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 2),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin ? 'Criar Conta' : 'Entrar'),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(AppColors.redBase)),
                      child: Text(
                        isLogin ? 'Entrar' : 'Cadastrar',
                        style: AppTextStyles.subHeadingBTN1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
