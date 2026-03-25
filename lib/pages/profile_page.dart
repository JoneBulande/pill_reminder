import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/services/db_service.dart';
import 'package:pill_reminder/widgets/dialog_box.dart';
import 'package:pill_reminder/pages/auth/login_page.dart';
import 'package:pill_reminder/pages/about_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _currentPassCtrl;
  late TextEditingController _newPassCtrl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameCtrl = TextEditingController(text: auth.userName ?? '');
    _currentPassCtrl = TextEditingController();
    _newPassCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final email = auth.userEmail;

    try {
      // If user filled password fields, verify old password first
      if (_currentPassCtrl.text.isNotEmpty) {
        if (email == null) throw Exception('no email');
        final user = await DBService().loginUser(email, _currentPassCtrl.text);
        if (user == null) {
          _showSnack('Senha atual incorreta.');
          return;
        }
        // Update password
        if (_newPassCtrl.text.isNotEmpty) {
          await DBService().updateUserPassword(email, _newPassCtrl.text);
        }
      }

      // Update display name
      await auth.updateUserName(_nameCtrl.text.trim());

      setState(() => _isEditing = false);
      _showSnack('Perfil atualizado com sucesso!');
    } catch (_) {
      _showSnack('Algo deu errado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
    final auth = context.watch<AuthProvider>();
    final initial = (auth.userName ?? 'U').substring(0, 1).toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.headerGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Avatar
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2),
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: AppTextStyles.display
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          if (_isEditing)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primaryMid,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 13),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        auth.userName ?? 'Usuário',
                        style:
                            AppTextStyles.headingWhite.copyWith(fontSize: 20),
                      ),
                      if (auth.userEmail != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          auth.userEmail!,
                          style: AppTextStyles.greeting,
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            title: Text('Perfil',
                style: AppTextStyles.subHeading.copyWith(color: Colors.white)),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed: () {
                  if (_isEditing) {
                    _saveChanges();
                  } else {
                    setState(() {
                      _isEditing = true;
                      _currentPassCtrl.clear();
                      _newPassCtrl.clear();
                    });
                  }
                },
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(
                        _isEditing ? 'Salvar' : 'Editar',
                        style: AppTextStyles.subHeading
                            .copyWith(color: Colors.white, fontSize: 14),
                      ),
              ),
              if (_isEditing)
                TextButton(
                  onPressed: () => setState(() => _isEditing = false),
                  child: Text(
                    'Cancelar',
                    style: AppTextStyles.body.copyWith(
                        color: Colors.white.withOpacity(0.6), fontSize: 14),
                  ),
                ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Body ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Edit fields ─────────────────────
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isEditing
                          ? _EditSection(
                              nameCtrl: _nameCtrl,
                              currentPassCtrl: _currentPassCtrl,
                              newPassCtrl: _newPassCtrl,
                            )
                          : const SizedBox.shrink(),
                    ),

                    if (!_isEditing) ...[
                      // ── Read-only info cards ──────────
                      const _SectionHeader(label: 'INFORMAÇÕES'),
                      const SizedBox(height: 12),
                      _InfoCard(children: [
                        _InfoRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Nome',
                          value: auth.userName ?? '—',
                        ),
                        _Divider(),
                        _InfoRow(
                          icon: Icons.alternate_email_rounded,
                          label: 'E-mail',
                          value: auth.userEmail ?? '—',
                        ),
                      ]),
                      const SizedBox(height: 28),
                    ],

                    // ── Settings / actions ────────────
                    const _SectionHeader(label: 'CONFIGURAÇÕES'),
                    const SizedBox(height: 12),
                    _InfoCard(children: [
                      _ActionRow(
                        icon: Icons.info_outline_rounded,
                        label: 'Sobre o App',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AboutPage())),
                      ),
                      _Divider(),
                      _ActionRow(
                        icon: Icons.notifications_outlined,
                        label: 'Notificações',
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeThumbColor: AppColors.primary,
                        ),
                      ),
                    ]),

                    const SizedBox(height: 28),

                    // ── Danger zone ───────────────────
                    const _SectionHeader(label: 'CONTA'),
                    const SizedBox(height: 12),
                    _InfoCard(children: [
                      _ActionRow(
                        icon: Icons.logout_rounded,
                        label: 'Sair da conta',
                        color: AppColors.accent,
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => DialogBox(
                            dialogTitle: 'Deseja realmente sair?',
                            onConfirm: () {
                              auth.logout();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                (_) => false,
                              );
                            },
                            onCancel: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Lembrete de Remédio  ·  v1.0.0',
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.gray700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) =>
      Text(label, style: AppTextStyles.label.copyWith(letterSpacing: 1.0));
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05), width: 0.5),
        ),
        child: Column(children: children),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gray500),
            const SizedBox(width: 14),
            Text(label, style: AppTextStyles.body.copyWith(fontSize: 14)),
            const Spacer(),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(fontSize: 14)),
          ],
        ),
      );
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _ActionRow(
      {required this.icon,
      required this.label,
      this.color,
      this.onTap,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.ink;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 18, color: c),
              const SizedBox(width: 14),
              Text(label,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: c, fontSize: 14)),
              const Spacer(),
              trailing ??
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.gray600),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Divider(
            height: 0.5, thickness: 0.5, color: Colors.black.withOpacity(0.06)),
      );
}

