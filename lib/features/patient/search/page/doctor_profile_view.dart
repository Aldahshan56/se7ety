import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_images.dart';
import 'package:se7ety/core/functions/navigation.dart';
import 'package:se7ety/core/utils/colors.dart';
import 'package:se7ety/core/utils/text_style.dart';
import 'package:se7ety/core/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../auth/data/doctor_model.dart';
import '../../booking/presentation/booking_view.dart';
import '../widgets/item_tile.dart';
import '../widgets/phone_tile.dart';

class DoctorProfile extends StatefulWidget {
  final DoctorModel? doctorModel;

  const DoctorProfile({super.key, this.doctorModel});
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  late DoctorModel doctor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title:  Text(
          'بيانات الدكتور',
          style:getTitleStyle(color: Colors.white) ,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 25,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.whiteColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // ------------ Header ---------------
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
                            backgroundImage: (widget.doctorModel?.image != '')
                                ? NetworkImage(widget.doctorModel!.image!)
                                : const AssetImage(AppImages.doctorPng),
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
                            "د. ${widget.doctorModel?.name ?? ''}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: getTitleStyle(),
                          ),
                          Text(
                            widget.doctorModel?.specialization ?? '',
                            style: getBodyStyle(context,),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.doctorModel?.rating.toString() ?? '0.0',
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
                          Row(
                            children: [
                              IconTile(
                                onTap: () async {
                                  await launchUrl(Uri.parse('tel:${widget.doctorModel?.phone1}'));
                                },
                                backColor: AppColors.accentColor,
                                imgAssetPath: Icons.phone,
                                num: '1',
                              ),
                              if (widget.doctorModel?.phone2 != '') ...[
                                const SizedBox(
                                  width: 15,
                                ),
                                IconTile(
                                  onTap: () async {
                                    await launchUrl(Uri.parse('tel:${widget.doctorModel?.phone2}'));
                                  },
                                  backColor: AppColors.accentColor,
                                  imgAssetPath: Icons.phone,
                                  num: '2',
                                ),
                              ]
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "نبذه تعريفية",
                  style: getBodyStyle(context,fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  (widget.doctorModel?.bio ?? '').isEmpty ? 'لم تضاف' : widget.doctorModel!.bio!,

                  style: getSmallStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TileWidget(
                        text: widget.doctorModel?.openHour != '' && widget.doctorModel?.closeHour != ''
                            ? '${widget.doctorModel!.openHour} - ${widget.doctorModel!.closeHour}'
                            : 'لم تضاف',
                        icon: Icons.watch_later_outlined,
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      TileWidget(
                          text: (widget.doctorModel?.address ?? '').isEmpty?'لم تضاف':widget.doctorModel!.address!,
                          icon: Icons.location_on_rounded),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "معلومات الاتصال",
                  style: getBodyStyle(context,fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.accentColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: TileWidget(
                            text: (widget.doctorModel?.email ?? '').isEmpty?'لم تضاف':widget.doctorModel!.email!,
                            icon: Icons.email),
                        onTap: ()async{
                          await launchUrl(Uri.parse('mailto:${widget.doctorModel?.email}'));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        child: TileWidget(
                            text: (widget.doctorModel?.phone1 ?? '').isEmpty?'لم تضاف':widget.doctorModel!.phone1!,
                            icon: Icons.call),
                        onTap: ()async{
                          await launchUrl(Uri.parse('https://wa.me/${widget.doctorModel?.phone1}'));
                        },
                      ),
                      if (widget.doctorModel?.phone2 != '') ...{
                        const SizedBox(
                          height: 15,
                        ),
                        TileWidget(
                            text: widget.doctorModel?.phone2 ?? '',
                            icon: Icons.call),
                      }
                    ],
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomElevatedButton(
          text: 'احجز موعد الان',
          onPressed: () {
            pushTo(context,BookingView(doctor: widget.doctorModel!,));
          },
        ),
      ),
    );
  }
}