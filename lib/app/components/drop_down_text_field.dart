import 'package:dronalms/app/modules/Demande/controllers/support_controller.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class MyDropDownFormField extends GetView<SupportController> {
  const MyDropDownFormField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: controller.issueType.value,
      icon: const Icon(Icons.keyboard_arrow_down),
      style: LmsTextUtil.textPoppins14(),
      items: const [
        DropdownMenuItem(
          value: 'Congé',
          child: Text("Congé"),
        ),
        DropdownMenuItem(
          value: 'Absence',
          child: Text("Absence"),
        ),
       
      ],
      onChanged: (String value) {
        controller.issueType.value = value;
      },
      decoration: InputDecoration(
        labelText: "type",
        labelStyle: LmsTextUtil.textPoppins14(),
        enabled: true,
        prefixIcon: const Icon(
          Icons.error_outline_outlined,
          color: LmsColorUtil.primaryThemeColor,
        ),
        // suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
        contentPadding: EdgeInsets.only(left: 20.w),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.sp),
          borderSide: const BorderSide(color: LmsColorUtil.greyColor10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.sp),
          borderSide: const BorderSide(color: LmsColorUtil.greyColor4, width: 1),
        ),
      ),
    );
  }
}

class DropDownField extends GetView<SupportController> {
  const DropDownField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField(builder: (FormFieldState state) {
      return DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: " Type",
            labelStyle: LmsTextUtil.textPoppins14(),
            enabled: true,
            prefixIcon: const Icon(
              Icons.error_outline_outlined,
              color: LmsColorUtil.primaryThemeColor,
            ),
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            contentPadding: EdgeInsets.only(left: 30.w),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.sp),
              borderSide: const BorderSide(color: LmsColorUtil.greyColor10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.sp),
              borderSide: const BorderSide(color: LmsColorUtil.greyColor4, width: 1),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              DropdownButton(
                isExpanded: true,
                value: controller.issueType.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: const [
                  DropdownMenuItem(
                    value: 'Congé',
                    child: Text("Congé"),
                  ),
                  DropdownMenuItem(
                    value: 'Absence',
                    child: Text("Absence"),
                  ),
                 
                ],
                onChanged: (String value) {
                  controller.issueType.value = value;
                },
              );
            },
            child: const Text("Issue Type"),
          ),
        ),
      );
    });
  }
}

class DropDownTextField extends GetView<SupportController> {
  const DropDownTextField({
    Key key,
    this.hintText,
    // required this.textEditingController,
    this.obscureText = false,
     this.preIconData,
  }) : super(key: key);
  final String hintText;

  final bool obscureText;
  final IconData preIconData;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
    
      textAlign: TextAlign.start,
      style: LmsTextUtil.textPoppins14(),
      obscureText: obscureText,
      enableInteractiveSelection: false,
      // enabled: false,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: LmsTextUtil.textPoppins14(),
        prefixIcon: Icon(preIconData, color: LmsColorUtil.primaryThemeColor),
        suffixIcon: GestureDetector(
          onTap: () {
            DropdownButton(
              isExpanded: true,
              value: controller.issueType.value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                DropdownMenuItem(
                  value: 'Congé',
                  child: Text("Congé"),
                ),
                DropdownMenuItem(
                  value: 'Absence',
                  child: Text("Absence"),
                ),
               
              ],
              onChanged: (String value) {
                controller.issueType.value = value;
              },
            );
          },
          child: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        contentPadding: EdgeInsets.only(left: 30.w),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.sp),
          borderSide: const BorderSide(color: LmsColorUtil.greyColor10),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.sp),
            borderSide: const BorderSide(color: LmsColorUtil.greyColor4, width: 1)),
      ),
    );
  }
}