class _EditSection extends StatefulWidget {
  final TextEditingController nameCtrl;
  final TextEditingController currentPassCtrl;
  final TextEditingController newPassCtrl;
  const _EditSection({
    required this.nameCtrl,
    required this.currentPassCtrl,
    required this.newPassCtrl,
  });

  @override
  State<_EditSection> createState() => _EditSectionState();
}

class _EditSectionState extends State<_EditSection> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(label: 'EDITAR PERFIL'),
        const SizedBox(height: 12),
        _InfoCard(children: [
          _FieldTile(
            label: 'Nome',
            child: TextFormField(
              controller: widget.nameCtrl,
              style: AppTextStyles.input,
              decoration: _dec('Seu nome'),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
            ),
          ),
        ]),
        const SizedBox(height: 20),
        const _SectionHeader(label: 'ALTERAR SENHA'),
        const SizedBox(height: 4),
        Text('Deixe em branco para manter a senha atual.',
            style: AppTextStyles.body.copyWith(fontSize: 12)),
        const SizedBox(height: 12),
        _InfoCard(children: [
          _FieldTile(
            label: 'Senha atual',
            child: TextFormField(
              controller: widget.currentPassCtrl,
              obscureText: _obscureCurrent,
              style: AppTextStyles.input,
              decoration: _dec('••••••••',
                  suffix: _EyeBtn(
                    obscure: _obscureCurrent,
                    onTap: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  )),
            ),
          ),
          _Divider(),
          _FieldTile(
            label: 'Nova senha',
            child: TextFormField(
              controller: widget.newPassCtrl,
              obscureText: _obscureNew,
              style: AppTextStyles.input,
              decoration: _dec('Nova senha',
                  suffix: _EyeBtn(
                    obscure: _obscureNew,
                    onTap: () => setState(() => _obscureNew = !_obscureNew),
                  )),
            ),
          ),
        ]),
        const SizedBox(height: 28),
      ],
    );
  }

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.input.copyWith(color: AppColors.gray600),
        suffixIcon: suffix,
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      );
}

class _FieldTile extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldTile({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child:
                  Text(label, style: AppTextStyles.body.copyWith(fontSize: 14)),
            ),
            Expanded(child: child),
          ],
        ),
      );
}

class _EyeBtn extends StatelessWidget {
  final bool obscure;
  final VoidCallback onTap;
  const _EyeBtn({required this.obscure, required this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 18,
          color: AppColors.gray500,
        ),
        onPressed: onTap,
      );
}
