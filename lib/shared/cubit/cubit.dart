import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todolist/modules/done_tasks/done_tasks_screen.dart';
import 'package:todolist/modules/new_tasks/new_tasks_screen.dart';
import 'package:todolist/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> tasksList = [];
  List<Map> newTasksList = [];
  List<Map> archivedTasksList = [];
  List<Map> doneTasksList = [];


  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
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
      getDataFromDatabase(database);
      print('db opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Test(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database!);
        print("$value inserted successfully");
      }).catchError((error) {
        print('Error When Inserting Row : ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(Database database) async {
    emit(AppGetDatabaseLoadingState());
    await database.rawQuery('SELECT * FROM Test').then((value) {
      tasksList = [];
      newTasksList = [];
      doneTasksList = [];
      archivedTasksList = [];

      tasksList = value;
      print(tasksList);
      tasksList.forEach((element) {
        if(element['status']=='archived'){
          archivedTasksList.add(element);
        }
        if(element['status']=='done'){
          doneTasksList.add(element);
        }
        if(element['status']=='new'){
          newTasksList.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({required String status , required int id}){
    database?.rawUpdate('UPDATE Test SET status = ?  WHERE id = ?',
                      ['$status',id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database!);
    });
  }
  
  void deleteFromDatabase ({required int id}){
    database?.rawDelete('DELETE FROM Test WHERE id = ?',[id]).then((value) {
      emit(AppDeleteDatabaseState());
      print('Deleted Successfully');
      getDataFromDatabase(database!);
    });
  }

  void closeBottomSheetState() {
    fabIcon = Icons.edit;
    isBottomSheetShown = false;
    emit(AppCloseBottomSheet());
  }

  void openBottomSheetState() {
    fabIcon = Icons.add;
    isBottomSheetShown = true;
    emit(AppOpenBottomSheet());
  }
}
