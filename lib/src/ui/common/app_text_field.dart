import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyBoardType;
  final Widget? suffixIcon;
  final Widget? icon;
  final Color? fillColor;
  final int maxLines;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final bool obscureText;

  AppTextField(
      {required this.controller,
      this.hintText,
      this.focusNode,
        this.fillColor,
      this.maxLines = 1,
      this.contentPadding,
      this.validator,
      this.obscureText = false,
      this.keyBoardType,
      this.icon,
      this.suffixIcon});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      keyboardType: widget.keyBoardType,
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: widget.contentPadding,
          fillColor: widget.fillColor ?? AppColors.white,
          hintText: widget.hintText,
          filled: true,
          suffixIcon: widget.suffixIcon,
          icon: widget.icon),
    );
  }
}
