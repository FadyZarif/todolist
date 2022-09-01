import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todolist/modules/done_tasks/done_tasks_screen.dart';
import 'package:todolist/modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
            setState(() {
              currentIndex = index;
            });
        },
        currentIndex: currentIndex,
        items: [
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
}

  void createDatabase() async {
    Database database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version){
        print('db created');
        database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {

              print('table created');
        }).catchError((error){

          print('Error When Creating Table : ${error.toString()}');
        });
      },
      onOpen: (database){
          print('db opened');
      }
    );
  }

  void insertToDatabase(){}
