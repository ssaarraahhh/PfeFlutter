import 'package:dronalms/app/components/profile_text_field.dart';
import 'package:dronalms/app/modules/MyProfile/controllers/my_profile_controller.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class ProfilePhotoTextField extends StatelessWidget {
  final String imageUrl;
  final bool isProtectedField;
  final IconData preIconData;
  final IconButton suffixIconData;
  final String Function(dynamic value) validator;

  const ProfilePhotoTextField({
    Key key,
    this.imageUrl,
    this.isProtectedField = false,
    this.preIconData,
    this.suffixIconData,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.network(
            imageUrl,
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
              return Icon(
                  Icons.error); // Display an error icon or placeholder image
            },
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ProfileTextField(
            hintText: 'Enter text...',
            isProtectedField: isProtectedField,
            preIconData: preIconData,
            suffixIconData: suffixIconData,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
