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
              title: Text(isOcr ? 'Image to OCR' : 'Image to PDF',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    await _showFileNameDialog(context, state);
                    if(state.fileName != null && state.fileName.isNotEmpty && state.imageFiles.isNotEmpty) {
                      if (isOcr) {
                        BlocProvider.of<FileBloc>(context)
                            .add(GeneratePdfEvent());
                      }
                      BlocProvider.of<FileBloc>(context).add(UploadPdfEvent(
                          fileName: state.fileName,
                          documentId:
                              context.read<DocumentBloc>().state.documentId,
                          documentTypeId:
                              context.read<DocumentBloc>().state.documentTypeId,
                          isOcr: isOcr,
                          imageFiles: state.imageFiles));
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 400,
                          height: 450,
                          color: Colors.grey[200],
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
                                  color: const Color.fromRGBO(233, 216, 243, 0.5),
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
                                    width: 100,
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
                                  color: const Color.fromRGBO(233, 216, 243, 0.5),
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
                                    width: 100,
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
            ),
          );
        },
        listener: (context, state){

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