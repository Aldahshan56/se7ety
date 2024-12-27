import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:se7ety/features/doctor/profile/page/settings_view.dart';
import 'package:se7ety/features/doctor/profile/page/user_details.dart';
import 'package:se7ety/features/patient/profile/page/settings_view.dart';

import '../../../../core/services/local/app_local_storage.dart';
import '../../../patient/search/widgets/item_tile.dart';
import '../../appointments/appointments_list.dart';
import '../widgets/appointments_list.dart';

class DoctorProfileM extends StatefulWidget {
  const DoctorProfileM({super.key});

  @override
  _DoctorProfileMState createState() => _DoctorProfileMState();
}

class _DoctorProfileMState extends State<DoctorProfileM> {
  String? _imagePath;
  File? file;
  String? profileUrl;
  String? userId;
  Future<void> _getUser() async {
    setState(() {
      userId = FirebaseAuth.instance.currentUser?.uid;
    });
  }

  uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
    FirebaseStorage.instanceFor(bucket: 'gs://se7ety-119.appspot.com')
        .ref()
        .child('doctors/${FirebaseAuth.instance.currentUser!.uid}');

    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    log("URL+++++++++++++++++++++++> $url");
    return url;
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!, 'doc');
    FirebaseFirestore.instance.collection('doctor').doc(userId).update({
      'image': profileUrl,
    });
  }

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
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الحساب الشخصي',
          style: getTitleStyle(color: AppColors.whiteColor),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.settings,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              pushTo(context, const DoctorSettings());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('حدث خطأ: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('لا توجد بيانات'),
              );
            }

            var userData = snapshot.data;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.whiteColor,
                              child: CircleAvatar(
                                backgroundColor: AppColors.whiteColor,
                                radius: 60,
                                backgroundImage: (userData?['image'] != '')
                                    ? NetworkImage(userData?['image'])
                                    : (_imagePath != null)
                                    ? FileImage(File(_imagePath!))
                                as ImageProvider
                                    : const AssetImage(
                                    AppImages.doctorPng),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: const CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                AppColors.whiteColor,
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userData!['name']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTitleStyle(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              (userData['specialization'] == '')
                                  ? CustomElevatedButton(
                                text: 'تعديل الحساب',
                                height: 40,
                                onPressed: () {
                                  pushTo(context, const DoctorDetails());
                                },
                              )
                                  : Text(
                                userData['specialization'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getBodyStyle(context,),
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Text(
                                    userData['rating'].toString(),
                                    style: getBodyStyle(context,),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 20,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "نبذه تعريفيه",
                      style: getBodyStyle(context,fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['bio'] == '' ? 'لم تضاف' : userData['bio'],
                      style: getSmallStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "معلومات التواصل",
                      style: getBodyStyle(context,fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.accentColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TileWidget(
                              text: userData['email'] ?? 'لم تضاف',
                              icon: Icons.email),
                          const SizedBox(
                            height: 15,
                          ),
                          TileWidget(
                              text: userData['phone1'] == ''
                                  ? 'لم تضاف'
                                  : userData['phone1'],
                              icon: Icons.call),
                          const SizedBox(
                            height: 15,
                          ),
                          TileWidget(
                              text: userData['phone2'] == ''
                                  ? 'لم تضاف'
                                  : userData['phone2'],
                              icon: Icons.call),
                          const SizedBox(
                            height: 15,
                          ),
                          TileWidget(
                              text: userData['address'] ==''
                                  ? 'لم تضاف'
                                  : userData['address']
                              ,
                              icon: Icons.location_on_rounded),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "حجوزاتي",
                      style: getBodyStyle(context,fontWeight: FontWeight.w600),
                    ),
                    const DoctorAppointmentsHistory(),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
