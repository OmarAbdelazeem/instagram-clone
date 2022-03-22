import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final Color? disabledColor;
  final String title;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final TextStyle? titleStyle;
  final double? width;
  final void Function()? onTap;

  const AppButton(
      {Key? key,
      this.color,
      this.onTap,
      this.titleStyle,
      this.prefixIcon,
      this.suffixIcon,
      required this.title,
      this.width,
      this.height,
      this.disabledColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = TextStyle(
      color: AppColors.white,
    );
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: onTap == null
                  ? disabledColor ?? AppColors.disabledBlue
                  : color ?? AppColors.blue,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixIcon ?? Container(),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: titleStyle ?? defaultTitleStyle,
              ),
              SizedBox(
                width: 5,
              ),
              suffixIcon ?? Container()
            ],
          )),
        ));
  }
}
