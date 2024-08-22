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
              appBar: AppBar(
                title: const Text('PDF View'),
                actions: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.edit)
                      ],
                    ),
                  ),
                ],
              ),
              body: state.loading ? const Center(
                  child: CircularProgressIndicator()) :
              state.pdfFile.isEmpty ? const Center(
                  child: Text('Error fetching file'))
                  : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: PDFView(
                        pdfData: state.pdfFile,
                        swipeHorizontal: true,
                      ),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 70,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)
                    ),
                    child: BottomAppBar(
                      shape: const CircularNotchedRectangle(),
                      color: const Color.fromRGBO(233, 216, 243, 1),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //smeni a edit ikonata
                          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                )
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