import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/pages/auth/login_page.dart';
import 'package:pill_reminder/pages/profile_page.dart';
import 'package:pill_reminder/widgets/home_card.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/widgets/dialog_box.dart';
import 'package:pill_reminder/pages/add_medication.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';
import 'package:pill_reminder/pages/medication_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _pages = [
    _DashboardTab(),
    MedicationListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.userName == null) {
            Future.microtask(() => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                ));
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: _PremiumNavBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          );
        },
      ),
    );
  }
}

// ── Bottom nav bar ────────────────────────────────────────────────────────

class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _PremiumNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.07), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                iconOutlined: Icons.home_outlined,
                label: 'Início',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.medication_rounded,
                iconOutlined: Icons.medication_outlined,
                label: 'Receitas',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                iconOutlined: Icons.person_outline_rounded,
                label: 'Perfil',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconOutlined;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.iconOutlined,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.primarySurface : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                selected ? icon : iconOutlined,
                size: 22,
                color: selected ? AppColors.primary : AppColors.gray500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
                color: selected ? AppColors.primary : AppColors.gray500,
                letterSpacing: 0,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashboard tab ─────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final medicines = context.watch<MedicineProvider>().medicines;

    final totalMeds = medicines.length;
    final todayCount = medicines
        .where((m) => m.intervalHours <= 24)
        .length; // simplistic "today" count

    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────
        SliverAppBar(
          expandedHeight: 260,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.headerGradient),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            child: Text(
                              (auth.userName ?? 'U')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: AppTextStyles.subHeading
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          _HeaderIconBtn(
                            icon: Icons.add_rounded,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddMedication()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Olá,', style: AppTextStyles.greeting),
                      Text(
                        auth.userName ?? 'Usuário',
                        style: AppTextStyles.headingWhite
                            .copyWith(fontSize: 24, letterSpacing: -0.7),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      // Stats row
                      Row(
                        children: [
                          _StatChip(number: '$totalMeds', label: 'Receitas'),
                          const SizedBox(width: 8),
                          _StatChip(number: '$todayCount', label: 'Hoje'),
                          const SizedBox(width: 8),
                          const _StatChip(number: '87%', label: 'Aderência'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          centerTitle: false,
        ),

        // ── Body ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUAS ATIVIDADES',
                    style: AppTextStyles.label.copyWith(letterSpacing: 1.0)),
                const SizedBox(height: 14),
                HomeCard(
                  onTap: () {
                    // Switch to Receitas tab via the parent
                    final state =
                        context.findAncestorStateOfType<_HomePageState>();
                    state?.setState(() => state._currentIndex = 1);
                  },
                  cardTitle: 'Minhas receitas',
                  cardImgUrl: 'assets/images/Paper.png',
                  cardSubtitle: 'Acompanhe e gerencie lembretes',
                ),
                HomeCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddMedication()),
                  ),
                  cardTitle: 'Nova receita',
                  cardImgUrl: 'assets/images/Pills.png',
                  cardSubtitle: 'Cadastre novos medicamentos',
                ),
                const SizedBox(height: 28),
                if (medicines.isNotEmpty) ...[
                  Text('PRÓXIMAS DOSES',
                      style: AppTextStyles.label.copyWith(letterSpacing: 1.0)),
                  const SizedBox(height: 14),
                  ...medicines.take(2).map((m) => _UpcomingDoseTile(
                        name: m.name,
                        time: m.time,
                        interval: m.intervalHours,
                      )),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Upcoming dose tile ────────────────────────────────────────────────────

class _UpcomingDoseTile extends StatelessWidget {
  final String name;
  final String time;
  final int interval;
  const _UpcomingDoseTile(
      {required this.name, required this.time, required this.interval});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(name,
                style: AppTextStyles.subHeading.copyWith(fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(time,
                style: AppTextStyles.tag.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
        ),
      );
}

class _StatChip extends StatelessWidget {
  final String number;
  final String label;
  const _StatChip({required this.number, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(number,
                  style: AppTextStyles.heading
                      .copyWith(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 2),
              Text(label,
                  style: AppTextStyles.label
                      .copyWith(color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
      );
}
