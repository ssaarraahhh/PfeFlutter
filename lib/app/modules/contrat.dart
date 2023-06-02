import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/models/contrat.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/services/api_employe.dart';
import 'package:dronalms/app/services/api_magasin.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/magasin.dart';

class Contract extends StatefulWidget {
  @override
  ContractState createState() => ContractState();
}

class ContractState extends State<Contract> {
   Future<Contrat> _futureContrats;

  @override
  void initState() {
    super.initState();
    _futureContrats = _fetchContrats();
  }

  Future<Contrat> _fetchContrats() async {
    final Contrat contract = await ApiEmploye().fetchContrat();
    return contract;
  }

  final bool obscureText = false;
  final int maxLines = 1;
  final TextInputType textInputType = TextInputType.text;
  Employe employes;
  Magasin _magasin;

  Future<Employe> _fetchEmployes() async {
    try {
      employes = await ApiEmploye().fetchEmployeById();
      int a = employes.idMagasin;
      _magasin = await ApiMagasin().fetchmagasinById(1);
      return employes;
    } catch (e) {
      print("Error: $e");
      return employes;
    }
  }

  bool _isContractValid(Contrat contract, DateTime currentDate) {
    DateTime dateTime = currentDate;
    DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime dateTime2 = contract.dateFin;
    DateTime datef = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);
    DateTime dateTime3 = contract.dateDebut;
    DateTime dated = DateTime(dateTime3.year, dateTime3.month, dateTime3.day);
    return datef.isAfter(date) ||
        datef == date && dated.isBefore(date) ||
        dated == date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(backgroundColor: Colors.transparent),
        drawer: LmsDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text("OBJET :  il s'agit d'un contrat de travail ",
                  style: LmsTextUtil.textRoboto24()),
            ),
            SingleChildScrollView(
              child: FutureBuilder<Contrat>(
                  future: _futureContrats,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final contracts = snapshot.data;
                      final currentDate = DateTime.now();
            
                      if (!_isContractValid(contracts, currentDate)) {
                        return const Placeholder(
                          fallbackHeight: 100,
                          color: Colors.grey,
                          strokeWidth: 2,
                        );
                      }
            
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
                                      text: contracts.dateDebut
                                          .toString()
                                          .substring(0, 10),
                                    ),
                                    keyboardType: textInputType,
                                    decoration: InputDecoration(
                                      labelText: " Date Début De Contrat",
                                      labelStyle: LmsTextUtil.textPoppins14(),
                                      prefixIcon: Icon(Icons.calendar_month,
                                          color: LmsColorUtil.primaryThemeColor),
                                      contentPadding: EdgeInsets.only(left: 30.w),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.sp),
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
                                      text: contracts.dateFin
                                          .toString()
                                          .substring(0, 10),
                                    ),
                                    keyboardType: textInputType,
                                    decoration: InputDecoration(
                                      labelText: " Date Fin De Contrat ",
                                      labelStyle: LmsTextUtil.textPoppins14(),
                                      prefixIcon: Icon(Icons.calendar_month,
                                          color: LmsColorUtil.primaryThemeColor),
                                      contentPadding: EdgeInsets.only(left: 30.w),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.sp),
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
                                  FutureBuilder<Employe>(
                                    future: _fetchEmployes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final employes = snapshot.data;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                    "${employes.nom} ${employes.prenom}",
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText:
                                                    " Nom & Prénom de l'Employé",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.person_outline_rounded,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
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
                                                text: employes.fonction,
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText: " Fonction",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.work_rounded,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
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
                                                text: employes.adresse,
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText: " Adresse",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.location_on_outlined,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
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
                                                text: employes.email,
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText: " Adresse Email",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.email_outlined,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
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
                                                text:
                                                    employes.numTel,
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText: " Numéro de télèphone",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.phone,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
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
                                                text: _magasin?.nom,
                                              ),
                                              keyboardType: textInputType,
                                              decoration: InputDecoration(
                                                labelText: " Nom du Magasin",
                                                labelStyle:
                                                    LmsTextUtil.textPoppins14(),
                                                prefixIcon: Icon(
                                                    Icons.add_business_sharp,
                                                    color: LmsColorUtil
                                                        .primaryThemeColor),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30.w),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.sp),
                                                  borderSide: BorderSide(
                                                      color: LmsColorUtil
                                                          .greyColor10),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.sp),
                                                    borderSide: BorderSide(
                                                        color: LmsColorUtil
                                                            .greyColor4,
                                                        width: 1)),
                                              ),
                                            ),
                                            // Add more TextFormFields for each field you want to display
                                          ],
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
                  }),
            )
          ])),
        ));
  }
}
