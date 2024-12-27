import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:se7ety/features/auth/presentation/bloc/auth_event.dart';
import 'package:se7ety/features/auth/presentation/page/signup_screen.dart';
import 'package:se7ety/features/doctor_home.dart';

import '../../../../core/enums/user_type_enum.dart';
import '../../../../core/functions/dialogs.dart';
import '../../../../core/functions/validation.dart';
import '../../../../core/utils/text_style.dart';
import '../../../doctor/nav_bar.dart';
import '../../../patient/nav_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.userType});

  final UserType userType;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String handleUserType() {
    return (widget.userType == UserType.doctor) ? 'دكتور' : 'مريض';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is LoginSuccessState){
            log("----------------------------Login success------------------------");
            if(state.userType==UserType.doctor.toString()&& widget.userType == UserType.doctor){
              pushAndRemoveUntil(context,const DoctorNavBarWidget());
            }else if (state.userType == UserType.patient.toString() && widget.userType == UserType.patient) {
              pushAndRemoveUntil(context, const PatientNavBarWidget());
            }else {
              showAppDialog(context, 'لا تملك الصلاحية للدخول هنا', DialogType.error);
            }
            log('success');
          }else if(state is LoginLoadingState){
            log("----------------------------Login loading------------------------");
            showLoadingDialog(context);
          }else if(state is AuthErrorState){
            log("----------------------------Login Error------------------------");
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 200,
                    ),
                    const Gap(20),
                    Text(
                      'سجل دخول الان كـ "${handleUserType()}"',
                      style: getTitleStyle(),
                    ),
                    const Gap(20),
                    TextFormField(
                      style: getSmallStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        hintText: 'Sayed@example.com',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      textInputAction: TextInputAction.next,
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
                      style: getSmallStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.end,
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
                    /*
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(top: 5, right: 10),
                      child: Text(
                        'نسيت كلمة السر ؟',
                        style: getSmallStyle(),
                      ),
                    ),
                     */
                    const Gap(20),
                    CustomElevatedButton(
                        text: "تسجيل الدخول",
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            context.read<AuthBloc>().add(LoginEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
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
                            'ليس لدي حساب ؟',
                            style: getBodyStyle(context,color:Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          TextButton(
                              onPressed: () {
                                pushWithReplacement(context,
                                    SignupScreen(userType: widget.userType));
                              },
                              child: Text(
                                'سجل الان',
                                style: getBodyStyle(context,
                                    color: AppColors.primaryColor),
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
