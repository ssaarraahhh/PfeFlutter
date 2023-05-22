import 'package:dronalms/app/components/button.dart';
import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/components/round_icon_button.dart';
import 'package:dronalms/app/models/demandeCongé.dart';
import 'package:dronalms/app/components/simple_text_field.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/services/api_demande.dart';
import 'package:dronalms/app/services/api_files.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Demande extends StatefulWidget {
  const Demande({Key key}) : super(key: key);

  @override
  _DemandeState createState() => _DemandeState();
}

class _DemandeState extends State<Demande> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  Demandec demande = Demandec();
  //  final TextEditingController textEditingController;
  final bool obscureText = false;
  final int maxLines = 1;
  final TextInputType textInputType = TextInputType.text;

  String _selectedType;

  String _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = (pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

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
                Text('Ajout Demande', style: LmsTextUtil.textRoboto24()),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.only(left: 36.w, right: 36.w, top: 45.h),
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (_startDate == null) {
                            return "Entrez une date de Début s'il vous plait";
                          }
                          if (_startDate.isAfter(_endDate)) {
                            return 'End date should be after start date';
                          }
                          return null;
                        },
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2100),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              setState(() {
                                _startDate = date;
                                demande.dateDebut = date;
                              });
                            },
                            currentTime: _startDate,
                          );
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(_startDate),
                        ),
                        textAlign: TextAlign.start,
                        style: LmsTextUtil.textPoppins14(),
                        obscureText: obscureText,
                        minLines: 1,
                        maxLines: maxLines,
                        readOnly: true,
                        keyboardType: textInputType,
                        decoration: InputDecoration(
                          labelText: " Date Début",
                          labelStyle: LmsTextUtil.textPoppins14(),
                          prefixIcon: Icon(Icons.calendar_month,
                              color: LmsColorUtil.primaryThemeColor),
                          contentPadding: EdgeInsets.only(left: 30.w),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.sp),
                            borderSide:
                                BorderSide(color: LmsColorUtil.greyColor10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.sp),
                              borderSide: BorderSide(
                                  color: LmsColorUtil.greyColor4, width: 1)),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      TextFormField(
                        validator: (value) {
                          if (_endDate == null) {
                            return "Entrez une date de fin de congé s'il vous plait";
                          }
                          if (_endDate.isBefore(_startDate)) {
                            return 'End date should be after start date';
                          }
                          return null;
                        },
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: _startDate,
                            maxTime: DateTime(2100),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              setState(() {
                                _endDate = date;
                                demande.dateFin = date;
                              });
                            },
                            currentTime: _endDate,
                          );
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(_endDate),
                        ),
                        textAlign: TextAlign.start,
                        style: LmsTextUtil.textPoppins14(),
                        obscureText: obscureText,
                        minLines: 1,
                        maxLines: maxLines,
                        readOnly: true,
                        keyboardType: textInputType,
                        decoration: InputDecoration(
                          labelText: " Date Fin",
                          labelStyle: LmsTextUtil.textPoppins14(),
                          prefixIcon: Icon(Icons.calendar_month,
                              color: LmsColorUtil.primaryThemeColor),
                          contentPadding: EdgeInsets.only(left: 30.w),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.sp),
                            borderSide:
                                BorderSide(color: LmsColorUtil.greyColor10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.sp),
                              borderSide: BorderSide(
                                  color: LmsColorUtil.greyColor4, width: 1)),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'veuillez écrire le raison ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          demande.raison = value;
                        },
                        textAlign: TextAlign.start,
                        style: LmsTextUtil.textPoppins14(),
                        obscureText: obscureText,
                        minLines: 1,
                        maxLines: maxLines,
                        keyboardType: textInputType,
                        decoration: InputDecoration(
                          labelText: "Raison",
                          labelStyle: LmsTextUtil.textPoppins14(),
                          prefixIcon: Icon(Icons.app_registration_sharp,
                              color: LmsColorUtil.primaryThemeColor),
                          contentPadding: EdgeInsets.only(left: 30.w),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.sp),
                            borderSide:
                                BorderSide(color: LmsColorUtil.greyColor10),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.sp),
                              borderSide: BorderSide(
                                  color: LmsColorUtil.greyColor4, width: 1)),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Container(
                        child: DropdownButtonFormField(
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'veuillez choisir le type';
                          }},
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: LmsTextUtil.textPoppins14(),
                          value: _selectedType,
                          decoration: InputDecoration(
                            labelText: "Type",
                            labelStyle: LmsTextUtil.textPoppins14(),
                            enabled: true,
                            prefixIcon: const Icon(
                              Icons.edit_document,
                              color: LmsColorUtil.primaryThemeColor,
                            ),
                            //
                            contentPadding: EdgeInsets.only(left: 30.w),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.sp),
                              borderSide: BorderSide(
                                  color: LmsColorUtil.greyColor10, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.sp),
                              borderSide: const BorderSide(
                                  color: LmsColorUtil.greyColor4, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Congé',
                              child: Text('Congé'),
                            ),
                            DropdownMenuItem(
                              value: 'Absence',
                              child: Text('Absence'),
                            ),
                          ],
                          onSaved: (value) {
                            demande.type = value;
                          },
                        ),
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            MyButton(
                              //title: "Browse",
                              onPressed: () {
                                getImage();
                              },
                              buttonHeight: 48.h,
                              buttonWidth: 153.w,
                              buttonContainerColor: LmsColorUtil.greyColor2,
                              buttonRadius: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.attach_file_rounded,
                                      color: Colors.black, size: 18.sp),
                                  Text("justificatif",
                                      style: LmsTextUtil.textPoppins18(
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            MyButton(
                              title: "Submit",
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  String justificatifUrl =
                                      await ApiFile().addFile(_image);

                                  if (await ApiDemande()
                                      .adddemande(demande, justificatifUrl)
                                      .then((response) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(response)));
                                  })) {
                                    
                                  }
                                  // .catchError((error) {
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(SnackBar(
                                  //           content: Text(
                                  //               error.toString())));
                                  // });
                                }
                              },
                              buttonHeight: 48.h,
                              buttonWidth: 153.w,
                              buttonContainerColor:
                                  LmsColorUtil.primaryThemeColor,
                              buttonRadius: 30,
                            ),
                            SizedBox(),
                          ],
                        ),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
