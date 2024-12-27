import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/services/local/app_local_storage.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:se7ety/features/intro/onbording/model/onboarding_model.dart';
import 'package:se7ety/features/intro/welcome/welcome_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        actions: [
          if (pageIndex != onBoardingPages.length - 1)
            TextButton(
              onPressed: () {
                navigateToWelcome(context);
              },
              child: Text(
                "تخطي",
                style: getBodyStyle(context,color: AppColors.primaryColor),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  controller: pageController,
                  itemCount: onBoardingPages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const Spacer(
                          flex: 2,
                        ),
                        SvgPicture.asset(
                          onBoardingPages[index].image,
                          height: 320,
                        ),
                        const Spacer(),
                        Text(
                          onBoardingPages[index].title,
                          style: getTitleStyle(color: AppColors.primaryColor),
                        ),
                        const Gap(20),
                        Text(
                          onBoardingPages[index].description,
                          textAlign: TextAlign.center,
                          style: getBodyStyle(context,),
                        ),
                        const Spacer(
                          flex: 4,
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      spacing: 5,
                      dotColor: Colors.grey,
                      activeDotColor: AppColors.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  if (pageIndex == onBoardingPages.length - 1)
                    CustomElevatedButton(
                        radius: 10,
                        width: 100,
                        height: 45,
                        text: 'هيا بنا',
                        onPressed: () {
                          navigateToWelcome(context);
                        })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToWelcome(BuildContext context) {
    AppLocalStorage.cacheData(key: AppLocalStorage.kOnBoarding, value: true);
    pushWithReplacement(context, const WelcomeView());
  }
}
