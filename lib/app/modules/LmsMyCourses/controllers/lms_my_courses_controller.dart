import 'package:dronalms/app/models/categorie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/api_categorie.dart';

class LmsMyCoursesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final countTab = 0.obs;
 TabController tabController;
  Future<List<Categorie>> categories;

  @override
  void onInit() {
    super.onInit();
    categories = ApiCategorie().fetchCategories();
    print(categories);
    tabController = TabController(initialIndex: 0, length: 6, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
