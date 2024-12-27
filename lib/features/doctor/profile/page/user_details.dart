import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key});

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List labelName = ["الاسم","الايميل", "الموقع","رقم الهاتف 1","رقم الهاتف 2", "التخصص", "نبذه تعريفية",];

  List value = ["name","email","address","phone1", "phone2","specialization", "bio",];

  @override
  void initState() {
    super.initState();
    _getUser();
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
        centerTitle: true,
        title: const Text('اعدادات الحساب'),
        titleTextStyle: getTitleStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var userData = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: labelName.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var con = TextEditingController(
                          text: userData?[value[index]] == '' ||
                              userData?[value[index]] == null
                              ? 'لم تضاف'
                              : userData?[value[index]]);
                      var form = GlobalKey<FormState>();
                      return SimpleDialog(
                        alignment: Alignment.center,
                        contentPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        children: [
                          Form(
                            key: form,
                            child: Column(
                              children: [
                                Text(
                                  'ادخل ${labelName[index]}',
                                  style:
                                  getBodyStyle(context,fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: getSmallStyle(color: AppColors.darkColor),
                                  controller: con,
                                  decoration: const InputDecoration(
                                      filled: true, fillColor: AppColors.whiteColor),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'من فضلك ادخل ${labelName[index]}.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomElevatedButton(
                                  text: 'حفظ التعديل',
                                  onPressed: () {
                                    if (form.currentState!.validate()) {
                                      updateData(value[index], con.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labelName[index],
                        style: getBodyStyle(context,
                            fontSize: 14, fontWeight: FontWeight.w600,color: AppColors.darkColor),
                      ),
                      Text(
                        userData?[value[index]] == '' ||
                            userData?[value[index]] == null
                            ? 'Not Added'
                            : userData?[value[index]],
                        style: getBodyStyle(context,color: AppColors.darkColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateData(String key, value) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Update doctor's data in the doctor's collection
    await firestore.collection('doctor').doc(user!.uid).update({
      key: value,
    });

    // Update display name in Firebase Authentication
    if (key == "name") {
      await user?.updateDisplayName(value);
      await user?.reload();
      user = _auth.currentUser;

      // Update doctor's name in the appointments collection
      await updateAppointments(firestore, 'pending', value);
      await updateAppointments(firestore, 'all', value);
    }

    // Close the edit dialog after finishing
    Navigator.pop(context);
  }

  Future<void> updateAppointments(FirebaseFirestore firestore, String collection, String value) async {
    QuerySnapshot appointmentsSnapshot = await firestore
        .collection('appointments')
        .doc('appointments')
        .collection(collection)
        .where('doctorID', isEqualTo: user!.uid)
        .get();

    for (var doc in appointmentsSnapshot.docs) {
      await firestore
          .collection('appointments')
          .doc('appointments')
          .collection(collection)
          .doc(doc.id)
          .update({
        'doctor': value,
      });
    }
  }
}

/*
  Future<void> updateData(String key, value) async {
    FirebaseFirestore.instance.collection('doctor').doc(user!.uid).update({
      key: value,
    });
    if (key == "name") {
      await user?.updateDisplayName(value);
      await user?.reload();
      user=_auth.currentUser;
    }
    Navigator.pop(context);
  }*/