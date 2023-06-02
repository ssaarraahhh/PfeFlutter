import 'package:dronalms/app/components/custom_appbar.dart';
import 'package:dronalms/app/components/lms_drawer.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/models/objectif.dart';
import 'package:dronalms/app/models/tasks.dart';
import 'package:dronalms/app/services/api_employe.dart';
import 'package:dronalms/app/services/api_objectif.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Objectif> _objectifs = [];
  Employe _employe;
  final currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
    final currentDate = DateTime.now();
    //final cc = currentDate.toString();
    getTasksForDay(currentDate);
  }

  DateTime smallestDate;
  DateTime largestDate;
  DateTime startpause;
  DateTime endpause;

  String smallestDates = ""; // Assign default value
  String largestDates = ""; // Assign default value
  String startpauses = ""; // Assign default value
  String endpauses = ""; // Assign default value

  Future<List<Task>> getTasksForDay(DateTime day) async {
    final employeTasks = await ApiEmploye().fetchtasks();

    List<Task> tasksForDay = [];

    for (var task in employeTasks) {
      if (isSameDay(task.dateDebut, day)) {
        tasksForDay.add(task);

        if (task.dateDebut != null) {
          if (smallestDate == null || task.dateDebut.isBefore(smallestDate)) {
            smallestDate = task.dateDebut;
            smallestDates = smallestDate.toString().substring(11, 16);
          }
        }

        if (task.dateFin != null) {
          if (largestDate == null ||
              task.dateFin.isAfter(largestDate) ||
              task.dateDebut == null) {
            largestDate = task.dateFin;
            largestDates = largestDate.toString().substring(11, 16);
          }
        }

        if (task.typeTache == "pause") {
          startpauses = task.dateDebut != null
              ? task.dateDebut.toString().substring(11, 16)
              : "";
          endpauses = task.dateFin != null
              ? task.dateFin.toString().substring(11, 16)
              : "";
        } else {
          startpauses = "";
          endpauses = "";
        }
      }
    }

    return tasksForDay;
  }

  Future<void> _loadData() async {
    try {
      final objectifs = await ApiObjectif().fetchObjectif();
      final employe = await ApiEmploye().fetchEmployeById();

      final currentDate = DateTime.now();
      List<Objectif> getObjectifsDueToday(List<Objectif> objectifs) {
        final validObjectifs = <Objectif>[];

        for (final objectif in objectifs) {
          if (objectif.dateFin.isAfter(currentDate) ||
              (objectif.dateFin.isAtSameMomentAs(currentDate) &&
                      objectif.dateDebut.isBefore(currentDate)) &&
                  objectif.idMagasin == employe.idMagasin) {
            validObjectifs.add(objectif);
          }
        }

        return validObjectifs;
      }

      setState(() {
        _employe = employe;
        _objectifs = getObjectifsDueToday(objectifs);
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: Colors.transparent),
      drawer: LmsDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_employe != null) ...[
                      Center(
                        child: Text(
                          "Bonjour ! ${_employe.prenom}",
                          style: LmsTextUtil.textPoppins24(),
                        ),
                      ),
                    ],
                    Center(
                      child: Text(
                        "Ajourd'hui le ${currentDate.day}-${currentDate.month}-${currentDate.year}",
                        style: LmsTextUtil.textPoppins24(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    if (_employe != null) ...[
                      Center(
                        child: Container(
                          height: 200,
                          width: 760,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 157, 98, 173),
                                Color.fromARGB(255, 234, 174, 254)
                              ], // Define the gradient colors
                              begin: Alignment
                                  .topLeft, // Define the start point of the gradient
                              end: Alignment
                                  .bottomRight, // Define the end point of the gradient
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                              bottom: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                subtitle: Row(
                                  children: [
                                    Column(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 40.0,
                                            left: 2.0,
                                          ),
                                          child: Icon(
                                            Icons.coffee_rounded,
                                            color: Color.fromARGB(
                                                255, 215, 208, 208),
                                            size: 60,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 40.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Votre pause à : ",
                                            style: LmsTextUtil.textManrope20(),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "$startpauses  - $endpauses ",
                                            style: LmsTextUtil.textManrope20(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      height: 10.0,
                                      color: Color.fromARGB(255, 5, 5,
                                          5), // Set the color of the divider
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              16.0), // Adjust the margin as needed
                                    ),
                                    Column(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 2.0, top: 10),
                                          child: Icon(
                                            Icons.watch_later_outlined,
                                            color: Color.fromARGB(
                                                255, 214, 211, 211),
                                            size: 60,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Votre Horaire de Travail: ",
                                            style: LmsTextUtil.textManrope20(),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "$smallestDates  - $largestDates ",
                                            style: LmsTextUtil.textManrope20(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Add a divider after the ListTile
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16.0),

                      // SizedBox(height: 16.0),
                    ],
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: _objectifs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final colors = [
                          Color.fromARGB(255, 90, 164, 224),
                          Color.fromARGB(255, 135, 231, 138),
                          Color.fromARGB(255, 223, 176, 106),
                          Color.fromARGB(255, 212, 140, 164),
                          Color.fromARGB(255, 222, 159, 233),
                        ];
                        final color = colors[index % colors.length];
                        final objectif = _objectifs[index];
                        return Container(
                          width: 350,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: color, // Set the border color here
                              width: 2,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(50),
                              bottom: Radius.circular(50),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  objectif.but,
                                  style: TextStyle(
                                    fontSize: 15.sp, // Set the text size here
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                    // Set the text weight here
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              subtitle: Center(
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 50.0,
                                            bottom: 40,
                                          ),
                                          child: Icon(
                                            Icons.notifications_active_outlined,
                                            color: color,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Du : ${objectif.dateDebut.toString().substring(0, 10)}',
                                            style: TextStyle(
                                              fontSize: 16
                                                  .sp, // Set the text size here
                                              fontWeight: FontWeight.w500,
                                              color: color,
                                              // Set the text weight here
                                            ),
                                          ),
                                          Text(
                                            'Au : ${objectif.dateFin.toString().substring(0, 10)}',
                                            style: TextStyle(
                                              fontSize: 16
                                                  .sp, // Set the text size here
                                              fontWeight: FontWeight.w500,
                                              color: color,
                                              // Set the text weight here
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 10.0,
                        color: Color.fromARGB(0, 12, 12, 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
