import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../network/data_service.dart';

class PDFViewPage extends StatefulWidget {
  final int id;

  const PDFViewPage({super.key, required this.id});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late Future<Response<Uint8List>> _pdfFuture;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _pdfFuture = DataService().getPDFBytes(widget.id);
  }

  void _onPageChanged(int page, int total) {
    setState(() {
      _currentPage = page;
      _totalPages = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF View', style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        height: 550,
        color: Colors.grey[100],
        child: FutureBuilder<Response<Uint8List>>(
          future: _pdfFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.success) {
              return Stack(
                children: [
                  PDFView(
                    pdfData: snapshot.data!.result!,
                    onPageChanged: (page, total) {
                      _onPageChanged(page!, total!);
                    },
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color.fromRGBO(217, 216, 222, 0.4),
                      ),
                        child: Text(
                        'Page ${_currentPage + 1} of $_totalPages',
                        style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w400, ),
                      ),
                    )
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No PDF found'));
            }
          },
        ),
      ),
    );
  }
}
