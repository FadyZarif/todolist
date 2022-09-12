
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todolist/shared/components/components.dart';
import 'package:todolist/shared/components/constants.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tasks'),
      ),
      body: ConditionalBuilder(
          condition: tasksList.isNotEmpty,
          builder: (context)=>ListView.separated(
              itemBuilder: (context,i)=>buildTaskItem(tasksList[i]),
              separatorBuilder: (context,i) => const Divider(thickness: 1,indent: 20),
              itemCount: tasksList.length
          ),
          fallback: (context)=>const Center(child: CircularProgressIndicator()),
      )
    );
  }
}
