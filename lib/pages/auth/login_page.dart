import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/pages/home_page.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/services/db_service.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        final user = await DBService()
            .loginUser(_userEmailController.text, _passwordController.text);
        if (user != null) {
          if (!mounted) return;
          await Provider.of<AuthProvider>(context, listen: false).login(
              user['username'] as String,
              email: user['email'] as String?);
          if (mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          }
        } else {
          _showSnack('Credenciais inválidas. Tente novamente.');
        }
      } else {
        await DBService().registerUser(
          _userNameController.text.trim(),
          _userEmailController.text.trim(),
          _passwordController.text,
        );
        setState(() => isLogin = true);
        _showSnack('Conta criada! Faça login.');
      }
    } catch (_) {
      _showSnack('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
      backgroundColor: AppColors.ink,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF2563EB), // Match bottom of gradient
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.45, 1.0],
              colors: [
                Color(0xFF0A0B1E),
                Color(0xFF1A1F6E),
                Color(0xFF2563EB),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 40),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo mark
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.15),
                                      width: 1),
                                ),
                                child: const Icon(
                                    Icons.medication_liquid_rounded,
                                    color: Colors.white,
                                    size: 28),
                              ),

                              const SizedBox(height: 36),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  isLogin
                                      ? 'Bem-vindo\nde volta.'
                                      : 'Crie sua\nconta.',
                                  key: ValueKey(isLogin),
                                  style: AppTextStyles.display.copyWith(
                                      color: Colors.white,
                                      letterSpacing: -1.2),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isLogin
                                    ? 'Acesse seus lembretes e receitas médicas.'
                                    : 'Comece a gerenciar seus medicamentos agora.',
                                style: AppTextStyles.body.copyWith(
                                    color: Colors.white.withOpacity(0.55)),
                              ),

                              const SizedBox(height: 44),

                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Column(
                                  children: [
                                    if (!isLogin) ...[
                                      _buildLabel('NOME DE USUÁRIO'),
                                      _buildTextField(
                                        controller: _userNameController,
                                        hint: 'Seu nome',
                                        icon: Icons.person_outline_rounded,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ],
                                ),
                              ),

                              _buildLabel('E-MAIL'),
                              _buildTextField(
                                controller: _userEmailController,
                                hint: 'email@exemplo.com',
                                icon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),

                              _buildLabel('SENHA'),
                              _buildTextField(
                                controller: _passwordController,
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                              ),

                              const SizedBox(height: 44),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppColors.primary),
                                        )
                                      : Text(
                                          isLogin ? 'Entrar' : 'Criar conta',
                                          style: AppTextStyles.subHeading
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 16),
                                        ),
                                ),
                              ),

                              const Spacer(), // Pushes toggle button down
                              const SizedBox(height: 40),

                              Center(
                                child: TextButton(
                                  onPressed: () =>
                                      setState(() => isLogin = !isLogin),
                                  child: Text(
                                    isLogin
                                        ? 'Não tem conta? Criar agora'
                                        : 'Já tem conta? Fazer login',
                                    style: AppTextStyles.body.copyWith(
                                        color: Colors.white.withOpacity(0.55),
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: AppTextStyles.label.copyWith(
                color: Colors.white.withOpacity(0.45), letterSpacing: 1.0)),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: AppTextStyles.input.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.input.copyWith(color: Colors.white.withOpacity(0.35)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.45), size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white.withOpacity(0.45),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.4), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorStyle: AppTextStyles.tag.copyWith(color: const Color(0xFFFC8181)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
    );
  }
}
