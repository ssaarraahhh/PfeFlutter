import 'dart:math';

import 'package:StaffFlow/app/components/button.dart';
import 'package:StaffFlow/app/components/custom_appbar.dart';
import 'package:StaffFlow/app/components/round_icon_button.dart';
import 'package:StaffFlow/app/models/enonceTest.dart';
import 'package:StaffFlow/app/modules/AttendQuiz/components/quiz_container.dart';
import 'package:StaffFlow/app/modules/AttendQuiz/views/quiz.dart';
import 'package:StaffFlow/app/services/api_test.dart';
import 'package:StaffFlow/app/theme/color_util.dart';
import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AttendQuizView extends StatefulWidget {
  final int id;

  const AttendQuizView({Key key, this.id}) : super(key: key);

  @override
  _AttendQuizViewState createState() => _AttendQuizViewState();
}

class _AttendQuizViewState extends State<AttendQuizView> {
  Future<List<EnonceTest>> _test;

  @override
  void initState() {
    super.initState();

    _test = ApiTest().fetchEnonce();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 22.w),
                  RoundIconButton(onTap: () {
                    Get.back();
                  }),
                  SizedBox(width: 28.w),
                  Text('Test', style: LmsTextUtil.textRoboto24()),
                ],
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(
                    left: 36.w, right: 36.w, top: 24.h, bottom: 15.h),
                child: FutureBuilder<List<EnonceTest>>(
                  future: _test.then((t) =>
                      t.where((f) => f.idFormation == widget.id).toList()),
                  builder: (context, snapshot) {
                    print("hemllkkjjjjjjjjjjjjjjjjj");
                    print(snapshot);
                    if (snapshot.hasData) {
                      final tests = snapshot.data;
                      int variable = tests.length-1;
                      List<int> mySet = [0, variable];
                      Random random = Random();
                      int randomNum =
                          mySet.elementAt(random.nextInt(mySet.length));

                      final ff = tests[randomNum];
                      return QuizContainer(
                        width: 356,
                        height: 510,
                        containerChild: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cliquer sur commencer",
                                    style: LmsTextUtil.textPoppins14()),
                                Container(
                                  height: 49.h,
                                  width: 49.w,
                                  margin: EdgeInsets.only(right: 15.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2,
                                        color: LmsColorUtil.greyColor3),
                                  ),
                                  child: Text(ff.temps,
                                      style: LmsTextUtil.textManrope12(
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  margin: EdgeInsets.only(right: 9.w),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: LmsColorUtil.primaryThemeColor),
                                ),
                                Text("Toutes les questions sont obligatoires.",
                                    style: LmsTextUtil.textPoppins12()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  margin: EdgeInsets.only(right: 9.w),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: LmsColorUtil.primaryThemeColor),
                                ),
                                Text(
                                    "Il y a des pénalités pour les réponses\n incorrectes",
                                    style: LmsTextUtil.textPoppins12()),
                                    
                                SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: MyButton(
                                  title: "commencer le test",
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizScreen(
                                              id: ff.id, temp: ff.temps),
                                        ));
                                  },
                                  buttonWidth: 315,
                                ),
                              ),
                            ),
                            SizedBox(height: 19.h),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
