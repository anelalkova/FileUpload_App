import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: onConfirm,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.file(File(images[index].path));
        },
      ),
    );
  }
}
