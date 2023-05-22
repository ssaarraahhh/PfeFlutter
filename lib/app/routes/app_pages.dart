import 'package:dronalms/app/modules/Administration/views/DmandeConge.dart';
import 'package:dronalms/app/modules/LmsMyCourses/views/categorie.dart';
import 'package:dronalms/app/modules/contrat.dart';
import 'package:dronalms/app/modules/home/home.dart';
import 'package:get/get.dart';

import '../modules/AttendQuiz/bindings/attend_quiz_binding.dart';
import '../modules/AttendQuiz/views/attend_quiz_view.dart';
import '../modules/Auth/bindings/auth_binding.dart';
import '../modules/Auth/views/login_view.dart';

import '../modules/Calendrier/bindings/events_binding.dart';
import '../modules/Calendrier/views/events_view.dart';
import '../modules/Administration/bindings/knowledge_repository_binding.dart';
import '../modules/LmsDashboard/bindings/lms_dashboard_binding.dart';
import '../modules/LmsDashboard/views/lms_dashboard_view.dart';
import '../modules/LmsMyCourses/bindings/lms_my_courses_binding.dart';

import '../modules/MyProfile/bindings/my_profile_binding.dart';
import '../modules/MyProfile/views/my_profile_view.dart';
import '../modules/Demande/bindings/support_binding.dart';
import '../modules/Demande/views/support_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.LMS_DASHBOARD,
      page: () => LmsDashboardView(),
      binding: LmsDashboardBinding(),
    ),
    GetPage(
      name: _Paths.LMS_MY_COURSES,
      page: () => Categories(),
      binding: LmsMyCoursesBinding(),
      maintainState: true,
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => MyProfileView(),
      binding: MyProfileBinding(),
    ),
    // GetPage(
    //   name: _Paths.COURSE_DETAIL,
    //   page: () => CourseDetailView(),
    //   binding: CourseDetailBinding(),
    // ),
    GetPage(
      name: _Paths.HOME,
      page: () => Home(),
      // binding: MyAchievementsBinding(),
    ),
    GetPage(
      name: _Paths.ADMINISTRATION,
      page: () => Administration(),
      binding: KnowledgeRepositoryBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DEMAND,
      page: () => const Demande(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => EventsView(),
      binding: EventsBinding(),
    ),
    GetPage(
      name: _Paths.CONTRAT,
      page: () => Contract(),
    ),
    // GetPage(
    //   name: _Paths.ATTEND_QUIZ,
    //   page: () => AttendQuizView(),
    //   binding: AttendQuizBinding(),
    // ),
  ];
}
