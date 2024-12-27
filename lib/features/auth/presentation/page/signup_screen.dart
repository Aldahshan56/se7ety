import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/functions/dialogs.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:se7ety/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:se7ety/features/auth/presentation/bloc/auth_event.dart';
import 'package:se7ety/features/auth/presentation/bloc/auth_state.dart';
import 'package:se7ety/features/auth/presentation/page/login_screen.dart';

import '../../../../core/enums/user_type_enum.dart';
import '../../../../core/functions/validation.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../patient/nav_bar.dart';
import 'doctor_registration_screen.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.userType});
  final UserType userType;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisible = true;
  String handleUserType() {
    return widget.userType == UserType.doctor ? 'دكتور' : 'مريض';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Theme.of(context).colorScheme.onSecondary,
        leading: IconButton(
            onPressed:(){
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state is RegisterSuccessState){
      log("----------------------------register success------------------------");
      if(widget.userType==UserType.doctor){
        pushAndRemoveUntil(context,const DoctorRegistrationScreen());
      }else{
        pushAndRemoveUntil(context,const PatientNavBarWidget());
      }
    }else if(state is RegisterLoadingState){
      log("----------------------------register loading------------------------");
      showLoadingDialog(context);
    }else if(state is AuthErrorState){
      log("----------------------------register Error------------------------");
      Navigator.pop(context);
      showAppDialog(context, state.message,DialogType.error);
    }
  },
  child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      AppImages.logoPng,
                    height: 200,
                  ),
                  const Gap(20),
                  Text(
                    'سجل حساب جديد كـ "${handleUserType()}"',
                    style: getTitleStyle(),
                  ),
                  const Gap(30),
                  TextFormField(
                    style: TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.name,
                    controller: _displayName,
                    decoration: InputDecoration(
                      hintText: 'الاسم',
                      hintStyle: getBodyStyle(context,color: Colors.grey),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'من فضلك ادخل الاسم';
                      return null;
                    },
                  ),
                  const Gap(25),
                  TextFormField(
                    style: TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                      hintText: 'Sayed@example.com',
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'من فضلك ادخل الايميل';
                      } else if (!emailValidation(value)) {
                        return 'من فضلك ادخل الايميل صحيحا';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const Gap(25),
                  TextFormField(
                    textAlign: TextAlign.end,
                    style: TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
                    obscureText: isVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: '********',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon((isVisible)
                              ? Icons.remove_red_eye
                              : Icons.visibility_off_rounded)),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) return 'من فضلك ادخل كلمة السر';
                      return null;
                    },
                  ),
                  const Gap(30),
                  CustomElevatedButton(
                      text: "تسجيل حساب",
                      onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                          context.read<AuthBloc>().add(RegisterEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _displayName.text,
                              userType: widget.userType,
                          ));
                        }
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لدي حساب ؟',
                          style: getBodyStyle(context,color:Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        TextButton(
                            onPressed: () {
                              pushWithReplacement(context,
                                  LoginScreen(userType: widget.userType));
                            },
                            child: Text(
                              'سجل دخول',
                              style: getBodyStyle(context,color: AppColors.primaryColor),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
),
    );
  }
}
