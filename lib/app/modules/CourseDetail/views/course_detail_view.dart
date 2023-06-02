import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/round_icon_button.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/modules/AttendQuiz/views/attend_quiz_view.dart';
import 'package:dronalms/app/modules/CourseDetail/views/video2.dart';
import 'package:dronalms/app/services/api_formation.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../models/formation.dart';
import 'course_content_tile_view.dart';

class CourseDetailView extends StatefulWidget {
  final int id;
  const CourseDetailView({Key key, this.id}) : super(key: key);

  @override
  _CourseDetailViewState createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  Future<List<Formation>> _formations;
  final String videoUrl = "$URL/Files/getVideo";

  @override
  void initState() {
    super.initState();
    _formations = ApiFormation().fetchFormations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: LmsDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Formation>>(
            future: _formations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final formations = snapshot.data;
final filteredFormations =
                    formations.where((f) => f.id == widget.id).toList();

                final frmt = filteredFormations[0];
                return buildCourseDetail(frmt);
              } else if (snapshot.hasError) {
                return buildErrorWidget();
              } else {
                return buildLoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildCourseDetail(Formation frmt) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundIconButton(onTap: () {
                Get.back();
              }),
              Text(frmt.nom, style: LmsTextUtil.textRubik24()),
              const SizedBox(height: 80),
            ],
          ),
          buildProgressIndicator(value: 18),
          Container(
            height: 350.h,
            width: 1000.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: VideoPlayerScreen2(
              videoUrl: '$videoUrl/${frmt.formation}',
            ),
          ),
          buildCourseDescription(frmt),
          SizedBox(height: 20.h),
          Text("Support de cours", style: LmsTextUtil.textManrope24()),
          SizedBox(height: 15.h),
          CourseContentTile(fichier: frmt.fichier),
          SizedBox(height: 20.h),
          Text("Passer un test", style: LmsTextUtil.textManrope24()),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendQuizView(id: frmt.id),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: buildQuizListTile(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgressIndicator({int value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Progress",
                style:
                    LmsTextUtil.textManrope14(fontWeight: FontWeight.w600)),
            Text("$value% Complete",
                style: LmsTextUtil.textManrope12(color: Colors.black)),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          child: LinearProgressIndicator(
            backgroundColor: LmsColorUtil.greyColor3,
            value: value / 100,
            color: LmsColorUtil.primaryThemeColor,
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }

  Widget buildCourseDescription(Formation frmt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Description",
            style: LmsTextUtil.textManrope24(),
          ),
        ),
        ReadMoreText(
          frmt.description,
          trimLength: 160,
          colorClickableText: LmsColorUtil.primaryThemeColor,
          style: LmsTextUtil.textRubik14(),
          trimCollapsedText: "Plus",
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10.w),
            iconTextRow(
              iconData: Icons.sticky_note_2_sharp,
              title: "Formation",
            ),
          ],
        ),
      ],
    );
  }

  Widget iconTextRow({
    IconData iconData,
    String title,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: LmsColorUtil.primaryThemeColor,
          size: 18.sp,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: LmsTextUtil.textManrope12(color: Colors.black),
        ),
      ],
    );
  }

  Widget buildQuizListTile() {
    return ListTile(
      leading: Icon(
        Icons.task,
        color: LmsColorUtil.primaryThemeColor,
        size: 20,
      ),
      title: Text(
        "Passer Test",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey),
      ),
      contentPadding: EdgeInsets.only(left: 12, right: 20, top: 0),
      minVerticalPadding: 15,
      horizontalTitleGap: 10,
      minLeadingWidth: 0,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      dense: true,
    );
  }

  Widget buildErrorWidget() {
    return Center(
      child: Text('Failed to load formations'),
    );
  }

  Widget buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

