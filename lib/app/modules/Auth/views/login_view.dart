import 'package:dronalms/app/components/button.dart';
import 'package:dronalms/app/constants/image_constants.dart';
import 'package:dronalms/app/models/login.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/services/api_employe.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController userNameController = TextEditingController();
  Login login = Login(); // initialize login object
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
                          formKey.currentState.save(); // save the form values
                          // print(ApiEmploye().login(login));

                          final result = await ApiEmploye().login(login);
                          final prefs = await SharedPreferences.getInstance();

                          final token = prefs.getString('token');
                          if (token != null) {
                            Get.offNamed(Routes.LMS_DASHBOARD);
                          }
                          else{
                            showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(""),
        content: Text("votre adresse email ou mot de passe est incorrect",style:LmsTextUtil.textPoppins14(), ),
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
  );}
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
