import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';

class CustomFormField extends StatelessWidget {
  final String? hint;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final Color? fillColor;
  final Color? inputColor;
  final void Function()? onTap;
  final bool readOnly;
  final bool isRequired;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? length;
  final int? minLines;
  final int? maxLines;
  final double? inputSize;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableBorder;
  final bool enableShadow;

  const CustomFormField({
    super.key,
    this.hint,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.onTap,
    this.obscureText = false,
    this.fillColor,
    this.inputColor,
    this.controller,
    this.readOnly = false,
    this.isRequired = true,
    this.keyboardType,
    this.length,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputSize,
    this.contentPadding,
    this.enableBorder = true,
    this.enableShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultFill = fillColor ?? Colors.white;
    final defaultTextColor = inputColor ?? AppColors.textMuted;

    return Container(
      decoration: enableShadow
          ? BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: CustomAppTheme.primaryBlue.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      )
          : null,
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        minLines: minLines,
        maxLines: maxLines,
        maxLength: length,
        keyboardType: keyboardType,
        onTap: onTap,
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          color: defaultTextColor,
          fontSize: inputSize ?? 18,
        ),
        decoration: InputDecoration(
          counterText: "",
          labelText: labelText,
          prefixIcon: prefixIcon,
          fillColor: defaultFill,
          filled: true,
          hintText: hint,
          isDense: true,
          hintStyle: AppTextStyles.bodyMuted,
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: enableBorder
                ? const BorderSide(color: AppColors.primary)
                : BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: enableBorder
                ? const BorderSide(color: AppColors.primary)
                : BorderSide.none,
          ),
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}