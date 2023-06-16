import 'package:StaffFlow/app/components/custom_appbar.dart';
import 'package:StaffFlow/app/components/lms_drawer.dart';
import 'package:StaffFlow/app/models/demandeCongé.dart';
import 'package:StaffFlow/app/modules/Administration/views/tile_content_view.dart';
import 'package:StaffFlow/app/routes/app_pages.dart';
import 'package:StaffFlow/app/services/api_employe.dart';
import 'package:StaffFlow/app/theme/color_util.dart';
import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Administration extends StatefulWidget {
  const Administration({Key key});

  @override
  _AdministrationState createState() => _AdministrationState();
}

class _AdministrationState extends State<Administration> {
  String _selectedItem = "tous";
  DateTime currentDate = DateTime.now();

  List<Demandec> filterDemandes(List<Demandec> demandes) {
    if (_selectedItem == null) {
      return demandes;
    } else if (_selectedItem == 'validé') {
      return demandes.where((demande) => demande.reponse == 'validé').toList();
    } else if (_selectedItem == 'refusé') {
      return demandes.where((demande) => demande.reponse == 'refusé').toList();
    } else if (_selectedItem == 'en attente') {
      return demandes
          .where((demande) => demande.reponse == 'en attente')
          .toList();
    } else {
      return demandes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: LmsDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 25.w, top: 24.h, right: 25.w, bottom: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text("Liste des demandes des congés",
                      style: LmsTextUtil.textRoboto24()),
                ),
                SizedBox(height: 50.h),
                Container(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: LmsTextUtil.textPoppins14(),
                    value: _selectedItem,
                    decoration: InputDecoration(
                      labelText: "état",
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
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'tous',
                        child: Text('tous'),
                      ),
                      DropdownMenuItem(
                        value: 'validé',
                        child: Text('validé'),
                      ),
                      DropdownMenuItem(
                        value: 'refusé',
                        child: Text('refusé'),
                      ),
                      DropdownMenuItem(
                        value: 'en attente',
                        child: Text('en attente'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                FutureBuilder<List<Demandec>>(
                  future: ApiEmploye().fetchDemande(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final filteredDemandes = filterDemandes(snapshot.data);
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: filteredDemandes.length,
                        itemBuilder: (context, index) {
                          final demande = filteredDemandes[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25.sp,
                              backgroundColor: LmsColorUtil.lightBlueIcons,
                              child: demande.reponse == "en attente"
                                  ? Icon(
                                      Icons.more_horiz,
                                      color: Colors.yellow.shade400,
                                      size: 40.sp,
                                    )
                                  : demande.reponse == "validé"
                                      ? Icon(
                                          Icons.check_rounded,
                                          color: Colors.green.shade600,
                                          size: 40.sp,
                                        )
                                      : Icon(
                                          Icons.cancel_sharp,
                                          color: Colors.red.shade900,
                                          size: 40.sp,
                                        ),
                            ),
                            title: Text(
                              '${currentDate.day}/${currentDate.month}/${currentDate.year}',
                              style: LmsTextUtil.textManrope14(
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: GestureDetector(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 25.sp,
                                color: LmsColorUtil.primaryThemeColor,
                              ),
                              onTap: () {
                                Get.to(() => TileContentView(
                                    id: demande.id, ind: index));
                              },
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 0, right: 0, top: 0),
                            minVerticalPadding: 0,
                            horizontalTitleGap: 10,
                            minLeadingWidth: 0,
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: 0),
                            dense: true,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur : ${snapshot.error}'),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LmsColorUtil.primaryThemeColor,
        onPressed: () {
          Get.toNamed(Routes.ADD_DEMAND);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
