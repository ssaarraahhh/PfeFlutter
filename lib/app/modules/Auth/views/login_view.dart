import 'dart:math';

import 'package:StaffFlow/app/components/button.dart';
import 'package:StaffFlow/app/constants/image_constants.dart';
import 'package:StaffFlow/app/models/EmployeInfo.dart';
import 'package:StaffFlow/app/models/employe.dart';
import 'package:StaffFlow/app/models/login.dart';
import 'package:StaffFlow/app/modules/LmsDashboard/views/lms_dashboard_view.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ControllerHub.dart';
import 'package:StaffFlow/app/modules/Messagerie/views/HomeScreen.dart';
import 'package:StaffFlow/app/routes/app_pages.dart';
import 'package:StaffFlow/app/services/api_employe.dart';
import 'package:StaffFlow/app/theme/color_util.dart';
import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/hub_connection.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController userNameController = TextEditingController();
  EmployeInfo login = EmployeInfo(); // initialize login object
  Login login1 = Login(); // initialize login object

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ControllerHub().authMeListenerSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 36.w, right: 36.w, bottom: 51.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              Image.asset(
                ImageConstants.LOG,
                height: 200.h,
                width: 204.w,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 25.h),
              Form(
                key: formKey, // set key

                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Connectez-vous",
                        style: LmsTextUtil.textPoppins24(),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                key: Key('email'),
                controller: userNameController,
                textAlign: TextAlign.start,
                style: LmsTextUtil.textPoppins14(),
                obscureText: false,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Adresse Email",
                  labelStyle: LmsTextUtil.textPoppins14(),
                  prefixIcon: Icon(Icons.person_sharp,
                      color: LmsColorUtil.primaryThemeColor),
                  contentPadding: EdgeInsets.only(left: 30.w),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide(color: LmsColorUtil.greyColor10),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.sp),
                      borderSide:
                          BorderSide(color: LmsColorUtil.greyColor4, width: 1)),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: passwordController,
                textAlign: TextAlign.start,
                style: LmsTextUtil.textPoppins14(),
                obscureText: true,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Mot De Passe",
                  labelStyle: LmsTextUtil.textPoppins14(),
                  prefixIcon: Icon(Icons.password,
                      color: LmsColorUtil.primaryThemeColor),
                  contentPadding: EdgeInsets.only(left: 30.w),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide(color: LmsColorUtil.greyColor10),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.sp),
                      borderSide:
                          BorderSide(color: LmsColorUtil.greyColor4, width: 1)),
                ),
              ),
              SizedBox(height: 155.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MyButton(
                      title: "connexion",
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          login.email = userNameController.text;
                          login.password = passwordController.text;
                          formKey.currentState.save();
                          login1.email = userNameController.text;
                          login1.password =
                              passwordController.text; // save the form values
                         

                          await ControllerHub().authMe(
                              userNameController.text, passwordController.text);

                          // await ApiEmploye().login(login1);
                          
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('token');

                          if (token != null) {
                            print("connecting 4");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LmsDashboardView()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(""),
                                  content: Text(
                                    "votre adresse email ou mot de passe est incorrect",
                                    style: LmsTextUtil.textPoppins14(),
                                  ),
                                  actions: <Widget>[
                                    MyButton(
                                      child: const Text("d'accord"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
