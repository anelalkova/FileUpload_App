
import 'package:file_upload_app_part2/screens_bloc/files_page/files_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../bloc/document/document_bloc.dart';
import '../../bloc/file/file_bloc.dart';
import 'create_document_dialog.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state.errorWhileAddingDocument) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                'Error: ${state.errorMessageWhileAddingDocument}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: !state.isItemSelected ? AppBar(
            title: const Text("Documents Archive"),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                child: AnimatedIcon(
                  rotate: state.wantToAdd ? 90 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    onPressed: () {
                      _showCreateDocumentDialog(context, state);
                      BlocProvider.of<DocumentBloc>(context).add(
                          UserWantsToAddDocument(wantToAdd: !state
                              .wantToAdd));
                    },
                    icon: const Icon(FontAwesomeIcons.plus),
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: false,
          ) : AppBar(
            title: const Text("Documents Archive"),
            actions: [
              if (state.isItemSelected)
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        for(int i=0; i<state.selectedDocumentIds.length; i++){
                          BlocProvider.of<DocumentBloc>(context).add(DeleteDocument(id: state.selectedDocumentIds[i]));
                        }
                        BlocProvider.of<DocumentBloc>(context).add(
                          ClearSelectedItems(),
                        );
                        BlocProvider.of<DocumentBloc>(context).add(
                            SelectItem(isItemSelected: !state.isItemSelected)
                        );
                      },
                    )
                ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                  child:  IconButton(
                      onPressed: () {
                        BlocProvider.of<DocumentBloc>(context).add(
                          ClearSelectedItems(),
                        );
                        BlocProvider.of<DocumentBloc>(context).add(
                            SelectItem(isItemSelected: !state.isItemSelected)
                        );
                      },
                      icon: const Icon(Icons.arrow_back)
                  ),
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : state.userDocuments.isEmpty
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
                      style: TextStyle(color: Color.fromRGBO(88, 73, 111, 0.2)))
                ],
              ))
              : Stack(
            children: [
              ListView.builder(
                itemCount: state.userDocuments.length,
                itemBuilder: (context, index) {
                  final document = state.userDocuments[index];
                  return ListTile(
                    leading: state
                        .isItemSelected
                        ? Checkbox(
                      value: state.selectedDocumentIds.contains(document.id),
                      onChanged: (isSelected) {
                        BlocProvider.of<DocumentBloc>(context).add(
                          UpdateSelectedDocumentIds(
                              documentIds: state.selectedDocumentIds,
                              newDocumentId: document.id));
                      }) : null,
                    title: Text(document.description),
                    subtitle: Text(_formatTimestamp(document.timestamp!)),
                    tileColor: state.selectedDocumentIds.contains(document.id)
                        ? const Color.fromRGBO(88, 73, 111, 0.2)
                        : const Color.fromRGBO(242, 235, 251, 1),
                    onTap: () {
                      if (!state.isItemSelected) {
                        BlocProvider.of<DocumentBloc>(context).add(
                            DocumentIsTapped(
                                documentId: document.id,
                                documentTypeId:
                                document.document_type_id));
                        BlocProvider.of<FileBloc>(context).add(
                            LoadFiles(
                                loading: true,
                                documentId: document.id,
                                documentTypeId:
                                document.document_type_id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FilePage(),
                          ),
                        );
                      } else {
                        BlocProvider.of<DocumentBloc>(context).add(
                            UpdateSelectedDocumentIds(
                                documentIds:
                                state.selectedDocumentIds,
                                newDocumentId: document.id));
                      }
                    },
                    onLongPress: () {
                      if (!state.isItemSelected) {
                        BlocProvider.of<DocumentBloc>(context).add(
                            UpdateSelectedDocumentIds(
                                documentIds:
                                state.selectedDocumentIds,
                                newDocumentId: document.id));
                        BlocProvider.of<DocumentBloc>(context)
                            .add(SelectItem(isItemSelected: true));
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('d MMM yyyy, HH:mm').format(timestamp);
  }

  Future<void> _showCreateDocumentDialog(BuildContext context, DocumentState state) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CreateDocumentDialog();
      },
    );
    BlocProvider.of<DocumentBloc>(context).add(UserWantsToAddDocument(wantToAdd: false));
  }

  Future<int?> getUserId() async {
    const storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'user_id');
    return userIdString != null ? int.tryParse(userIdString) : null;
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
