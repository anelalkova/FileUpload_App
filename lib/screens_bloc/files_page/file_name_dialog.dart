import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/file/file_bloc.dart';

class FileNameDialog extends StatelessWidget{

  final TextEditingController fileNameController = TextEditingController();

  FileNameDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter File Name'),
      content: TextField(
        decoration: const InputDecoration(hintText: "File Name"),
        controller: fileNameController,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () async{
            if(fileNameController.text.isNotEmpty && fileNameController.text != null) {
              BlocProvider.of<FileBloc>(context)
                  .add(SaveFileName(fileName: fileNameController.text));
              Navigator.of(context).pop();
            }else ScaffoldMessenger(child: Text("Please enter file name"));
          },
        ),
      ],
    );
  }


}