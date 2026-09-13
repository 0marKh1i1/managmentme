import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labletText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool isEnabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labletText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal:  isEnabled ? 0 : 8 , vertical: isEnabled ? 0 : 4 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labletText != null) ...{
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Text(labletText!, style: TextStyle(fontSize: 14)),
            ),
          },
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            enabled: isEnabled,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    )
                  : null,
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.error, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.error, width: 2),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
