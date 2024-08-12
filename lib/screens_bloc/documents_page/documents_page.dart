import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../bloc/document/document_bloc.dart';
import '../../models/document.dart';
import '../../models/document_type.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
      appBar: AppBar(
        title: const Text(
          'Documents Archive',
          style: TextStyle(
            color: Color.fromRGBO(88, 73, 111, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<int?>(
        future: getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No User ID found.'));
          }

          final int userId = snapshot.data!;

          BlocProvider.of<DocumentBloc>(context).add(GetDocuments(user_id: userId));

          return BlocConsumer<DocumentBloc, DocumentState>(
            listener: (context, state) {
              if (state.errorWhileAddingDocument) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.errorMessageWhileAddingDocument}')),
                );
              }
            },
            builder: (context, state) {
              if (state is DocumentStateInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.userDocuments.isEmpty) {
                return const Center(child: Text('No documents available.'));
              }

              return ListView.builder(
                itemCount: state.userDocuments.length,
                itemBuilder: (context, index) {
                  final document = state.userDocuments[index];
                  return ListTile(
                    title: Text(document.description),
                    subtitle: Text(_formatTimestamp(document.timestamp!)),
                    onTap: () {
                      BlocProvider.of<DocumentBloc>(context)
                          .add(DocumentIsTapped(index: index, documentId: document.id));
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDocumentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('d MMM yyyy, HH:mm').format(timestamp);
  }

  Future<void> _showCreateDocumentDialog(BuildContext context) async {
    final TextEditingController documentNameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final documentTypes = await _fetchDocumentTypes(context);

    DocumentTypeModel? selectedDocumentType = documentTypes.isNotEmpty ? documentTypes.first : null;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: documentNameController,
                      decoration: const InputDecoration(
                        labelText: 'Document Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DocumentTypeModel>(
                      value: selectedDocumentType,
                      decoration: const InputDecoration(
                        labelText: 'Document Type',
                      ),
                      items: documentTypes.map((DocumentTypeModel documentType) {
                        return DropdownMenuItem<DocumentTypeModel>(
                          value: documentType,
                          child: Text(documentType.title),
                        );
                      }).toList(),
                      onChanged: (DocumentTypeModel? newValue) {
                        selectedDocumentType = newValue;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a document type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.cancel,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState != null &&
                                formKey.currentState!.validate()) {
                              final document = DocumentModel(
                                id: 0,
                                description: documentNameController.text,
                                user_id: int.parse(getUserId() as String),
                                document_type_id: selectedDocumentType!.id,
                                timestamp: DateTime.now(),
                              );
                              BlocProvider.of<DocumentBloc>(context)
                                  .add(AddDocument(document: document));
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<DocumentTypeModel>> _fetchDocumentTypes(BuildContext context) async {
    BlocProvider.of<DocumentBloc>(context).add(GetDocumentType());

    await Future.delayed(Duration(milliseconds: 100));
    return BlocProvider.of<DocumentBloc>(context).state.allDocumentTypes;
  }

  Future<int?> getUserId() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'user_id');
    return userIdString != null ? int.tryParse(userIdString) : null;
  }
}
