import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';

import '../../../../../core/widgets/doctor_card.dart';
import '../../../../auth/data/doctor_model.dart';



class SearchHomeView extends StatefulWidget {
  final String searchKey;
  const SearchHomeView({super.key, required this.searchKey});

  @override
  State<SearchHomeView> createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: Text(
          'ابحث عن دكتورك',
          style: getTitleStyle(color: AppColors.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('doctor')
              .orderBy('name')
              .startAt([widget.searchKey.trim()]).endAt(
              ['${widget.searchKey.trim()}\uf8ff']).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      'لا يوجد دكتور بهذا الاسم',
                      style: getBodyStyle(context,),
                    ),
                  ],
                ),
              ),
            )
                : Scrollbar(
              child: ListView.builder(
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
      ),
    );
  }
}