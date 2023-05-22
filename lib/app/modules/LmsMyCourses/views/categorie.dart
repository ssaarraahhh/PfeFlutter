import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/categorie.dart';
import 'package:dronalms/app/services/api_categorie.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/lms_drawer.dart';
import 'formation.dart';

class Categories extends StatefulWidget {
  const Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<List<Categorie>>_categories;
  // Future<List<Formation>>? _formations;
  String Url = "$URL/Files/getVideo";

  @override
  void initState() {
    super.initState();
    _categories = ApiCategorie().fetchCategories();
    //_formations = ApiFormation().fetchFormations();
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
              Container(
                padding: EdgeInsets.only(
                    left: 18.w, top: 10.h, right: 18.w, bottom: 10.h),
                alignment: Alignment.topLeft,
                child: Text('les thèmes des formations',
                    style: LmsTextUtil.textRoboto24()),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(

                    //   style: TextStyle(
                    //     fontSize: 18.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
              FutureBuilder<List<Categorie>>(
                future: _categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final categories = snapshot.data;
                    return GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the page that displays other courses
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Cours(id: category.id)),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: LmsColorUtil.primaryThemeColor,
                                  width: 0.4,
                                ),
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 350.h,
                                    // width: ScreenUtil().screenWidth,
                                    width: 900.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20.sp),
                                    ),
                                    child:
                                        Image.network("$Url/${category.photo}"),
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: LmsColorUtil.primaryThemeColor,
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(20.sp),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          category.nom,
                                          style: LmsTextUtil.textManrope24()
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Failed to load categories'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
