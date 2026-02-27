import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class MedicationCard extends StatelessWidget {
  //
  final String time;
  final String repeat;
  final String medicationName;
  final Function() onTap;
  //
  const MedicationCard({
    super.key,
    required this.time,
    required this.onTap,
    required this.repeat,
    required this.medicationName,
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
                    IconButton(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.redLight,
                        size: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: Text(time, style: AppTextStyles.tag),
                      backgroundColor: AppColors.gray600,
                      shape: const StadiumBorder(
                        side: BorderSide(style: BorderStyle.none),
                      ),
                      avatar: const Icon(Icons.access_time,
                          size: 18, color: AppColors.gray400),
                    ),
                    Chip(
                      label: Text('A cada $repeat', style: AppTextStyles.tag),
                      backgroundColor: AppColors.gray600,
                      shape: const StadiumBorder(
                        side: BorderSide(style: BorderStyle.none),
                      ),
                      avatar: const Icon(Icons.repeat_rounded,
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
