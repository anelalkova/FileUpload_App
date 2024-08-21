import 'dart:io';

import 'package:file_upload_app_part2/screens_bloc/files_page/create_pdf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/file/file_bloc.dart';

class CreateFileDialog extends StatelessWidget{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CreateFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/pdf_icon.png',
                            width: 70.0,
                            height: 70.0,
                          ),
                          onPressed: () {
                            BlocProvider.of<FileBloc>(context).add(UserWantsToAddFile(wantToAdd: true));
                            BlocProvider.of<FileBloc>(context).add(FileType(isOcr: false));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => CreatePdfPage())
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create PDF',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            'assets/ocr_icon.png',
                            width: 70.0,
                            height: 70.0,
                          ),
                          onPressed: () {
           //                 Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create OCR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}