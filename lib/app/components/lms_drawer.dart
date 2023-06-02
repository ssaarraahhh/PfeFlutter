import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/components/icon_text_row.dart';

import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_employe.dart';

class LmsDrawer extends StatefulWidget {
  const LmsDrawer({Key key}) : super(key: key);

  @override
  LmsDrawerState createState() => LmsDrawerState();
}

class LmsDrawerState extends State<LmsDrawer> {
  Employe _employe;
  String Url = "$URL/Files/getImage";

  @override
  void initState() {
    super.initState();
    ApiEmploye().fetchEmployeById().then((employe) {
      setState(() {
        _employe = employe;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: LmsColorUtil.primaryThemeColor,
      width: ScreenUtil().screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            padding: EdgeInsets.only(
                top: 60.h, left: 46.w, right: 10.w, bottom: 10.h),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              FutureBuilder<Employe>(
                future: Future.value(_employe),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final employes = snapshot.data;
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 15.w,
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      leading: CircleAvatar(
                        radius: 30.sp,

                        backgroundColor: Colors.grey,
                        child: ClipOval(
                          child: Image.network(
                            "$Url/${employes.image}",
                            width: 80.sp,
                            height: 80.sp,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text("${employes.nom} ${employes.prenom}",
                          style: LmsTextUtil.textManrope20()),
                      subtitle: Text(employes.id.toString(),
                          style:
                              LmsTextUtil.textManrope12(color: Colors.white)),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.dashboard_customize,
                title: "Dashboard",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.LMS_DASHBOARD);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.home_outlined,
                title: "Accueil",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.HOME);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                  iconData: Icons.account_circle_outlined,
                  title: "Profil",
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.MY_PROFILE);
                  }),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.content_paste_search,
                title: "Contrat",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CONTRAT);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.menu_book_sharp,
                title: "Formations",
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.LMS_MY_COURSES);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.event_sharp,
                title: "Planification",
                onTap: () {
                  Get.back();
                  //Get.to(Routes.CALENDAR);
                  Get.toNamed(Routes.CALENDAR);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                iconData: Icons.support_agent_sharp,
                title: "Congés/Absences",
                onTap: () {
                 Get.back();
                  Get.toNamed(Routes.ADMINISTRATION);
                },
              ),
              SizedBox(height: 30.h),
              IconTextRow(
                  iconData: Icons.logout,
                  title: "déconnexion",
                  onTap: () async {
                    Get.toNamed(Routes.AUTH);
                      final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
                  }),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 37.h),
            child: Text("Version 1.01", style: LmsTextUtil.textManrope16()),
          ),
        ],
      ),
    );
  }
}
