import 'dart:io'; // Import for File operations
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/files_page/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileViewPage extends StatelessWidget {
  FileViewPage({super.key});

  final TextEditingController editFileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state.wantsToEdit) {
              BlocProvider.of<FileBloc>(context)
                  .add(WantsToEditFileName(wantsToEdit: false));
              return false;
            }
            return true;
          },
          child: GestureDetector(
            onTap: () {
              if (state.wantsToEdit) {
                BlocProvider.of<FileBloc>(context)
                    .add(WantsToEditFileName(wantsToEdit: false));
              }
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: state.wantsToEdit
                    ? TextField(
                  controller: editFileNameController,
                  autofocus: true,
                  onSubmitted: (newFileName) {
                    BlocProvider.of<FileBloc>(context)
                        .add(EditFileName(newFileName: newFileName));
                  },
                )
                    : Text(state.fileName),
                actions: [
                  IconButton(
                    icon: Icon(state.wantsToEdit ? Icons.check : Icons.edit),
                    onPressed: () {
                      if (state.wantsToEdit) {
                        BlocProvider.of<FileBloc>(context).add(EditFileName(
                            newFileName: editFileNameController.text));
                      } else {
                        BlocProvider.of<FileBloc>(context)
                            .add(WantsToEditFileName(wantsToEdit: true));
                      }
                    },
                  ),
                ],
              ),
              body: state.isFileLoaded
                  ? const Center(child: CircularProgressIndicator())
                  : state.pdfFile.isEmpty
                  ? const Center(child: Text('Error fetching file'))
                  : LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      PDFView(
                        pdfData: state.pdfFile,
                        swipeHorizontal: true,
                        enableSwipe: true,
                        onPageChanged: (page, total) {
                          // Optional: Handle page change
                        },
                        onViewCreated: (PDFViewController pdfViewController) {
                          // Optional: Handle PDF view creation
                        },
                        onError: (error) {
                          // Optional: Handle errors
                        },
                        onPageError: (page, error) {
                          // Optional: Handle page-specific errors
                        },
                      ),
                    ],
                  );
                },
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 70,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    child: BottomAppBar(
                      shape: const CircularNotchedRectangle(),
                      color: const Color.fromRGBO(233, 216, 243, 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 2),
                              child: SizedBox(
                                  width: 21,
                                  height: 21,
                                  child: Image.asset(
                                    "assets/modify_icon.png",
                                    color: const Color.fromRGBO(88, 73, 111, 1),
                                    colorBlendMode: BlendMode.srcIn,
                                  ))),
                          IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                print(state.fileId);
                                BlocProvider.of<FileBloc>(context).add(DownloadFile(downloadFileId: state.fileId));
                              }),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteFileDialog(context, state);
                              }),
                          IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () async {
                                BlocProvider.of<FileBloc>(context).add(ShareFile());
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.wantsToEdit) {
          editFileNameController.text = state.fileName;
        }

        if (state.errorWhileLoadingFile) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error: ${state.errorMessageWhileLoadingFile}')));
        }

        if (state.updateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.updateSuccessMessage)),
          );
        }
      },
    );
  }

  Future<void> _showDeleteFileDialog(
      BuildContext context, FileState state) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return const ConfirmDeleteDialog();
        });
  }
}
