import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

void showAppBottomSheet(
    {required String title, required context, required Widget child}) {
  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: _buildRoundedRectangleBorder(),
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            DeliveryLocation(
              title: title,
              child: child,
            )
          ],
        );
      });
}

RoundedRectangleBorder _buildRoundedRectangleBorder() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  );
}

class DeliveryLocation extends StatelessWidget {
  const DeliveryLocation({Key? key, required this.child, required this.title})
      : super(key: key);
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 17),
          _buildDivider(context),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Padding _buildDivider(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(width: 50, height: 3, color: AppColors.grey));
  }

  Padding _buildTitle() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20), child: Text(title));
  }
}
