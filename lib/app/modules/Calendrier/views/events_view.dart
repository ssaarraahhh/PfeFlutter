import 'package:StaffFlow/app/components/custom_appbar.dart';
import 'package:StaffFlow/app/components/lms_drawer.dart';
import 'package:StaffFlow/app/components/round_icon_button.dart';
import 'package:StaffFlow/app/modules/Calendrier/views/planning.dart';
import 'package:StaffFlow/app/routes/app_pages.dart';
import 'package:StaffFlow/app/theme/color_util.dart';
import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: LmsDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 24.w),
                RoundIconButton(onTap: () {
                  Get.offNamed(Routes.LMS_DASHBOARD);
                }),
                SizedBox(width: 45.w),
                Text('planification', style: LmsTextUtil.textRoboto24()),
              ],
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                shrinkWrap: true,
                children: [
                  Container(
                    height: 1000.h,
                    width: 700,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            spreadRadius: 1),
                      ],
                    ),
                    child: Planning(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// child: CalendarDatePicker(
//   firstDate: DateTime(2018),
//   initialDate: DateTime(2022),
//   lastDate: DateTime.now(),
//   onDateChanged: (DateTime value) {},
// ),
