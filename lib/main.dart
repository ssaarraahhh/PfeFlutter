import 'dart:convert';

import 'package:dronalms/app/constants/app_string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => {
      runApp(DronaLMS()),
    },
  );
}

class DronaLMS extends StatelessWidget {
  DronaLMS({Key key}) : super(key: key);

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));
      final expirationTimestamp = decodedToken['exp'];
      final expirationDate =
          DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);
      final currentDate = DateTime.now();
      print(expirationDate);
      print(currentDate);
      if (expirationDate.isAfter(currentDate)) {
        return Routes.LMS_DASHBOARD;
      } else {
        return Routes.AUTH;
      }
    } else {
      return Routes.AUTH;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return FutureBuilder(
            future: getToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: LmsAppConstants.APP_NAME,
                  initialRoute: snapshot.data,
                  getPages: AppPages.routes,
                  theme: ThemeData.light()
                      .copyWith(scaffoldBackgroundColor: Colors.white),
                );
              } else {
                // Handle loading state
                return Container();
              }
            },
          );
        });
  }
}
