import 'dart:async';

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
            context.read<FileBloc>().add(GetFiles(documentId: context
                .read<DocumentBloc>()
                .state
                .documentId));
          }

          return Scaffold(
            appBar: !state.isItemSelected ? AppBar(
              title: const Text('Documents Archive'),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                  child: AnimatedIcon(
                    rotate: state.wantToAdd ? 90 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: IconButton(
                      onPressed: () {
                        _showCreateFileDialog(context, state);
                        BlocProvider.of<FileBloc>(context).add(
                            UserWantsToAddFile(wantToAdd: !state.wantToAdd));
                      },
                      icon: const Icon(FontAwesomeIcons.plus),
                    ),
                  ),
                )
              ],
            ) : AppBar(
              title: const Text('Documents Archive'),
              actions: [
                if(state.isItemSelected)
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: IconButton(
                        onPressed: () {
                          for (int i = 0; i <
                              state.selectedFileIds.length; i++) {
                            BlocProvider.of<FileBloc>(context).add(DeleteFile(
                                id: state.selectedFileIds[i]));
                          }
                          BlocProvider.of<FileBloc>(context).add(
                            ClearSelectedFiles(),
                          );
                          BlocProvider.of<FileBloc>(context).add(
                              SelectFile(isItemSelected: !state.isItemSelected)
                          );
                        },
                        icon: const Icon(Icons.delete),
                      )
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                  child: IconButton(
                      onPressed: () {
                        BlocProvider.of<FileBloc>(context).add(
                            ClearSelectedFiles());
                        BlocProvider.of<FileBloc>(context).add(
                            SelectFile(isItemSelected: !state.isItemSelected));
                      }, icon: const Icon(Icons.arrow_back)),
                )
              ],
              automaticallyImplyLeading: false,
            ),
            body: state.loading ?
            const Center(child: CircularProgressIndicator()) :
            state.allFilesForDocument.isEmpty
                ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 90,
                        height: 90,
                        child: Image.asset(
                          "assets/empty_folder_icon.png",
                          color: const Color.fromRGBO(88, 73, 111, 0.2),
                          colorBlendMode: BlendMode.srcIn,
                        )
                    ),
                    const SizedBox(height: 10),
                    const Text('No files available',
                        style: TextStyle(
                            color: Color.fromRGBO(88, 73, 111, 0.2)))
                  ],
                ))
                : ListView.builder(
              itemCount: state.allFilesForDocument.length,
              itemBuilder: (context, index) {
                final file = state.allFilesForDocument[index];
                return ListTile(
                  leading: state.isItemSelected ? Checkbox(
                      value: state.selectedFileIds.contains(file.id),
                      onChanged: (isSelected) {
                        BlocProvider.of<FileBloc>(context).add(
                            UpdateSelectedIds(
                                fileIds: state.selectedFileIds,
                                newFileId: file.id));
                      }) : null,
                  title: Text(formattedFileName(file.file_name)),
                  subtitle: Text( (file.file_size > 1048576) ?
                      '${_fileSizeInMB(file.file_size).toStringAsPrecision(
                          2)} MB' : '${_fileSizeInKB(file.file_size).toStringAsPrecision(2)} KB'),
                  tileColor: state.selectedFileIds.contains(file.id)
                      ? const Color.fromRGBO(88, 73, 111, 0.2)
                      : const Color.fromRGBO(242, 235, 251, 1),
                  onTap: () {
                    if (!state.isItemSelected) {
                      BlocProvider.of<FileBloc>(context).add(
                          FileIsTapped(fileId: file.id)
                      );
                      BlocProvider.of<FileBloc>(context).add(
                          OpenFile(fileId: file
                              .id));
                      BlocProvider.of<FileBloc>(context).add(
                          SaveFileName(fileName: formattedFileName(file
                              .file_name)));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewPage(),
                        ),
                      );
                    } else {
                      BlocProvider.of<FileBloc>(context).add(
                          UpdateSelectedIds(
                              fileIds: state.selectedFileIds,
                              newFileId: file.id));
                    }
                  },
                  onLongPress: () {
                    if (!state.isItemSelected) {
                      BlocProvider.of<FileBloc>(context).add(
                          UpdateSelectedIds(
                              fileIds: state.selectedFileIds,
                              newFileId: file.id));
                      BlocProvider.of<FileBloc>(context).add(
                          SelectFile(isItemSelected: true));
                    }
                  },
                );
              },
            ),
          );
        },
/*        listenWhen: (previous, current) {
          return ModalRoute
              .of(context)
              ?.isCurrent == false;
        },*/
        listener: (context, state) {
          if (state.errorWhileAddingFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessageWhileAddingFile),
              ),
            );
          }

          if (state.isFileUploadSuccess) {
            context.read<FileBloc>().add(GetFiles(documentId: context
                .read<DocumentBloc>()
                .state
                .documentId));
          }

        //  context.read<FileBloc>().add(ResetFileState());
        }
    );
  }

  Future<void> _showCreateFileDialog(BuildContext context, FileState state) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CreateFileDialog();
      },
    );
    BlocProvider.of<FileBloc>(context).add(UserWantsToAddFile(wantToAdd: false));
  }

  double _fileSizeInMB(double size){
    return size / (1024.0 * 1024.0);
  }

  double _fileSizeInKB(double size){
    return size / 1024.0;
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