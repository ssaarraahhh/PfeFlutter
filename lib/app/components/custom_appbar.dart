import 'package:StaffFlow/app/models/notification.dart';
import 'package:StaffFlow/app/modules/LmsDashboard/views/lms_dashboard_view.dart';
import 'package:StaffFlow/app/modules/Messagerie/views/HomeScreen.dart';
import 'package:StaffFlow/app/services/api_notification.dart';
import 'package:StaffFlow/app/theme/color_util.dart';
import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key key, this.backgroundColor = Colors.white})
      : super(key: key);
  final Color backgroundColor;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(54.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool showNotificationArea = true;

  String formatDateTime() {
    var lmsDateTime = DateFormat('d MMM yyyy | HH:mm').format(DateTime.now());
    return lmsDateTime.toString();
  }
  Future<List<Notification1>> _fetchNotif() async {
    final List<Notification1> contract = await ApiNotification().fetchNotifications();
    return contract;
  }
  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffoldState = Scaffold.of(context);
    return AppBar(
      toolbarHeight: 57.h,
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          scaffoldState.isDrawerOpen == false
              ? scaffoldState.openDrawer()
              : scaffoldState.closeDrawer();
        },
        child: Icon(
          Icons.sort_rounded,
          color: LmsColorUtil.primaryThemeColor,
          size: 28.sp,
        ),
      ),
      centerTitle: true,
      toolbarOpacity: 1,
      title: GestureDetector(
        onTap: () => Get.offAll(() => LmsDashboardView()),
        child: Icon(
          Icons.dashboard_rounded,
          color: LmsColorUtil.primaryThemeColor,
          size: 28.sp, // Adjust the size as needed
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showNotificationDialog();
          },
          child: Container(
            margin: EdgeInsets.only(
                right: 10.w, top: 20.h, bottom: 6.h, left: 20.w),
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(
                color: LmsColorUtil.primaryThemeColor,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.notifications,
                color: LmsColorUtil.primaryThemeColor,
                size: 15.sp,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Container(
            margin: EdgeInsets.only(
                right: 25.w, top: 20.h, bottom: 6.h, left: 10.w),
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(
                color: LmsColorUtil.primaryThemeColor,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.email_rounded,
                color: LmsColorUtil.primaryThemeColor,
                size: 15.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future showNotificationDialog() {
    return showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        barrierLabel: "StaffFlow",
        pageBuilder: (_, __, ___) {
          return Stack(
            alignment: Alignment.topRight,
            fit: StackFit.loose,
            children: [
              Container(
                height: 400.h,
                width: 400.w,
                margin: EdgeInsets.only(top: 90.h, right: 16.w),
                // padding: EdgeInsets.only(left: 10.w, top: 2.h),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.sp),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, spreadRadius: 1),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 32.h,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10.w, top: 2.h),
                        decoration: BoxDecoration(
                          color: LmsColorUtil.primaryThemeColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.sp),
                            topLeft: Radius.circular(10.sp),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle(
                          style: LmsTextUtil.textRubik16(),
                          child: const Text("Notification"),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 350.h,
                        child: _buildListTile(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildListTile() {
  return FutureBuilder<List<Notification1>>(
    future: _fetchNotif(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // While waiting for the API response, you can show a loading indicator
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // If there's an error, you can display an error message
        return Text('Error: ${snapshot.error}');
      } else {
        // If the API response is successful, display the notifications
        final notifications = snapshot.data;

        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: notifications.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
            indent: 5,
            endIndent: 5,
            color: LmsColorUtil.greyColor3,
          ),
          itemBuilder: (_, index) {
            final notification = notifications;
            return ListTile(
              title: Text(
                notification[index].notifi,
                style: LmsTextUtil.textRoboto11(),
              ),
              // subtitle: Text(
              //  notification[index].notifi, // Pass the notification's dateTime to formatDateTime function
              //   style: LmsTextUtil.textRoboto11(
              //     color: LmsColorUtil.greyColor3,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              contentPadding: EdgeInsets.only(left: 12.w, right: 8.w, top: 0.h, bottom: 0),
              minVerticalPadding: 10.h,
              horizontalTitleGap: 0.w,
              minLeadingWidth: 0,
              dense: true,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4.h),
            );
          },
        );
      }
    },
  );
}


  // ... existing code ...


 // Size get preferredSize => Size.fromHeight(57.h);
}
