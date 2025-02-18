import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';

import '../widgets/search_list.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title:  Text(
          'ابحث عن دكتور',style:getTitleStyle(color: AppColors.whiteColor) ,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  )
                ],
              ),
              child: TextField(
                onChanged: (searchKey) {
                  setState(
                        () {
                      search = searchKey;
                    },
                  );
                },
                style: getBodyStyle(context,color:AppColors.darkColor),
                decoration: InputDecoration(
                  fillColor: AppColors.whiteColor,
                  filled: true,
                  hintText: "البحث",
                  hintStyle: getBodyStyle(context,color: AppColors.darkColor),
                  suffixIcon: const SizedBox(
                      width: 50,
                      child: Icon(Icons.search, color: AppColors.darkColor)),
                ),
              ),
            ),
            const Gap(15),
            Expanded(
              child: SearchList(
                searchKey: search,
              ),
            ),
          ],
        ),
      ),
    );
  }
}