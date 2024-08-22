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
            SnackBar(content: Text('Error: ${state.errorMessageWhileAddingDocument}')),
          );
        }

        if(!state.loading){

        }
      },
      builder: (context, state) {
        if (state is DocumentStateInitial) {
          context.read<DocumentBloc>().add(GetDocumentType());

          getUserId().then((userId) {
            if (userId != null) {
              context.read<DocumentBloc>().add(GetDocuments(user_id: userId));
            }
          });

          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
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
                          UserWantsToAddDocument(wantToAdd: !state.wantToAdd));
                    },
                    icon: const Icon(FontAwesomeIcons.plus),
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator()) :
              state.userDocuments.isEmpty
              ? const Center(child: Text('No documents available.'))
              : Stack(
            children: [
              ListView.builder(
                itemCount: state.userDocuments.length,
                itemBuilder: (context, index) {
                  final document = state.userDocuments[index];
                  return ListTile(
                    title: Text(document.description),
                    subtitle: Text(_formatTimestamp(document.timestamp!)),
                    onTap: () {
                      BlocProvider.of<DocumentBloc>(context).add(DocumentIsTapped(
                        documentId: document.id,
                        documentTypeId: document.document_type_id
                      ));
                      BlocProvider.of<FileBloc>(context).add(LoadFiles(loading: true, documentId: document.id, documentTypeId: document.document_type_id));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilePage(),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<DocumentBloc>(context)
                            .add(DeleteDocument(id: document.id));
                      },
                    ),
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
