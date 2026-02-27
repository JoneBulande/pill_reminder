import 'package:flutter/material.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool? isObscure;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isObscure = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 7),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite um valor válido';
            }
            return null;
          },
          obscureText: isObscure!,
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.gray400)),
            hintStyle: AppTextStyles.input,
            hintText: hintText ?? '',
            //suffixIcon: isObscure ? Icon(Icons.visibility_outlined, color: AppColors.blueBase) : null,
            // isObscure ?? suffixIcon: Icon(Icons.visibility_outlined, color: AppColors.blueBase),
          ),
        ),
      ],
    );
  }
}
