import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/features/doctor/profile/page/profile_viwe.dart';

import 'appointments/appointments_view.dart';

class DoctorNavBarWidget extends StatefulWidget {
  const DoctorNavBarWidget({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<DoctorNavBarWidget> {
  int _selectedIndex = 0;
  final List _pages = [
    const DoctorAppointments(),
    const DoctorProfileM(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.2),
            ),
          ],
        ),
        child: GNav(
          curve: Curves.easeOutExpo,
          rippleColor: Theme.of(context).colorScheme.onSurfaceVariant,
          hoverColor: Theme.of(context).colorScheme.onSurfaceVariant,
          haptic: true,
          tabBorderRadius: 20,
          gap: 5,
          activeColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.primaryColor,
          textStyle: getBodyStyle(context,color: AppColors.whiteColor),
          tabs:  [
            GButton(
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconSize: 28,
              icon: Icons.calendar_month_rounded,
              text: 'المواعيد',
            ),
            GButton(
              iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              iconSize: 29,
              icon: Icons.person,
              text: 'الحساب',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}