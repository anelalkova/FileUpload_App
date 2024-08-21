import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FileViewPage extends StatelessWidget {
  const FileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
        builder: (context, state) {

          return Scaffold(
            backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
            appBar: AppBar(
              actions: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'PDF View',
                          style: TextStyle(
                            color: Color.fromRGBO(88, 73, 111, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
              automaticallyImplyLeading: false,
            ),
            body: state.loading ? const Center(
                child: CircularProgressIndicator()) :
            state.pdfFile.isEmpty ? const Center(
                child: Text('Error fetching file'))
                : Stack(
              children: [
                PDFView(
                  pdfData: state.pdfFile,
                ),
              ],
            )
          );
        },
        listener: (context, state) {
          if (state.errorWhileLoadingFile) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                    'Error: ${state.errorMessageWhileLoadingFile}'))
            );
          }
        });
  }
}