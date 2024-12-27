import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/colors.dart';
import '../utils/text_style.dart';

enum DialogType { success, error }

showAppDialog(BuildContext context, String text,
    [DialogType? type = DialogType.error]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: type == DialogType.success
          ? AppColors.primaryColor
          : Colors.redAccent.withOpacity(0.8),
      content: Text(
        text,
        style: getBodyStyle( context,color: AppColors.whiteColor),
      )));
}

showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Lottie.asset("assets/images/loading.json",width: 200)],
        );
      });
}
/*
showRightDialog(BuildContext context,String text){
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
      backgroundColor: AppColors.greenColor,
      content:Text(text,style: getBodyTextStyle(color: AppColors.whiteColor),)
  ));
}
 */
