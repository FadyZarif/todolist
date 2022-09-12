import 'package:flutter/material.dart';

Widget dTextFormField({
  required TextEditingController controller,
  required Widget label ,
  required String? Function(String?) validator,
  required Function() onTap,
  InputBorder border = const OutlineInputBorder(),
  var prefixIcon = null,
  bool readOnly = false


})
{
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        prefixIcon: prefixIcon,
        label: label,
        border: border
    ),
    validator: validator,
    onTap: onTap,
    readOnly: readOnly,

  );
}

Widget buildTaskItem(Map model){
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
         CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        const SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:  [
            Text('${model['title']}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 5),
            Text('${model['date']}',style: TextStyle(fontSize: 14,color: Colors.grey),)
          ],
        )
      ],
    ),
  );
}
