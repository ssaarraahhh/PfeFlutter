import 'dart:io';
import 'package:dronalms/app/services/api_files.dart';
import 'package:flutter/material.dart';

import 'package:dronalms/app/components/button.dart';
import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/round_icon_button.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/components/profile_text_field.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../services/api_employe.dart';
import '../controllers/my_profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileView extends GetView<MyProfileController> {
  MyProfileView({Key key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  Employe _employe;
  String img;
  MyProfileController controller = Get.find<MyProfileController>();

  String _image;
  final picker = ImagePicker();
  Future getImage1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("pathhh${pickedFile.path}");
      String justificatifUrl = await ApiFile().addFile(pickedFile.path);
      print("ggggggggg$justificatifUrl");
      controller.setUserImage(justificatifUrl);
    } else {
      print('No image selected.');
    }
  }

  void initState() {
    Get.put<MyProfileController>(MyProfileController()).onInit();

    ApiEmploye().fetchEmployeById().then((employe) {
      _employe = employe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: Colors.transparent),
      drawer: LmsDrawer(),
      body: SafeArea(
        child: Column(
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
                Text('Mon Profil', style: LmsTextUtil.textRoboto24()),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                padding: EdgeInsets.only(left: 36.w, right: 36.w, bottom: 51.h),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 30.w),
                          GestureDetector(
                            onTap: () {
                              controller.isReadOnly.value = false;
                            },
                            child: Container(
                              height: 42.h,
                              width: 42.w,
                              margin: EdgeInsets.only(top: 5.h),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: LmsColorUtil.primaryThemeColor,
                                boxShadow: [
                                  BoxShadow(color: Colors.black),
                                ],
                              ),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 25.sp),
                            ),
                          ),
                        ],
                      ),
                      ...profileListFields(),
                    ],
                  ),
                  SizedBox(height: 13.h),
                  Obx(
                    () => controller.isReadOnly.value == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MyButton(
                                  title: "Enregistrer",
                                  onPressed: () async {
                                    //

                                    controller.isReadOnly.value = true;
                                    controller.saveChanges(context);
                                  },
                                  buttonHeight: 41,
                                  buttonWidth: 168.w,
                                  buttonRadius: 5,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: MyButton(
                                  title: "Annuler",
                                  onPressed: () {
                                    controller.isReadOnly.value = true;
                                  },
                                  buttonHeight: 41,
                                  buttonWidth: 168.w,
                                  buttonRadius: 5,
                                  buttonContainerColor: LmsColorUtil.greyColor5,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> profileListFields() {
    MyProfileController controller = Get.find<MyProfileController>();

    Future<String> getImage() async {
      await Future.delayed(Duration(milliseconds: 1000), () {
        return controller.userImg;
      });
    }

    return [
      FutureBuilder<String>(
          future: getImage(),
          builder: (context, snapshot) {
            print("hajkefnrr ${controller.userImg}");
            if (!snapshot.hasData) {
              return ClipOval(
                child: Image.network(
                  controller.userImg,
                  width: 80.sp,
                  height: 80.sp,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    setState() {
                      img = controller.userImg;
                    }

                    return Icon(Icons
                        .error); // Display an error icon or placeholder image
                  },
                ),
              );
            } // or some other placeholder
            else {
              return ClipOval(
                child: Image.network(
                  controller.userImg,
                  width: 80.sp,
                  height: 80.sp,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    setState() {
                      img = controller.userImg;
                    }

                    return Icon(Icons
                        .error); // Display an error icon or placeholder image
                  },
                ),
              );
            }
          }),
      IconButton(
        onPressed: () {
          getImage1();
        },
        icon: Icon(
          Icons.upload_file_rounded,
          color: LmsColorUtil.primaryThemeColor,
        ),
      ),
      SizedBox(height: 20.h),
      ProfileTextField(
        hintText: "CIN",
        textEditingController: controller.userIdController,
        isProtectedField: true,
        preIconData: Icons.verified_user_outlined,
        validator: (value) {
          if (value.isEmpty) {
            return "CIN ne peut pas etre ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Nom ",
        textEditingController: controller.userNameController,
        preIconData: Icons.person_outline_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "Nom ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Prénom",
        textEditingController: controller.userName2Controller,
        preIconData: Icons.person_outline_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "le Prenom ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Adresse Email",
        textEditingController: controller.emailController,
        preIconData: Icons.email_outlined,
        validator: (value) {
          if (value.isEmpty) {
            return "l'adresse email ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Numéro",
        textEditingController: controller.phoneNoController,
        preIconData: Icons.phone,
        validator: (value) {
          if (value.isEmpty) {
            return "    Numéro ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Date de Naissance",
        textEditingController: controller.dateOfBirthController,
        isProtectedField: true,
        preIconData: Icons.date_range,
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Adresse",
        textEditingController: controller.locationController,
        preIconData: Icons.location_on_outlined,
        validator: (value) {
          if (value.isEmpty) {
            return "Adresse ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Fonction",
        textEditingController: controller.functionController,
        isProtectedField: true,
        preIconData: Icons.work_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "Fonction ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "Ancien mot de passe",
        textEditingController: controller.useraccpasswordController,
       isPassword: true,
        preIconData: Icons.password_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "repeter le mot de passe";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "nouveau mot de passe ",
        textEditingController: controller.usernewpasswordController,
      isPassword: true,
        preIconData: Icons.password_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "Fonction ne peut pas etre vide ";
          }
          return null;
        },
      ),
      SizedBox(height: 13.h),
      ProfileTextField(
        hintText: "confirmer le mot de passe ",
        textEditingController: controller.userconfirmnewpasswordController,
        isPassword: true,
        preIconData: Icons.password_rounded,
        validator: (value) {
          if (value.isEmpty) {
            return "Fonction ne peut pas etre vide ";
          }
          return null;
        },
      ),
    ];
  }
}
