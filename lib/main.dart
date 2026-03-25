import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/pages/home_page.dart';
import 'package:pill_reminder/pages/auth/login_page.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';
import 'package:pill_reminder/services/notification_service.dart';
import 'package:pill_reminder/pages/medication_detail_page.dart';
import 'package:pill_reminder/core/model/medicine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MedicineProvider>(
          create: (context) => MedicineProvider(
              Provider.of<AuthProvider>(context, listen: false)),
          update: (context, authProvider, _) => MedicineProvider(authProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.selectedMedicineId.addListener(_onNotificationTapped);
  }

  @override
  void dispose() {
    NotificationService.selectedMedicineId
        .removeListener(_onNotificationTapped);
    super.dispose();
  }

  void _onNotificationTapped() {
    final medicineId = NotificationService.selectedMedicineId.value;
    if (medicineId == null) return;

    final ctx = NotificationService.navigatorKey.currentContext;
    if (ctx == null) return;

    final provider = Provider.of<MedicineProvider>(ctx, listen: false);
    final medicine = provider.medicines.firstWhere(
      (m) => m.id.toString() == medicineId,
      orElse: () =>
          Medicine(name: '', time: '', intervalHours: 0, userName: ''),
    );

    if (medicine.name.isNotEmpty) {
      NotificationService.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MedicationDetailPage(medicine: medicine),
        ),
      );
    }

    NotificationService.selectedMedicineId.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      title: 'Lembrete de Remédio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DMSans',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Show splash while restoring session from disk
          if (auth.isLoading) {
            return const _SplashScreen();
          }
          return auth.isLoggedIn ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}

/// Shown for ~300 ms while SharedPreferences is read.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.medication_liquid_rounded,
                  color: Colors.white, size: 48),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            ],
          ),
        ),
      ),
    );
  }
}
