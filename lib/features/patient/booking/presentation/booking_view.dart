import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/alert_dialog.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';
import '../../../auth/data/doctor_model.dart';
import '../../nav_bar.dart';
import '../data/available_appointments.dart';

class BookingView extends StatefulWidget {
  final DoctorModel doctor;

  const BookingView({
    super.key,
    required this.doctor,
  });

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  TimeOfDay currentTime = TimeOfDay.now();
  String? booking_hour;

  int selectedIndex = -1;

  User? user;

  Future<void> _getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  List<int> times = [];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.whiteColor,
            )),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'احجز مع دكتورك',
          style: getTitleStyle(color: AppColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              DoctorCard(
                doctor: widget.doctor,
                isClickable: false,
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('-- ادخل بيانات الحجز --', style: getTitleStyle()),
                    const SizedBox(height: 15),
                    _buildTextField('اسم المريض', _nameController),
                    const SizedBox(height: 7),
                    _buildTextField('رقم الهاتف', _phoneController, isPhone: true),
                    const SizedBox(height: 7),
                    _buildTextField('وصف الحاله', _descriptionController, maxLines: 5),
                    const SizedBox(height: 7),
                    _buildDateField(),
                    const SizedBox(height: 7),
                    _buildTimeField(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomElevatedButton(
          text: 'تأكيد الحجز',
          onPressed: () {
            if (_formKey.currentState!.validate() && selectedIndex != -1) {
              _createAppointment();
              showAlertDialog(
                context,
                title: 'تم تسجيل الحجز !',
                ok: 'اضغط للانتقال',
                onTap: () {
                  pushAndRemoveUntil(context, const PatientNavBarWidget());
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPhone = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: getBodyStyle(context,color:Theme.of(context).colorScheme.onSurfaceVariant)),
        TextFormField(
          controller: controller,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          style: getBodyStyle(context,),
          maxLines: maxLines,
          validator: (value) {
            if (value!.isEmpty) {
              return 'من فضلك ادخل $label';
            }
            if (isPhone && value.length < 10) {
              return 'يرجي ادخال رقم هاتف صحيح';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تاريخ الحجز', style: getBodyStyle(context,color:Theme.of(context).colorScheme.onSurfaceVariant)),
        TextFormField(
          readOnly: true,
          onTap: () {
            selectDate(context);
          },
          controller: _dateController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'من فضلك ادخل تاريخ الحجز';
            }
            return null;
          },
          style: getBodyStyle(context,),
          decoration: const InputDecoration(
            hintText: 'ادخل تاريخ الحجز',
            suffixIcon: Padding(
              padding: EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 18,
                child: Icon(
                  Icons.date_range_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('وقت الحجز', style: getBodyStyle(context, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0, // المسافة الأفقية بين العناصر
            runSpacing: 8.0, // المسافة الرأسية بين العناصر
            children: times.map((hour) {
              return ChoiceChip(
                backgroundColor: AppColors.accentColor,
                selectedColor: AppColors.primaryColor,
                label: Text(
                  '${(hour < 10) ? '0' : ''}${hour.toString()}:00',
                  style: TextStyle(
                    color: hour == selectedIndex
                        ? AppColors.whiteColor
                        : AppColors.darkColor,
                  ),
                ),
                selected: hour == selectedIndex,
                onSelected: (selected) {
                  setState(() {
                    selectedIndex = hour;
                    booking_hour = '${(hour < 10) ? '0' : ''}${hour.toString()}:00'; // hh:mm
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Future<void> _createAppointment() async {
     FirebaseFirestore.instance.collection('appointments').doc('appointments').collection('pending').doc().set({
      'patientID': user!.uid,
      'doctorID': widget.doctor.uid,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse('${_dateController.text} ${booking_hour!}:00'),
      'isComplete': false,
      'rating': null
    },
        SetOptions(merge: true)
    );

     FirebaseFirestore.instance.collection('appointments').doc('appointments').collection('all').doc().set({
      'patientID': user!.uid,
      'doctorID': widget.doctor.uid,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctor': widget.doctor.name,
      'location': widget.doctor.address,
      'date': DateTime.parse('${_dateController.text} ${booking_hour!}:00'),
      'isComplete': false,
      'rating': null
    },
      SetOptions(merge: true)
    );
  }
  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then(
          (date) {
        if (date != null) {
          setState(() {
            _dateController.text = DateFormat('yyyy-MM-dd').format(date);
            times = getAvailableAppointments(
              date,
              widget.doctor.openHour ?? "0",
              widget.doctor.closeHour ?? "0",
            );
          });
        }
      },
    );
  }


/*Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then(
          (date) {
        if (date != null) {
          setState(() {
            _dateController.text = DateFormat('yyyy-MM-dd').format(date); // to send the date to firebase
            times = getAvailableAppointments(
              date,
              widget.doctor.openHour ?? "0",
              widget.doctor.closeHour ?? "0",
            );
          });
        }
      },
    );
  }*/
}
