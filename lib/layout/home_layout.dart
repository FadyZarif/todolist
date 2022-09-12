import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todolist/modules/done_tasks/done_tasks_screen.dart';
import 'package:todolist/modules/new_tasks/new_tasks_screen.dart';

import '../shared/components/components.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  Database? database;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();


  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  addTask() {
    if (formKey.currentState!.validate()) {
      insertToDatabase(title: titleController.text,date: dateController.text,time: timeController.text).then((value) {
        Navigator.of(context).pop();
        setState(() {});
        fabIcon = Icons.edit;
        isBottomSheetShown = false;
      });
    } else {
      print("not valid");
    }
  }

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: Icon(fabIcon),
          onPressed: () {
            if (isBottomSheetShown == false) {
              scaffoldKey.currentState?.showBottomSheet((context) {
                return Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        dTextFormField(
                            controller: titleController,
                            label: Text('Task Title'),
                            prefixIcon: Icon(Icons.title),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter Title';
                              } else
                                null;
                            },
                            onTap: () {}),
                        SizedBox(
                          height: 20,
                        ),
                        dTextFormField(
                            controller: timeController,
                            label: Text('Task Time'),
                            prefixIcon: Icon(Icons.access_time_outlined),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter Time';
                              } else
                                null;
                            },
                            readOnly: true,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text =
                                    value!.format(context).toString();
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        dTextFormField(
                            controller: dateController,
                            label: Text('Task Date'),
                            prefixIcon: Icon(Icons.edit_calendar_outlined),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter Date';
                              } else
                                null;
                            },
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2025))
                                  .then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            }),
                      ],
                    ),
                  ),
                );
              }).closed.then((value) {
                setState(() {
                  fabIcon = Icons.edit;
                  isBottomSheetShown = false;
                  print(value);
                });
              });
              setState(() {});
              fabIcon = Icons.add;
              isBottomSheetShown = true;
            } else {
              addTask();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }

  void createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('db created');
      database
          .execute(
              'CREATE TABLE Test(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('Error When Creating Table : ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database).then((value) {
        tasksList = value;
        print(tasksList);
      });
      print('db opened');
    });
  }

  Future insertToDatabase({required String title, required String time, required String date,}) async {
    return await database?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Test(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value inserted successfully");
      }).catchError((error) {
        print('Error When Inserting Row : ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(Database database) async {

   return await database.rawQuery('SELECT * FROM Test');

  }
}
