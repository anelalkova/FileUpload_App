import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../network/data_service.dart';

class PDFViewPage extends StatefulWidget {
  final int id;

  const PDFViewPage({Key? key, required this.id}) : super(key: key);

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late Future<Response<Uint8List>> _pdfFuture;

  @override
  void initState() {
    super.initState();
    _pdfFuture = DataService().getPDFBytes(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF View'),
      ),
      body: FutureBuilder<Response<Uint8List>>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.success) {
            return PDFView(
              pdfData: snapshot.data!.result!,
            );
          } else {
            return const Center(child: Text('No PDF found'));
          }
        },
      ),
    );
  }
}