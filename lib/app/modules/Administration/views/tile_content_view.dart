import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/components/round_icon_button.dart';
import 'package:dronalms/app/models/demandeCong%C3%A9.dart';
import 'package:dronalms/app/services/api_employe.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../models/contrat.dart';

class TileContentView extends StatefulWidget {
  final int id;
  final int ind;

  const TileContentView({Key key, this.id, this.ind}) : super(key: key);

  @override
  _TileContentViewState createState() => _TileContentViewState();
}

class _TileContentViewState extends State<TileContentView> {
  Future<List<Demandec>> _demande;
  final bool obscureText = false;
  final int maxLines = 1;
  final TextInputType textInputType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    _demande = ApiEmploye().fetchDemande();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: LmsDrawer(),
      body: SafeArea(
          child: FutureBuilder<List<Demandec>>(
              future: _demande
                  .then((dem) => dem.where((f) => f.id == widget.id).toList()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final demand = snapshot.data;
                  final dem = demand[0];

                  return Container(
                    height: 800, // Replace with your desired height
                    child: ListView(children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                textAlign: TextAlign.start,
                                style: LmsTextUtil.textPoppins14(),
                                obscureText: obscureText,
                                minLines: 1,
                                maxLines: maxLines,
                                readOnly: true,
                                controller: TextEditingController(
                                  text:
                                      dem.dateDebut.toString().substring(0, 10),
                                ),
                                keyboardType: textInputType,
                                decoration: InputDecoration(
                                  labelText: " Date Début ",
                                  labelStyle: LmsTextUtil.textPoppins14(),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: LmsColorUtil.primaryThemeColor),
                                  contentPadding: EdgeInsets.only(left: 30.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: BorderSide(
                                        color: LmsColorUtil.greyColor10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: BorderSide(
                                          color: LmsColorUtil.greyColor4,
                                          width: 1)),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              TextFormField(
                                textAlign: TextAlign.start,
                                style: LmsTextUtil.textPoppins14(),
                                obscureText: obscureText,
                                minLines: 1,
                                maxLines: maxLines,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: dem.dateFin.toString().substring(0, 10),
                                ),
                                keyboardType: textInputType,
                                decoration: InputDecoration(
                                  labelText: " Date Fin  ",
                                  labelStyle: LmsTextUtil.textPoppins14(),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: LmsColorUtil.primaryThemeColor),
                                  contentPadding: EdgeInsets.only(left: 30.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: BorderSide(
                                        color: LmsColorUtil.greyColor10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: BorderSide(
                                          color: LmsColorUtil.greyColor4,
                                          width: 1)),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              TextFormField(
                                textAlign: TextAlign.start,
                                style: LmsTextUtil.textPoppins14(),
                                obscureText: obscureText,
                                minLines: 1,
                                maxLines: maxLines,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: dem.raison.toString(),
                                ),
                                keyboardType: textInputType,
                                decoration: InputDecoration(
                                  labelText: "Le raison  ",
                                  labelStyle: LmsTextUtil.textPoppins14(),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: LmsColorUtil.primaryThemeColor),
                                  contentPadding: EdgeInsets.only(left: 30.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: BorderSide(
                                        color: LmsColorUtil.greyColor10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: BorderSide(
                                          color: LmsColorUtil.greyColor4,
                                          width: 1)),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              TextFormField(
                                textAlign: TextAlign.start,
                                style: LmsTextUtil.textPoppins14(),
                                obscureText: obscureText,
                                minLines: 1,
                                maxLines: maxLines,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: dem.type.toString().substring(0, 10),
                                ),
                                keyboardType: textInputType,
                                decoration: InputDecoration(
                                  labelText: " Type  ",
                                  labelStyle: LmsTextUtil.textPoppins14(),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: LmsColorUtil.primaryThemeColor),
                                  contentPadding: EdgeInsets.only(left: 30.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: BorderSide(
                                        color: LmsColorUtil.greyColor10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: BorderSide(
                                          color: LmsColorUtil.greyColor4,
                                          width: 1)),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              TextFormField(
                                textAlign: TextAlign.start,
                                style: LmsTextUtil.textPoppins14(),
                                obscureText: obscureText,
                                minLines: 1,
                                maxLines: maxLines,
                                readOnly: true,
                                controller: TextEditingController(
                                  text: dem.reponse.toString().substring(0, 10),
                                ),
                                keyboardType: textInputType,
                                decoration: InputDecoration(
                                  labelText: " Réponse  ",
                                  labelStyle: LmsTextUtil.textPoppins14(),
                                  prefixIcon: Icon(Icons.calendar_month,
                                      color: LmsColorUtil.primaryThemeColor),
                                  contentPadding: EdgeInsets.only(left: 30.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: BorderSide(
                                        color: LmsColorUtil.greyColor10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: BorderSide(
                                          color: LmsColorUtil.greyColor4,
                                          width: 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                ;
              })),
    );
  }
}
