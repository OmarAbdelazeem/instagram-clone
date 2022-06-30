import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyBoardType;
  final Widget? suffixIcon;
  final Widget? icon;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final int maxLines;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? labelText;

  AppTextField(
      {this.controller,
      this.hintText,
      this.focusNode,
        this.hintStyle,
      this.fillColor,
      this.maxLines = 1,
      this.contentPadding,
      this.validator,
      this.obscureText = false,
      this.keyBoardType,
      this.icon,
        this.labelText,
      this.suffixIcon});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.fillColor ?? AppColors.grey.shade200,
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        keyboardType: widget.keyBoardType,
        controller: widget.controller,
        validator: widget.validator,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
            border: InputBorder.none,
            contentPadding: widget.contentPadding,
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            suffixIcon: widget.suffixIcon,
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10,),
                widget.icon ?? Container()
              ],
            )),
      ),
    );
  }
}
