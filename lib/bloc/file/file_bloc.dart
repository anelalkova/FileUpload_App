import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_upload_app_part2/models/file.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:equatable/equatable.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(const FileStateInitial()) {
    on<UserWantsToAddFile>(userWantsToAddFileEvent);
    on<AddFile>(addFileEvent);
    on<GetFiles>(getFilesEvent);
    on<ErrorWhileAddingFile>(errorWhileAddingFileEvent);
    on<DeleteFile>(deleteFileEvent);
    on<FileIsTapped>(fileIsTappedEvent);
    on<GeneratePdfEvent>(generatePdfEvent);
    on<UploadPdfEvent>(uploadPdfEvent);
    on<LoadFiles>(loadFilesEvent);
  }

  void loadFilesEvent(LoadFiles event, Emitter<FileState> emit)async{
    emit(state.copyWith(loading: true));
  }
  Future<void> deleteFileEvent(DeleteFile event, Emitter<FileState> emit) async {
    await DataService().deleteFile(event.id);
    emit(state.copyWith(
      allFilesForDocument: state.allFilesForDocument.where((file) => file.id != event.id).toList(),
    ));
  }

  Future<void> userWantsToAddFileEvent(UserWantsToAddFile event, Emitter<FileState> emit) async {
    emit(state.copyWith(wantToAdd: event.wantToAdd, isOcr: event.isOcr));
  }

  Future<void> addFileEvent(AddFile event, Emitter<FileState> emit) async {
    try {
      await DataService().createFile(FilesResponse(
        id: event.file.id,
        path: event.file.path,
        documentId: event.file.document_id,
        documentTypeId: event.file.document_type_id,
        fileName: event.file.file_name,
      ));

      final updatedFiles = List<FileModel>.from(state.allFilesForDocument)..add(event.file);
      emit(state.copyWith(
        wantToAdd: false,
        errorWhileAddingFile: false,
        errorMessageWhileAddingFile: '',
        allFilesForDocument: updatedFiles,
      ));
    } catch (e) {
      emit(state.copyWith(
        wantToAdd: false,
        errorMessageWhileAddingFile: e.toString(),
        errorWhileAddingFile: true,
      ));
    }
  }

  Future<void> getFilesEvent(GetFiles event, Emitter<FileState> emit) async {
    emit(state.copyWith(allFilesForDocument: const[]));
    final files = await DataService().getFilesForDocumentBLOC(event.documentId);
    emit(state.copyWith(allFilesForDocument: files, loading: false));
  }

  void errorWhileAddingFileEvent(ErrorWhileAddingFile event, Emitter<FileState> emit) {
    emit(state.copyWith(
      errorWhileAddingFile: true,
      errorMessageWhileAddingFile: event.error ?? '',
      wantToAdd: false,
    ));
  }

  Future<void> fileIsTappedEvent(FileIsTapped event, Emitter<FileState> emit) async {
    emit(state.copyWith(fileId: event.fileId));
  }

  Future<void> generatePdfEvent(GeneratePdfEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/OpenSans-VariableFont_wdth,wght.ttf');
      final ttf = pw.Font.ttf(fontData);

      for (var imageFile in event.imageFiles) {
        final textRecognizer = TextRecognizer();
        final inputImage = InputImage.fromFile(imageFile);
        final recognizedText = await textRecognizer.processImage(inputImage);
        textRecognizer.close();

        if (recognizedText.text.isNotEmpty) {
          pdf.addPage(pw.Page(
            build: (pw.Context context) => pw.Center(
              child: pw.Text(recognizedText.text, style: pw.TextStyle(font: ttf)),
            ),
          ));
        }
      }

      final outputDir = await getTemporaryDirectory();
      final outputFile = File("${outputDir.path}/output.pdf");
      await outputFile.writeAsBytes(await pdf.save());

      emit(state.copyWith(errorWhileAddingFile: false, wantToAdd: false));
    } catch (e) {
      emit(state.copyWith(errorMessageWhileAddingFile: 'Failed to generate PDF: $e', wantToAdd: false, errorWhileAddingFile: true));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> uploadPdfEvent(UploadPdfEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final result = event.isOcr
          ? await DataService().ImageToOcr(
        event.pdfFile!,
        event.documentTypeId,
        event.documentId,
        event.fileName,
      )
          : await DataService().ImageToPdf(
        event.imageFiles,
        event.fileName,
        event.documentTypeId,
        event.documentId,
      );

      if (result.contains('successfully')) {
        emit(state.copyWith(fileUploadSuccess: result));
      } else {
        emit(state.copyWith(errorMessageWhileAddingFile: 'Failed to upload file: $result', errorWhileAddingFile: true));
      }
    } catch (e) {
      emit(state.copyWith(errorMessageWhileAddingFile: 'Error uploading file: $e', errorWhileAddingFile: true));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
