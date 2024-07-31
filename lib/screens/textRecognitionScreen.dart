import 'dart:io';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:file_upload_app_part2/screens/documentDetailsPage.dart';
import 'package:file_upload_app_part2/screens/pdfPreviewPage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfGeneratorPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse user;
  final DocumentsResponse document;

  const PdfGeneratorPage({
    required this.dataService,
    required this.user,
    required this.document,
    super.key
  });
  @override
  _PdfGeneratorPageState createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  List<File> _imageFiles = [];
  String _extractedText = "";
  File? _pdfFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Image'),
          content: Image.file(File(pickedFile.path)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<void> _generatePdf() async {
    if (_imageFiles.isEmpty) return;

    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/OpenSans-VariableFont_wdth,wght.ttf');
    final ttf = pw.Font.ttf(fontData);

    for (var imageFile in _imageFiles) {
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(imageFile.path));

      final extractedText = recognizedText.text;
      textRecognizer.close();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(extractedText, style: pw.TextStyle(font: ttf)),
            );
          },
        ),
      );
    }

    final outputDir = await getTemporaryDirectory();
    final outputFile = File("${outputDir.path}/output.pdf");
    await outputFile.writeAsBytes(await pdf.save());

    setState(() {
      _pdfFile = outputFile;
    });

    print("PDF saved at ${outputFile.path}");
  }



  Future<String?> _getFileNameFromUser(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "File Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadPdf() async {
    if (_pdfFile == null) return;
    String? fileName = await _getFileNameFromUser(context);
    if (fileName == null || fileName.isEmpty) return;

    String result = await widget.dataService.ImageToOcr(
      _pdfFile!,
      widget.document.documentTypeId,
      widget.document.id,
      fileName,
    );

    if (result.contains("successfully")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentDetailsPage(
            dataService: widget.dataService,
            user: widget.user,
            document: widget.document,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed uploading file")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Generator')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Pick Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Capture Image from Camera'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _generatePdf();
                  if (_pdfFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfPreviewPage(pdfFile: _pdfFile!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No PDF file available to preview')),
                    );
                  }
                },
                child: const Text('Preview PDF'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_pdfFile != null) {
                    await _uploadPdf();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No PDF file available to upload')),
                    );
                  }
                },
                child: const Text('Upload PDF'),
              )
            ],
          ),
        ),
      ),
    );
  }
}