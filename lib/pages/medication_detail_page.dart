import 'package:flutter/material.dart';
import 'package:pill_reminder/core/model/medicine.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class MedicationDetailPage extends StatelessWidget {
  final Medicine medicine;

  const MedicationDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryLight,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.primary),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryLight, Colors.white],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'medication_img_${medicine.id}',
                    child: Image.asset(
                      'assets/images/Pills.png',
                      height: 180,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'RECEITA MÉDICA',
                      style: AppTextStyles.tag.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(medicine.name, style: AppTextStyles.heading.copyWith(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text('Paciente: ${medicine.userName}', style: AppTextStyles.body.copyWith(fontSize: 16)),
                  const SizedBox(height: 48),
                  
                  _buildDetailRow(
                    icon: Icons.access_time_filled_rounded,
                    label: 'Próxima dose',
                    value: medicine.time,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    icon: Icons.repeat_rounded,
                    label: 'Intervalo',
                    value: 'A cada ${medicine.intervalHours} horas',
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    icon: Icons.info_outline_rounded,
                    label: 'Status',
                    value: 'Ativo',
                    color: AppColors.warning,
                  ),
                  
                  const SizedBox(height: 64),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirmar Visualização',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label.copyWith(fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.subHeading.copyWith(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}
