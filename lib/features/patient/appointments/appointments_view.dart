import 'package:flutter/material.dart';
import 'package:se7ety/core/utils/colors.dart';

import '../../../core/utils/text_style.dart';
import 'appointments_list.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'مواعيد الحجز',
        ),
        titleTextStyle:getTitleStyle(color: AppColors.whiteColor),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: MyAppointmentList(),
      ),
    );
  }
}