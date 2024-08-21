import 'dart:io';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:file_upload_app_part2/screens/documentDetailsPage.dart';
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
  final bool isOcr;

  const PdfGeneratorPage({
    required this.dataService,
    required this.user,
    required this.document,
    required this.isOcr,
    super.key,
  });

  @override
  _PdfGeneratorPageState createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  final List<File> _imageFiles = [];
  File? _pdfFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Image'),
          content: Image.file(File(pickedFile.path)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
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
      TextRecognizer textRecognizer = TextRecognizer();
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);

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
    if (_imageFiles.isEmpty) return;
    String? fileName = await _getFileNameFromUser(context);
    if (fileName == null || fileName.isEmpty) return;

    String result;
    if (widget.isOcr) {
      await _generatePdf();
      if (_pdfFile == null) return;
      result = await widget.dataService.ImageToOcr(
        _pdfFile!,
        widget.document.documentTypeId,
        widget.document.id,
        fileName,
      );
    } else {
      result = await widget.dataService.ImageToPdf(
        _imageFiles,
        fileName,
        widget.document.documentTypeId,
        widget.document.id,
      );
    }

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
      appBar: AppBar(
        title: Text(widget.isOcr ? 'Image to OCR' : 'Image to PDF',
          style: const TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await _uploadPdf();
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: _imageFiles.isEmpty
                      ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 400,
                      height: 450,
                      color: Colors.grey[200],
                      child: const Text(
                        'Images will be displayed here',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                      : PageView.builder(
                    controller: _pageController,
                    itemCount: _imageFiles.length,
                    itemBuilder: (context, index) {
                      return Image.file(_imageFiles[index]);
                    },
                  ),
                ),
              ),
              if (_imageFiles.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _imageFiles.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? Colors.grey
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 216, 243, 0.5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: Image.asset(
                              'assets/camera_icon.png',
                              width: 100,
                              height: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Camera'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 216, 243, 0.5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: Image.asset(
                              'assets/gallery_icon.png',
                              width: 100,
                              height: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Gallery'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Saving...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
