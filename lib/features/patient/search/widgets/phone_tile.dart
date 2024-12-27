import 'package:flutter/material.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';

class IconTile extends StatelessWidget {
  final IconData imgAssetPath;
  final Color backColor;
  final void Function()? onTap;
  final String num;
  const IconTile(
      {super.key,
        required this.imgAssetPath,
        required this.backColor,
        this.onTap,
        required this.num});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(num,style: getSmallStyle(color: AppColors.darkColor),),
            Icon(
              imgAssetPath,
              color: AppColors.darkColor,
            ),
          ],
        ),
      ),
    );
  }
}