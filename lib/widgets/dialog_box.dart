import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class DialogBox extends StatelessWidget {
  final String dialogTitle;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.dialogTitle,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  color: AppColors.accent, size: 32),
            ),

            const SizedBox(height: 20),

            Text(
              'Confirmar ação',
              style: AppTextStyles.subHeading.copyWith(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(
              dialogTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body
                  .copyWith(fontSize: 14, color: AppColors.gray500),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gray400,
                      side: BorderSide(
                          color: AppColors.gray700.withOpacity(0.7), width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Cancelar',
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Confirmar',
                        style: AppTextStyles.subHeadingBTN1
                            .copyWith(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
