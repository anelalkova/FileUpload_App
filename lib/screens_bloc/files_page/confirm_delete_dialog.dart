import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm delete?", textAlign: TextAlign.center),
      content: Text("Are you sure you want to delete \"${context
          .read<FileBloc>()
          .state
          .fileName}\"?\nYou can't undo this action.",
          textAlign: TextAlign.center),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(233, 216, 243, 0.4),
              ),
              child: TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(233, 216, 243, 0.4),
              ),
              child: TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  BlocProvider.of<FileBloc>(context).add(DeleteFile(id: context
                      .read<FileBloc>()
                      .state
                      .fileId));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
