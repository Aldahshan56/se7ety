import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List labelName = ["الاسم", "رقم الهاتف", "المدينة", "نبذه تعريفية", "العمر"];

  List value = ["name", "phone", "city", "bio", "age"];

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
              .collection('patients')
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
                                  // decoration: InputDecoration(
                                  //     hintText: value[index]),
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
    FirebaseFirestore.instance.collection('patients').doc(user!.uid).update({
      key: value,
    });
    if (key == "name") {
      await user?.updateDisplayName(value);
    }
    Navigator.pop(context);
  }
}