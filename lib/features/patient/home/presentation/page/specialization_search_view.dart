import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/utils/text_style.dart';


import '../../../../../core/widgets/doctor_card.dart';
import '../../../../auth/data/doctor_model.dart';

class SpecializationSearchView extends StatefulWidget {
  final String specialization;
  const SpecializationSearchView({super.key, required this.specialization});

  @override
  _SpecializationSearchViewState createState() =>
      _SpecializationSearchViewState();
}

class _SpecializationSearchViewState extends State<SpecializationSearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.specialization,
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('doctor')
            .where('specialization', isEqualTo: widget.specialization)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.noSearchSvg,
                    width: 250,
                  ),
                  Text(
                    'لا يوجد دكتور بهذا التخصص حاليا',
                    style: getBodyStyle(context,),
                  ),
                ],
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DoctorModel doctor = DoctorModel.fromJson(
                  snapshot.data!.docs[index].data()
                  as Map<String, dynamic>,
                );
                if (doctor.specialization == '') {
                  return const SizedBox();
                }
                return DoctorCard(
                  doctor: doctor,
                );
              },
            ),
          );
        },
      ),
    );
  }
}