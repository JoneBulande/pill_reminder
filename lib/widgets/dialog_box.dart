import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';

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
    return AlertDialog(
      backgroundColor: AppColors.gray700,
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TextField(
            //   maxLines: 4,
            //   controller: controller,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'add a new Task',
            //   ),
            // ),
            Text(
              dialogTitle,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check),
                  label: const Text('Sim', style: TextStyle(color: AppColors.blueBase)),
                ),
                ElevatedButton.icon(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.blueBase,
                    ),
                  ),
                  onPressed: onCancel,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'cancelar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
