import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/shared/cubit/cubit.dart';
import 'package:todolist/shared/cubit/states.dart';

Widget dTextFormField(
    {required TextEditingController controller,
    required Widget label,
    required String? Function(String?) validator,
    required Function() onTap,
    InputBorder border = const OutlineInputBorder(),
    var prefixIcon = null,
    bool readOnly = false}) {
  return TextFormField(
    controller: controller,
    decoration:
        InputDecoration(prefixIcon: prefixIcon, label: label, border: border),
    validator: validator,
    onTap: onTap,
    readOnly: readOnly,
  );
}

Widget buildTaskItem(Map model, BuildContext context) {
  return Dismissible(
    key: Key('${model['id']}'),
    onDismissed: (direction){
      AppCubit.get(context).deleteFromDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '${model['date']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
              )),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              )),
        ],
      ),
    ),
  );
}

Widget tasksBuilder ({required List<Map> tasksList}){
      return ConditionalBuilder(
        condition: tasksList.isNotEmpty,
        builder: (context)=>ListView.separated(
            itemBuilder: (context,i)=>buildTaskItem(tasksList[i],context),
            separatorBuilder: (context,i) => const Divider(thickness: 1,indent: 20),
            itemCount: tasksList.length
        ),
        fallback: (context)=> Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list,size: 200,color: Colors.black54,),
                Text('No Tasks Yet , Please Add Some Tasks',style: TextStyle(fontSize: 18,color: Colors.black54),)
              ],
            )
        ),
  );
}
