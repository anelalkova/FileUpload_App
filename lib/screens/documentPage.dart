import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../network/api_service.dart';
import '../network/data_service.dart';
import 'accountScreen.dart';
import 'documentDetailsPage.dart';
import 'main.dart';

class DocumentPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse user;

  const DocumentPage({
    required this.user,
    required this.dataService,
    super.key,
  });

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late Future<List<DocumentsResponse>> futureDocuments;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureDocuments = getDocumentsFromUserFromAPI(widget.user.id);
  }

  Future<List<DocumentsResponse>> getDocumentsFromUserFromAPI(int userId) async {
    var api = await widget.dataService.getDocumentsByUser(userId);
    if (api.success) {
      return api.result!;
    } else {
      throw Exception('Failed to load documents: ${api.error}');
    }
  }

  Future<int> deleteDocument(int documentId) async {
    var api = await widget.dataService.deleteDocument(documentId);
    if (api.success) {
      return api.result!;
    } else {
      throw Exception('Failed to delete document: ${api.error}');
    }
  }

  Future<List<DocumentTypesResponse>> getDocumentTypes() async {
    var api = await widget.dataService.getDocumentTypes();
    if (api.success) {
      return api.result!;
    } else {
      throw Exception('Failed to fetch document types: ${api.error}');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('d MMM yyyy, HH:mm').format(timestamp);
  }

  Future<void> _showCreateDocumentDialog() async {
    final TextEditingController documentNameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    List<DocumentTypesResponse> documentTypes = [];
    DocumentTypesResponse? selectedDocumentType;

    try {
      documentTypes = await getDocumentTypes();
      selectedDocumentType = documentTypes.isNotEmpty ? documentTypes.first : null;
    } catch (e) {
      print('Error fetching document types: $e');
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Document'),
          content: SingleChildScrollView(
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (formKey.currentState != null && formKey.currentState!.validate()) {
                  var createDocumentRequest = CreateDocumentRequest(
                    id: 0,
                    description: documentNameController.text,
                    userId: widget.user.id,
                    documentTypeId: selectedDocumentType?.id ?? 0,
                    timestamp: DateTime.now(),
                  );

                  try {
                    var result = await widget.dataService.createDocument(createDocumentRequest);
                    if (result.success) {
                      Navigator.of(context).pop(result.result);
                      setState(() {
                        futureDocuments = getDocumentsFromUserFromAPI(widget.user.id);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create document: ${result.error}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
      appBar: AppBar(
        title: const Text('Documents Archive', style: TextStyle(color: Color.fromRGBO(88, 73, 111, 1), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<DocumentsResponse>>(
              future: futureDocuments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('No documents to display'));
                } else if (snapshot.hasData) {
                  final documents = snapshot.data!;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DocumentDetailsPage(
                                dataService: widget.dataService,
                                user: widget.user,
                                document: document,
                              ),
                            ),
                          );
                        },
                        child: OpacityDismissibleTile(
                          key: Key('${document.id}'),
                          document: document,
                          onDismissed: () async {
                            if (await deleteDocument(document.id) == 1) {
                              setState(() {
                                futureDocuments = getDocumentsFromUserFromAPI(widget.user.id);
                              });
                            }
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No documents found'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 40.0),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 1) {
            await _showCreateDocumentDialog();
            setState(() {
              futureDocuments = getDocumentsFromUserFromAPI(widget.user.id);
            });
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountPage(
                  dataService: widget.dataService,
                  userResponse: widget.user,
                ),
              ),
            );
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}

class OpacityDismissibleTile extends StatefulWidget {
  final DocumentsResponse document;
  final Future<void> Function() onDismissed;

  const OpacityDismissibleTile({
    required Key key,
    required this.document,
    required this.onDismissed,
  }) : super(key: key);

  @override
  _OpacityDismissibleTileState createState() => _OpacityDismissibleTileState();
}

class _OpacityDismissibleTileState extends State<OpacityDismissibleTile> {
  double _opacity = 1.0;

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('d MMM yyyy, HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        await widget.onDismissed();
      },
      onUpdate: (details) {
        setState(() {
          _opacity = 1.0 - details.progress;
        });
      },
      child: Opacity(
        opacity: _opacity,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(251, 250, 255, 1),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: ListTile(
            title: Text(widget.document.description),
            subtitle: Text("Last modified at: ${formatTimestamp(widget.document.timestamp)}"),
            tileColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
