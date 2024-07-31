import 'package:flutter/material.dart';

import '../network/api_service.dart';
import '../network/data_service.dart';

class CreateDocumentPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse user;
  final Future<List<DocumentTypesResponse>> documentTypesResponse;

  const CreateDocumentPage({
    super.key,
    required this.dataService,
    required this.user,
    required this.documentTypesResponse
  });

  @override
  _CreateDocumentScreenState createState() => _CreateDocumentScreenState();
}

class _CreateDocumentScreenState extends State<CreateDocumentPage> {
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DocumentTypesResponse> documentTypes = [];
  DocumentTypesResponse? selectedDocumentType;

  @override
  void initState() {
    super.initState();
    _fetchDocumentTypes();
  }

  Future<void> _fetchDocumentTypes() async {
    try {
      var documentTypesResponse = await widget.documentTypesResponse;
      if (documentTypesResponse.isNotEmpty) {
        setState(() {
          documentTypes = documentTypesResponse;
          selectedDocumentType = documentTypesResponse.first;
        });
      }
    } catch (e) {
      print('Error fetching document types: $e');
    }
  }

  @override
  void dispose() {
    documentNameController.dispose();
    documentTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Document'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              DropdownButtonFormField<DocumentTypesResponse>(
                value: selectedDocumentType,
                decoration: const InputDecoration(
                  labelText: 'Document Type',
                ),
                items: documentTypes.map((DocumentTypesResponse documentType) {
                  return DropdownMenuItem<DocumentTypesResponse>(
                    value: documentType,
                    child: Text(documentType.title),
                  );
                }).toList(),
                onChanged: (DocumentTypesResponse? newValue) {
                  setState(() {
                    selectedDocumentType = newValue;
                    documentTypeController.text = newValue?.id.toString() ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a document type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState != null && formKey.currentState!.validate()) {
                    var createDocumentRequest = CreateDocumentRequest(
                      id: 0,
                      description: documentNameController.text,
                      userId: widget.user.id,
                      documentTypeId: selectedDocumentType?.id ?? 0,
                      timestamp: DateTime.now(),
                    );

                    var result = await createDocument(createDocumentRequest);
                    if (result.success) {
                      Navigator.pop(context, result.result);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create document: ${result.error}')),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Response<CreateDocumentRequest>> createDocument(CreateDocumentRequest createDocumentRequest) async {
    try {
      var result = await widget.dataService.createDocument(createDocumentRequest);
      return Response(success: true, result: result.result);
    } catch (e) {
      return Response(success: false, error: e.toString());
    }
  }
}
