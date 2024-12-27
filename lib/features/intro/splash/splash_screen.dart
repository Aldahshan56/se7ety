import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/enums/user_type_enum.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/services/local/app_local_storage.dart';
import 'package:se7ety/features/doctor_home.dart';
import 'package:se7ety/features/intro/onbording/page/onboarding_screen.dart';
import 'package:se7ety/features/intro/welcome/welcome_view.dart';

import '../../doctor/nav_bar.dart';
import '../../patient/nav_bar.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;
  getUser()async{
    user=FirebaseAuth.instance.currentUser;
  }
  @override
  void initState() {
    super.initState();
    getUser();
    Future.delayed(const Duration(seconds: 3),(){
      bool isOnBoardingShown=AppLocalStorage.getData(key: AppLocalStorage.kOnBoarding)==true;
      if(user!=null){
        if(user?.photoURL==UserType.doctor.toString()){
          pushAndRemoveUntil(context,const DoctorNavBarWidget());
        }else{
          pushAndRemoveUntil(context,const PatientNavBarWidget());
        }
      }else{
        if(isOnBoardingShown){
          pushWithReplacement(context,const WelcomeView());
        }else{
          pushWithReplacement(context,const OnBoardingScreen());
        }
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            AppImages.logoPng,
          width: 250,
        ),
      ),
    );
  }
}
