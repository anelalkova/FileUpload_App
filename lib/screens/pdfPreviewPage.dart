import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfPreviewPage extends StatelessWidget {
  final File pdfFile;

  PdfPreviewPage({required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Preview')),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
