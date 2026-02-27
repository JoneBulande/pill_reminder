import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:pill_reminder/pages/home_page.dart';
import 'package:pill_reminder/pages/login_page.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Inicialize os fusos horários
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MedicineProvider>(
          create: (context) => MedicineProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, authProvider, previousProfileProvider) => MedicineProvider(authProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lembrete de Remédio',
      initialRoute: '/',
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return authProvider.isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  // Verifica se o usuário está logado ou registrado
  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.redBase,
            ),
            body: Center(
              child: Container(
                color: AppColors.redBase,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.gray800,
                  ),
                ),
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        if (isLoggedIn) {
          return const HomePage(); // Se o usuário estiver logado, mostra a home
        } else {
          return const LoginPage(); // Se não estiver logado, mostra a tela de login
        }
      },
    );
  }
}
