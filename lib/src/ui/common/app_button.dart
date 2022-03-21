import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final Color? disabledColor;
  final String title;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final double? width;
  final Color? titleColor;
  final void Function()? onTap;

  const AppButton(
      {Key? key,
      this.color,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon,
      this.titleColor,
      required this.title,
      this.width,
      this.height,
      this.disabledColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: onTap == null ? disabledColor : color ?? AppColors.blue,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
              child: Row(
            children: [
              prefixIcon ?? Container(),
              Text(
                title,
                style: TextStyle(color: titleColor ?? AppColors.white),
              ),
              suffixIcon ?? Container()
            ],
          )),
        ));
  }
}
