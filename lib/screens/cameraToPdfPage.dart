import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../network/api_service.dart';
import '../network/data_service.dart';

class CameraToPDFPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse user;
  final DocumentsResponse documentsResponse;
  final CameraController cameraController;
  final DocumentsResponse document;

  const CameraToPDFPage({
    required this.dataService,
    required this.user,
    required this.documentsResponse,
    required this.cameraController,
    required this.document,
    super.key,
  });

  @override
  _CameraToPDFPageState createState() => _CameraToPDFPageState();
}

class _CameraToPDFPageState extends State<CameraToPDFPage> {
  final List<XFile> _capturedImages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final image = await widget.cameraController.takePicture();
      setState(() {
        _capturedImages.add(image);
      });
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  Future<void> _confirmImages() async {
    if (_capturedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images to confirm')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmImagesPage(
          images: _capturedImages,
          onConfirm: _uploadImages,
        ),
      ),
    );
  }

  Future<void> _uploadImages() async {
    try {
      final imagesAsFiles = _capturedImages.map((xFile) => File(xFile.path)).toList();
      int counter = 0;
      List<File> processedImages = [];
      for (var imageFile in imagesAsFiles) {
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          minHeight: 640,
          minWidth: 480,
          imageFile.absolute.path,
          imageFile.path+"_${counter}.jpg",
          quality: 88,
          autoCorrectionAngle: false
        );
        counter++;
        File file = File(compressedImage!.path);
        processedImages.add(file);
      }

      final fileName = await _showFileNameDialog(context);
      if (fileName == null || fileName.isEmpty) {
        return;
      }

      final resultMessage = await widget.dataService.uploadImages(
          processedImages,
          widget.documentsResponse.documentTypeId,
          widget.documentsResponse.id,
          fileName
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultMessage)),
      );
      if (resultMessage.startsWith('Images uploaded successfully')) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error uploading images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
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
    if (!widget.cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera to PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmImages,
          ),
        ],
      ),
      body: CameraPreview(widget.cameraController),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class ConfirmImagesPage extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onConfirm;

  const ConfirmImagesPage({
    required this.images,
    required this.onConfirm,
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
          return Image.file(File(images[index].path));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onConfirm,
        child: const Icon(Icons.check),
      ),
    );
  }
}
