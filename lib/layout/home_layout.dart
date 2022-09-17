import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/shared/cubit/cubit.dart';
import 'package:todolist/shared/cubit/states.dart';

import '../shared/components/components.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  





  // @override
  // void initState() {
  //   createDatabase();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, Object? state) {  },
        builder: (BuildContext context, state) {
          var cubit = AppCubit.get(context);
          addTask() {
            if (formKey.currentState!.validate()) {
              cubit.insertToDatabase(title: titleController.text,date: dateController.text,time: timeController.text).then((value) {
                Navigator.of(context).pop();
                cubit.closeBottomSheetState();
                // setState(() {});
                // fabIcon = Icons.edit;
                // isBottomSheetShown = false;
              });
            } else {
              print("not valid");
            }
          }
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fabIcon),
                onPressed: () {
                  if (cubit.isBottomSheetShown == false) {
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
                      cubit.closeBottomSheetState();
                      //setState(() {});
                      // fabIcon = Icons.edit;
                      // isBottomSheetShown = false;
                      print(value);
                    });
                    cubit.openBottomSheetState();
                    //setState(() {});
                    // fabIcon = Icons.add;
                    // isBottomSheetShown = true;
                  } else {
                    addTask();
                  }
                }),

            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              currentIndex: cubit.currentIndex,
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
            body: cubit.screens[cubit.currentIndex],
          );
        } ,
      ),
    );
  }



}


