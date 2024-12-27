import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/features/doctor/profile/page/user_details.dart';
import 'package:se7ety/features/patient/profile/page/user_details.dart';

import '../../../../core/services/local/app_local_storage.dart';
import '../../../../core/widgets/settings_tile.dart';
import '../../../intro/welcome/welcome_view.dart';

class DoctorSettings extends StatefulWidget {
  const DoctorSettings({super.key});

  @override
  _DoctorSettingsState createState() => _DoctorSettingsState();
}

class _DoctorSettingsState extends State<DoctorSettings> {
  late bool isDarkMode;

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  void initState() {
    super.initState();
    isDarkMode = AppLocalStorage.getData(key: AppLocalStorage.isDarkModeKey) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            splashRadius: 25,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'الاعدادات',
        ),
        titleTextStyle: getTitleStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async {
              setState(() {
                isDarkMode = !isDarkMode;
              });
              await AppLocalStorage.setDarkMode(isDarkMode);
              AppLocalStorage.isDarkModeNotifier.value = isDarkMode;
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode?Colors.white:Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SettingsListItem(
              icon: Icons.person,
              text: 'إعدادات الحساب',
              onTap: () {
                pushTo(context, const DoctorDetails());
              },
            ),
            SettingsListItem(
              icon: Icons.security_rounded,
              text: 'كلمة السر',
              onTap: () {},
            ),
            SettingsListItem(
              icon: Icons.notifications_active_rounded,
              text: 'إعدادات الاشعارات',
              onTap: () {},
            ),
            SettingsListItem(
              icon: Icons.privacy_tip_rounded,
              text: 'الخصوصية',
              onTap: () {},
            ),
            SettingsListItem(
              icon: Icons.question_mark_rounded,
              text: 'المساعدة والدعم',
              onTap: () {},
            ),
            SettingsListItem(
              icon: Icons.person_add_alt_1_rounded,
              text: 'دعوة صديق',
              onTap: () {},
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.redColor,
              ),
              child: TextButton(
                onPressed: () {
                  _signOut();
                  pushAndRemoveUntil(context, const WelcomeView());
                },
                child: Text(
                  'تسجل خروج',
                  style: getTitleStyle(color: AppColors.whiteColor, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}