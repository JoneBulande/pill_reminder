import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class HomeCard extends StatelessWidget {
  final String cardTitle;
  final String cardImgUrl;
  final String cardSubtitle;
  final Function() onTap;

  const HomeCard({
    super.key,
    required this.onTap,
    required this.cardTitle,
    required this.cardImgUrl,
    required this.cardSubtitle,
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(cardImgUrl, fit: BoxFit.contain),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: AppTextStyles.subHeading.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cardSubtitle,
                        style: AppTextStyles.body.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.gray600, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
