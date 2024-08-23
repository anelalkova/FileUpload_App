import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/file/file_bloc.dart';

class ExitPageDialog extends StatelessWidget {
  const ExitPageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text("Abandon work?"),
          content: const Text("If you leave this page, all work will be lost."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                BlocProvider.of<FileBloc>(context).add(WantsToExitPage(wantsToExit: false));
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                BlocProvider.of<FileBloc>(context).add(WantsToExitPage(wantsToExit: true));
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
