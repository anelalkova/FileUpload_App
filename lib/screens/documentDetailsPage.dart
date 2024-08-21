import 'package:file_upload_app_part2/screens/accountScreen.dart';
import 'package:file_upload_app_part2/screens/pdfGeneratorPage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../network/api_service.dart';
import '../network/data_service.dart';
import 'documentPage.dart';
import 'editAccountScreen.dart';
import 'main.dart';
import 'pdfViewPage.dart';

class DocumentDetailsPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse user;
  final DocumentsResponse document;

  const DocumentDetailsPage({
    required this.dataService,
    required this.user,
    required this.document,
    super.key,
  });

  @override
  _DocumentDetailsPageState createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  late Future<List<FilesResponse>> files;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    files = _initializeFiles();
  }

  Future<List<FilesResponse>> _initializeFiles() async {
    try {
      final filesList = await getFilesForDocumentFromAPI(widget.document.id);

      filesList.sort((a, b) => b.id.compareTo(a.id));

      return filesList;
    } catch (e) {
      throw Exception('Failed to load files: $e');
    }
  }

  Future<List<FilesResponse>> getFilesForDocumentFromAPI(int documentId) async {
    try {
      var api = await widget.dataService.getFilesForDocument(documentId);
      if (api.success) {
        return api.result!;
      } else {
        throw Exception('Failed to load files: ${api.error}');
      }
    } catch (e) {
      throw Exception('Failed to load files: $e');
    }
  }

  String _extractUserFileName(String fileName) {
    final parts = fileName.split('_');

    if (parts.length > 1) {
      return '${parts[0]}.pdf';
    }

    return fileName;
  }

  Future<void> _showCreateDocumentDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                'assets/pdf_icon.png',
                                width: 70.0,
                                height: 70.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfGeneratorPage(
                                      dataService: widget.dataService,
                                      user: widget.user,
                                      document: widget.document,
                                      isOcr: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Create PDF',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                'assets/ocr_icon.png',
                                width: 70.0,
                                height: 70.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfGeneratorPage(
                                      dataService: widget.dataService,
                                      user: widget.user,
                                      document: widget.document,
                                      isOcr: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Create OCR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentPage(
            dataService: widget.dataService,
            user: widget.user,
          ),
        ),
      );
    } else if (index == 1) {
      _showCreateDocumentDialog();
    } /*else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(
            dataService: widget.dataService,
            userResponse: widget.user,
          ),
        ),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
      appBar: AppBar(
        title: Text(widget.document.description, style: const TextStyle(color: Color.fromRGBO(88, 73, 111, 1), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'View Profile':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountPage(
                              dataService: widget.dataService,
                              userResponse: widget.user
                          )
                      )
                  );
                  break;
                case 'Edit Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAccountScreen(
                        dataService: widget.dataService,
                        userResponse: widget.user,
                      ),
                    ),
                  );
                  break;
                case 'Log out':
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'View Profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color.fromRGBO(88, 73, 111, 1)),
                      SizedBox(width: 10),
                      Text('View Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Edit Profile',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Color.fromRGBO(88, 73, 111, 1)),
                      SizedBox(width: 10),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Log out',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Color.fromRGBO(88, 73, 111, 1)),
                      SizedBox(width: 10),
                      Text('Log out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FilesResponse>>(
        future: files,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('No files to display'));
          } else if (snapshot.hasData) {
            final filesData = snapshot.data!;
            if (filesData.isEmpty) {
              return const Center(child: Text('No files found'));
            }
            return ListView.builder(
              itemCount: filesData.length,
              itemBuilder: (context, index) {
                final file = filesData[index];
                return Dismissible(
                  key: Key(file.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await widget.dataService.deleteFile(file.id);
                    setState(() {
                      files = _initializeFiles();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${_extractUserFileName(file.fileName)} deleted')),
                    );
                  },
                  background: Container(
                    color: const Color.fromRGBO(88, 73, 111, 1),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
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
                      title: Text(_extractUserFileName(file.fileName), style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(file.path),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.open_in_new,
                                color: Colors.black,
                            ),
                            onPressed: () async {
                              if (file.path.endsWith('.pdf')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewPage(id: file.id),
                                  ),
                                );
                              } else {
                                final openResult = await OpenFile.open(file.path);
                                if (openResult.type != ResultType.done) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to open file: ${openResult.message}')),
                                  );
                                }
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                                Icons.download,
                                color: Colors.black,
                            ),
                            onPressed: () async {
                              await widget.dataService.downloadFile(file.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No files found'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
              size: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Image.asset('assets/scan_icon.png',
              width: 30,
              height: 30,
            ),
            label: "New",
          ),/*
          const BottomNavigationBarItem(
            icon: Icon(
                Icons.person,
                color: Colors.black,
            ),
            label: "Account",
          ),*/
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
