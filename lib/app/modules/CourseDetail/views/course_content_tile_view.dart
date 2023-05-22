import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseContentTile extends StatefulWidget {
  const CourseContentTile({Key key, this.fichier}) : super(key: key);
  final String fichier;

  @override
  State<CourseContentTile> createState() => _CourseContentTileState();
}

class _CourseContentTileState extends State<CourseContentTile> {
  bool showDropDown = false;
  String Url = "$URL/Files/getFile";

  @override
  initState() {
    super.initState();
    showDropDown = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.menu_book_sharp,
                color: LmsColorUtil.primaryThemeColor,
                size: 20,
              ),
              title: Text(
                "Cours 1",
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
              onTap: () async {
                var url = "${Url}/${widget.fichier}";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
