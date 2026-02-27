import 'package:flutter/material.dart';
import 'package:pill_reminder/core/app_colors.dart';
import 'package:pill_reminder/core/app_text_style.dart';

class MedicationCard extends StatelessWidget {
  //
  final String time;
  final String repeat;
  final String medicationName;
  //
  const MedicationCard({
    super.key,
    required this.time,
    required this.medicationName,
    required this.repeat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.gray700,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(medicationName, style: AppTextStyles.subHeading),
                    const Icon(Icons.delete,
                        color: AppColors.redLight, size: 17),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                        AppColors.gray600,
                      )),
                      onPressed: () {},
                      label: Text(time, style: AppTextStyles.tag),
                      icon: const Icon(Icons.access_time,
                          size: 18, color: AppColors.gray400),
                    ),
                    const SizedBox(width: 7),
                    TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                        AppColors.gray600,
                      )),
                      onPressed: () {},
                      label: Text('A cada $repeat', style: AppTextStyles.tag),
                      icon: const Icon(Icons.repeat_rounded,
                          size: 18, color: AppColors.gray400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
