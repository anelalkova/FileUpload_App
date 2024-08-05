import 'dart:io';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../network/data_service.dart';
import 'documentDetailsPage.dart';

class ImageToPdfScreen extends StatefulWidget {
  final DataService dataService;
  final UserResponse userResponse;
  final DocumentsResponse documentsResponse;

  const ImageToPdfScreen({
    required this.dataService,
    required this.userResponse,
    required this.documentsResponse,
    super.key,
  });

  @override
  _ImageToPdfScreenState createState() => _ImageToPdfScreenState();
}

class _ImageToPdfScreenState extends State<ImageToPdfScreen> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _confirmImages() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images to confirm')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConfirmImagesPage(
              images: _selectedImages,
              onConfirm: _createPdf,
              dataService: widget.dataService,
              userResponse: widget.userResponse,
              documentsResponse: widget.documentsResponse,
            ),
      ),
    );
  }

  Future<void> _createPdf() async {
    final fileName = await _showFileNameDialog(context);
    if (fileName == null || fileName.isEmpty) {
      return;
    }

    try {
      final resultMessage = await widget.dataService.ImageToPdf(
        _selectedImages,
        fileName,
        widget.documentsResponse.documentTypeId,
        widget.documentsResponse.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultMessage)),
      );

      if (resultMessage.startsWith('PDF created successfully')) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DocumentDetailsPage(
                  dataService: widget.dataService,
                  user: widget.userResponse,
                  document: widget.documentsResponse,
                ),
          ),
              (Route<dynamic> route) {
                return route.settings.name != '/ImageToPdfScreen';
          },
        );
      }
    } catch (e) {
      print('Error creating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating PDF: $e')),
      );
    }
  }


  Future<String?> _showFileNameDialog(BuildContext context) async {
    String? fileName;

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextField(
            onChanged: (value) {
              fileName = value;
            },
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
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(fileName);
              },
            ),
          ],
        );
      },
    );

    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmImages,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Open Camera'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Open Gallery'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Image.file(_selectedImages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmImagesPage extends StatelessWidget {
  final List<File> images;
  final Future<void> Function() onConfirm;
  final DataService dataService;
  final UserResponse userResponse;
  final DocumentsResponse documentsResponse;

  const ConfirmImagesPage({
    required this.images,
    required this.onConfirm,
    required this.dataService,
    required this.userResponse,
    required this.documentsResponse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Images'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.file(images[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await onConfirm();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentDetailsPage(
                dataService: dataService,
                user: userResponse,
                document: documentsResponse,
              ),
            ),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
