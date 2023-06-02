import 'package:dronalms/app/components/round_icon_button.dart';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/formation.dart';
import 'package:dronalms/app/modules/CourseDetail/views/course_detail_view.dart';
import 'package:dronalms/app/modules/LmsMyCourses/views/video.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/services/api_formation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/lms_drawer.dart';
import '../../../theme/text_style_util.dart';

class Cours extends StatefulWidget {
  final int id;
  Cours({Key key, this.id}) : super(key: key);

  @override
  _CoursState createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  Future<List<Formation>> _formations;
  String _videoUrl = "$URL/Files/getVideo";

  @override
  void initState() {
    super.initState();
    _loadFormations();
  }

  void _loadFormations() {
    _formations = ApiFormation().fetchFormations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: LmsDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 24.w),
                  RoundIconButton(onTap: () {
                    Get.offNamed(Routes.LMS_MY_COURSES);
                  }),
                  SizedBox(width: 45.w),
                  Text(
                    'Liste des formations',
                    style: LmsTextUtil.textRoboto24(),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              FutureBuilder<List<Formation>>(
                future: _formations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Failed to load formations'),
                    );
                  } else if (snapshot.hasData) {
                    final formations = snapshot.data;

                    return GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      children: formations.map((formt) {
                        final videoUrl = "$_videoUrl/${formt.formation}";
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the page that displays other courses
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailView(
                                    id: formt.id
                                    
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(255, 71, 103, 243),
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              child: VideoPlayerScreen(
                                videoUrl: videoUrl,
                                nom: formt.nom,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


