import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';


import '../../../auth/data/doctor_model.dart';

class SearchList extends StatefulWidget {
  final String searchKey;
  const SearchList({super.key, required this.searchKey});

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('doctor')
          .orderBy('name')
          .orderBy('rating',descending: true)
          .startAt([widget.searchKey]).endAt(
          ['${widget.searchKey}\uf8ff']).snapshots(),
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
                snapshot.data!.docs[index].data() as Map<String, dynamic>,
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
    );
  }
}