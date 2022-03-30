import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyBoardType;
  final Widget? suffixIcon;
  final Widget? icon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool obscureText;

  AppTextField(
      {required this.controller,
      this.hintText,
      this.focusNode,
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
      obscureText: widget.obscureText,
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Color(0xfffafafa),
          hintText: widget.hintText,
          filled: true,
          suffixIcon: widget.suffixIcon,
          icon: widget.icon),
    );
  }
}
