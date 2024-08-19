import 'dart:async';

import 'package:file_upload_app_part2/bloc/document/document_bloc.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'create_file_dialog.dart';

class FilePage extends StatelessWidget {
  FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
      builder: (context, state) {
        final documentIndex = context.read<DocumentBloc>().state.documentId;

        if (state.loading) {
          Timer.periodic(Duration(seconds: 1), (t) {
            t.cancel();
            context.read<FileBloc>().add(GetFiles(documentId: documentIndex));
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
                            BlocProvider.of<FileBloc>(context).add(
                              UserWantsToAddFile(
                                wantToAdd: !state.wantToAdd,
                                isOcr: false,
                              ),
                            );
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
                leading: Icon(Icons.insert_drive_file,
                    color: Colors.grey[700]),
                title: Text(file.file_name),
                subtitle: Text(file.path),
                onTap: () {},
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
    BlocProvider.of<FileBloc>(context).add(UserWantsToAddFile(wantToAdd: false, isOcr: false));
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
