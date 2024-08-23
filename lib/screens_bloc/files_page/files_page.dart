import 'dart:async';
import 'dart:math';

import 'package:file_upload_app_part2/bloc/document/document_bloc.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/files_page/file_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'create_file_dialog.dart';

class FilePage extends StatelessWidget {
  const FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
      builder: (context, state) {
        if (state.loading) {
          int r = Random().nextInt(3);
          Timer.periodic(Duration(seconds: r), (t) {
            t.cancel();
            context.read<FileBloc>().add(GetFiles(documentId: context.read<DocumentBloc>().state.documentId));
          });
        }

        return Scaffold(
          backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
          appBar: AppBar(
            actions: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Documents Archive',
                        style: TextStyle(
                          color: Color.fromRGBO(88, 73, 111, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      AnimatedIcon(
                        rotate: state.wantToAdd ? 90 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          onPressed: () {
                            _showCreateFileDialog(context, state);
                            BlocProvider.of<DocumentBloc>(context).add(
                                UserWantsToAddDocument(wantToAdd: !state.wantToAdd));
                          },
                          icon: const Icon(FontAwesomeIcons.plus),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
            automaticallyImplyLeading: false,
          ),
          body: state.loading ?
          const Center(child: CircularProgressIndicator()) :
          state.allFilesForDocument.isEmpty
              ? const Center(child: Text('No files available'))
              : ListView.builder(
            itemCount: state.allFilesForDocument.length,
            itemBuilder: (context, index) {
              final file = state.allFilesForDocument[index];
              return ListTile(
                leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
                title: Text(formattedFileName(file.file_name)),
                subtitle: Text('${_fileSizeInMB(file.file_size).toStringAsPrecision(2)} MB'),
                onTap: () {
                  BlocProvider.of<FileBloc>(context).add(FileIsTapped(fileId: file.id));
                  BlocProvider.of<FileBloc>(context).add(OpenFile(fileId: file.id));
                  BlocProvider.of<FileBloc>(context).add(SaveFileName(fileName: formattedFileName(file.file_name)));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileViewPage(),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      listener: (context, state) {
        if (state.errorWhileAddingFile) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessageWhileAddingFile}'),
            ),
          );
        }

        if(state.isFileUploadSuccess){
          context.read<FileBloc>().add(GetFiles(documentId: context.read<DocumentBloc>().state.documentId));
        }
      },
    );
  }

  Future<void> _showCreateFileDialog(BuildContext context, FileState state) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CreateFileDialog();
      },
    );
  }

  double _fileSizeInMB(double size){
    return size / (1024.0 * 1024.0);
  }

  String formattedFileName(String name){
    var parts = name.split("_");
    return parts[0];
  }
}

class AnimatedIcon extends StatelessWidget {
  final double rotate;
  final Duration duration;
  final Widget child;

  const AnimatedIcon({
    super.key,
    required this.rotate,
    required this.duration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: rotate / 360,
      duration: duration,
      child: child,
    );
  }
}