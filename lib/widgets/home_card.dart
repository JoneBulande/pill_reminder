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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.gray700,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 77,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.gray600,
                  border: Border.all(style: BorderStyle.none),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(cardImgUrl),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cardTitle, style: AppTextStyles.subHeading),
                    const SizedBox(height: 7),
                    Text(
                      cardSubtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
