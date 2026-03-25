import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class MedicationCard extends StatelessWidget {
  final String time;
  final String repeat;
  final String medicationName;
  final String? patientName;
  final double? progress; // 0.0 to 1.0
  final Function() onTap;
  final Function() onDetailTap;

  const MedicationCard({
    super.key,
    required this.time,
    required this.onTap,
    required this.onDetailTap,
    required this.repeat,
    required this.medicationName,
    this.patientName,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDetailTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Name + patient
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicationName,
                            style: AppTextStyles.subHeading
                                .copyWith(fontSize: 16, letterSpacing: -0.3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (patientName != null) ...[
                            const SizedBox(height: 2),
                            Text(patientName!,
                                style:
                                    AppTextStyles.body.copyWith(fontSize: 12)),
                          ],
                        ],
                      ),
                    ),
                    // Status + delete
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text('Ativo',
                              style: AppTextStyles.tag.copyWith(
                                  color: AppColors.success, fontSize: 10)),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.delete_outline_rounded,
                                color: AppColors.accent, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Badges
                Row(
                  children: [
                    _Badge(
                      icon: Icons.access_time_filled_rounded,
                      label: time,
                      color: AppColors.primaryMid,
                      bg: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      icon: Icons.repeat_rounded,
                      label: 'A cada $repeat',
                      color: AppColors.success,
                      bg: AppColors.successLight,
                    ),
                  ],
                ),

                // Progress bar
                if (progress != null) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.gray800,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primaryMid),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  const _Badge(
      {required this.icon,
      required this.label,
      required this.color,
      required this.bg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: AppTextStyles.tag.copyWith(color: color, fontSize: 11)),
          ],
        ),
      );
}
