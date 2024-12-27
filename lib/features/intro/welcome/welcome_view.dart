import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/enums/user_type_enum.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/features/auth/presentation/page/login_screen.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/welcome-bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 100,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اهلا بيك',
                  style: getTitleStyle(fontSize: 38),
                ),
                const Gap(15),
                Text(
                  'سجل واحجز عند دكتورك وانت فالبيت',
                  style: getBodyStyle(context,),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 25,
            right: 25,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'سجل دلوقتي كــ',
                    style: getBodyStyle(context,fontSize: 18, color: AppColors.whiteColor),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      pushTo(context, const LoginScreen(userType: UserType.doctor));
                    },
                    child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: AppColors.accentColor.withOpacity(.7),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'دكتور',
                            style: getTitleStyle(color: AppColors.darkColor),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      pushTo(context, const LoginScreen(userType: UserType.patient));
                    },
                    child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: AppColors.accentColor.withOpacity(.7),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'مريض',
                            style: getTitleStyle(color: AppColors.darkColor),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}