import 'dart:io';

import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/files_page/file_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/document/document_bloc.dart';

class CreatePdfPage extends StatelessWidget{
  CreatePdfPage({super.key});

  bool isOcr = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileBloc, FileState>(
        builder: (context, state){
          isOcr = context.read<FileBloc>().state.isOcr;
          return Scaffold(
            appBar: AppBar(
              title: Text(isOcr ? 'Image to OCR' : 'Image to PDF'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    await _showFileNameDialog(context, state);

                    var file_name = context.read<FileBloc>().state.fileName;
                    List<File> imageFiles = context.read<FileBloc>().state.imageFiles;

                    if(file_name.isNotEmpty && imageFiles.isNotEmpty) {
                      if (isOcr) {
                        BlocProvider.of<FileBloc>(context)
                            .add(GeneratePdfEvent());
                      }

                      BlocProvider.of<FileBloc>(context).add(UploadPdfEvent(
                          fileName: file_name,
                          documentId: context.read<DocumentBloc>().state.documentId,
                          documentTypeId: context.read<DocumentBloc>().state.documentTypeId,
                          isOcr: isOcr,
                          imageFiles: imageFiles
                      ));
                    }
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
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          width: 400,
                          height: 450,
                          child: const Text('Images will be displayed here',
                              style: TextStyle(fontSize: 16, color: Colors.grey)
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(233, 216, 243, 1),
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
                                  onPressed: () => {
                                    BlocProvider.of<FileBloc>(context).add(PickImageSource(imageSource: ImageSource.camera)),
                                    _pickImage(context, ImageSource.camera)
                                  },
                                  icon: Image.asset(
                                    'assets/camera_icon.png',
                                    width: 130,
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
                                  color: const Color.fromRGBO(233, 216, 243, 1),
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
                                  onPressed: () => {
                                    BlocProvider.of<FileBloc>(context).add(PickImageSource(imageSource: ImageSource.gallery)),
                                    _pickImage(context, ImageSource.gallery)
                                  },
                                  icon: Image.asset(
                                    'assets/gallery_icon.png',
                                    width: 130,
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
                    )
                  ],
                )
              ],
            )
          );
        },
        listener: (context, state){
          if (state.isFileUploadSuccess) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File uploaded successfully!')),
            );
          } else if (state.errorMessageWhileLoadingFile.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessageWhileLoadingFile)),
            );
          }
        });
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        BlocProvider.of<FileBloc>(context).add(AddImage(image: File(pickedFile.path)));
      }
    } catch (e) {
      print('Error picking image ${e.toString()}');
    }
  }

  Future<void> _showFileNameDialog(BuildContext context, FileState state) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return FileNameDialog();
      },
    );
  }

}