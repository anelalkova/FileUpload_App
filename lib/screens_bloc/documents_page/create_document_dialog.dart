import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../bloc/document/document_bloc.dart';
import '../../models/document_type.dart';
import '../../models/document.dart';

class CreateDocumentDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController documentNameController = TextEditingController();
  DocumentTypeModel? selectedDocumentType = null;

  CreateDocumentDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                BlocBuilder<DocumentBloc, DocumentState>(
                  builder: (context, state) {
                    if (state.allDocumentTypes.isEmpty) {
                      return const Center(
                        child: Text('Loading document types...'),
                      );
                    }

                    selectedDocumentType =
                        state.allDocumentTypes.first;

                    return DropdownButtonFormField<DocumentTypeModel>(
                      value: selectedDocumentType,
                      decoration: const InputDecoration(
                        labelText: 'Document Type',
                      ),
                      items: state.allDocumentTypes
                          .map((DocumentTypeModel documentType) {
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
                    );
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
                      onPressed: () async {
                        if (formKey.currentState != null &&
                            formKey.currentState!.validate()) {
                          const storage = FlutterSecureStorage();
                          final userId = await storage.read(key: 'user_id');
                          if (userId != null) {
                            final documentBloc =
                            BlocProvider.of<DocumentBloc>(context);

                            final document = DocumentModel(
                              id: 0,
                              description: documentNameController.text,
                              user_id: int.parse(userId),
                              document_type_id: documentBloc.state
                                  .allDocumentTypes
                                  .firstWhere((type) =>
                              type.title == selectedDocumentType!.title)
                                  .id,
                              timestamp: DateTime.now(),
                            );

                            documentBloc.add(AddDocument(document: document));
                            Navigator.of(context).pop();
                          }
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
  }
}
