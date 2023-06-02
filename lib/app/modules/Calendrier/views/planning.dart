import 'package:dronalms/app/models/tasks.dart';
import 'package:dronalms/app/services/api_employe.dart';
import 'package:dronalms/app/services/api_taches.dart';

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Planning extends StatefulWidget {
  const Planning({Key key}) : super(key: key);

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  DateTime _focusedDay;
  DateTime _firstDay;
  DateTime _lastDay;

  DateTime _selectedDay;
  CalendarFormat _calendarFormat;

  ApiEmploye apiEmploye = ApiEmploye();

  Future<void> updatetask(Task t) async {
    apiTaches().updatetache(t.id, t);
  }

  Future<List<Task>> getTasksForDay(DateTime day) async {
    final employeTasks = await apiEmploye.fetchtasks();

    List<Task> tasksForDay = [];

    for (var task in employeTasks) {
      if (task.frequence == "daily" ||
          task.frequence == "weekly" ||
          task.frequence == "monthly" ||
          task.frequence == "yearly") {
        // Generate all occurrences of the task within the given period
        List<DateTime> occurrences = generateTaskOccurrences(task);

        // Check if any of the occurrences fall on the specified day
        if (occurrences.any((occurrence) => isSameDay(occurrence, day))) {
          tasksForDay.add(task);
        }
      } else if (isSameDay(task.dateDebut, day)) {
        tasksForDay.add(task);
      }
    }
    return tasksForDay;
  }

  List<DateTime> generateTaskOccurrences(Task task) {
    List<DateTime> occurrences = [];
    DateTime currentDate = task.dateDebut;
    while (currentDate.isBefore(task.dateFin)) {
      occurrences.add(currentDate);
      switch (task.frequence) {
        case "daily":
          currentDate = currentDate.add(Duration(days: task.intervalle));
          break;
        case "weekly":
          currentDate = currentDate.add(Duration(days: task.intervalle * 7));
          break;
        case "monthly":
          currentDate = DateTime(currentDate.year,
              currentDate.month + task.intervalle, currentDate.day);
          break;
        case "yearly":
          currentDate = DateTime(currentDate.year + task.intervalle,
              currentDate.month, currentDate.day);
          break;
      }
    }
    return occurrences;
  }

  Future<List<Widget>> _buildEventsForDay(DateTime day) async {
    List<Widget> events = [];

    List<Task> tasks = await getTasksForDay(day);

    for (int i = 0; i < tasks.length; i++) {
      events.add(SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 254, 254),
              borderRadius: BorderRadius.circular(29.0),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 77, 111, 233).withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: tasks[i].frequence != "daily" &&
                          tasks[i].frequence != "weekly" &&
                          tasks[i].frequence != "yearly"
                      ? Checkbox(
                          value: tasks[i].etat == "test",
                          onChanged: (bool value) {
                            print("*****************${tasks[i].etat}");
                            print("*****************$value");
                            setState(() {
                              if (value == true) {
                                tasks[i].etat = "test";
                              } else {
                                tasks[i].etat = "to do";
                              }

                              updatetask(tasks[i]);
                            });
                          },
                        )
                      : null,
                  title: Row(
                    children: [
                      Text(
                        tasks[i].titre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          width:
                              50), // add some spacing between the title and trailing text
                      Text(
                        "${tasks[i].dateDebut.toString().substring(10, 16)} - ${tasks[i].dateFin.toString().substring(10, 16)}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    tasks[i].description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    }

    return events;
  }

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TableCalendar(
              locale: 'fr_FR',
              availableCalendarFormats: const {
                CalendarFormat.week: 'Semaine',
                CalendarFormat.month: 'Mois',
                CalendarFormat.twoWeeks: '2 Semaines',
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (
                selectedDay,
                focusedDay,
              ) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                height: 350,
                width: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<Widget>>(
                    future: _buildEventsForDay(_selectedDay),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => snapshot.data[index],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
