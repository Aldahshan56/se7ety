import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';

import '../../../../../core/functions/navigation.dart';
import '../../../../../core/services/local/app_local_storage.dart';
import '../widgets/specialists_widget.dart';
import '../widgets/top_rated_widget.dart';
import 'home_search_view.dart';


class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PatientHomeView> {
  final TextEditingController _doctorName = TextEditingController();
  User? user;
  late bool isDarkMode;
  Future<void> _getUser() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    log("+++++++++++++++++++++++ ${user?.displayName}");
  }


  @override
  void initState() {
    super.initState();
    _getUser();
    isDarkMode = AppLocalStorage.getData(key: AppLocalStorage.isDarkModeKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
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
          ),
        ],
        backgroundColor:Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: Text(
          'صــــــحّـتــي',
          style: getTitleStyle(color:Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: 'مرحبا، ',
                    style: getBodyStyle(context,fontSize: 18),
                  ),
                  TextSpan(
                    text: user?.displayName,
                    style: getTitleStyle(),
                  ),
                ],
              )),
              const Gap(10),
              Text("احجز الآن وكن جزءًا من رحلتك الصحية.",
                  style: getTitleStyle(color:Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 25)),
              const SizedBox(height: 15),

              // --------------- Search Bar --------------------------
              Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    )
                  ],
                ),
                child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: _doctorName,
                  cursorColor: AppColors.primaryColor,
                  decoration: InputDecoration(
                    hintStyle: getBodyStyle(context,color: AppColors.darkColor),
                    filled: true,
                    hintText: 'ابحث عن دكتور',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: IconButton(
                          iconSize: 20,
                          splashRadius: 20,
                          color: Colors.white,
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            if (_doctorName.text.isNotEmpty) {
                              pushTo(context,
                                  SearchHomeView(searchKey: _doctorName.text));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  style: getBodyStyle(context,color:AppColors.darkColor),
                  onFieldSubmitted: (String value) {
                    if (_doctorName.text.isNotEmpty) {
                      pushTo(
                          context, SearchHomeView(searchKey: _doctorName.text));
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // ----------------  SpecialistsWidget --------------------,

              const SpecialistsBanner(),
              const SizedBox(
                height: 10,
              ),

              // ----------------  Top Rated --------------------,
              Text(
                "الأعلي تقييماً",
                textAlign: TextAlign.center,
                style: getTitleStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const TopRatedList(),
            ],
          ),
        ),
      ),
    );
  }
}