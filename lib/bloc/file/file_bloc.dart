import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_upload_app_part2/models/file.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:equatable/equatable.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileStateInitial()) {
    on<UserWantsToAddFile>(userWantsToAddFileEvent);
    on<AddFile>(addFileEvent);
    on<GetFiles>(getFilesEvent);
    on<ErrorWhileAddingFile>(errorWhileAddingFileEvent);
    on<DeleteFile>(deleteFileEvent);
    on<FileIsTapped>(fileIsTappedEvent);
    on<LoadFiles>(loadFilesEvent);
    on<OpenFile>(openFileEvent);
    on<ErrorWhileLoadingFile>(errorWhileLoadingFileEvent);
    on<AddImage>(addImageEvent);
    on<PickImageSource>(pickImageSourceEvent);
    on<SaveFileName>(saveFileNameEvent);
    on<FileType>(chooseFileTypeEvent);
    on<EditFileName>(editFileNameEvent);
    on<WantsToEditFileName>(wantsToEditFileNameEvent);
    on<ExitPage>(exitPageEvent);
    on<WantsToExitPage>(wantsToExitPageEvent);
    on<WantsToDelete>(wantsToDeleteEvent);
    on<ProcessAndUploadPdfEvent>(processAndUploadPdfEvent);
    on<SelectFile>(selectFileEvent);
    on<ClearSelectedFiles>(clearSelectedFilesEvent);
    on<UpdateSelectedIds>(updateSelectedFileIdsEvent);
    on<ResetFileState>(resetFileStateEvent);
    on<WantsToDownloadFile>(wantsToDownloadFileEvent);
    on<DownloadFile>(downloadFileEvent);
  }

  void loadFilesEvent(LoadFiles event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
  }

  Future<void> deleteFileEvent(DeleteFile event,
      Emitter<FileState> emit) async {
    await DataService().deleteFile(event.id);
    emit(state.copyWith(
      allFilesForDocument: state.allFilesForDocument.where((file) =>
      file.id != event.id).toList(),
    ));
  }

  Future<void> userWantsToAddFileEvent(UserWantsToAddFile event,
      Emitter<FileState> emit) async {
    emit(state.copyWith(wantToAdd: event.wantToAdd));
  }

  Future<void> addFileEvent(AddFile event, Emitter<FileState> emit) async {
    try {
      await DataService().createFile(FilesResponse(
          id: event.file.id,
          path: event.file.path,
          documentId: event.file.document_id,
          documentTypeId: event.file.document_type_id,
          fileName: event.file.file_name,
          fileSize: event.file.file_size
      ));

      final updatedFiles = List<FileModel>.from(state.allFilesForDocument)
        ..add(event.file);
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
    emit(state.copyWith(loading: true));
    final files = await DataService().getFilesForDocumentBLOC(event.documentId);
    emit(state.copyWith(allFilesForDocument: files, loading: false));
  }

  void errorWhileAddingFileEvent(ErrorWhileAddingFile event,
      Emitter<FileState> emit) {
    emit(state.copyWith(
      errorWhileAddingFile: true,
      errorMessageWhileAddingFile: event.error ?? '',
      wantToAdd: false,
    ));
  }

  Future<void> fileIsTappedEvent(FileIsTapped event,
      Emitter<FileState> emit) async {
    emit(state.copyWith(fileId: event.fileId));
  }

  Future<void> processAndUploadPdfEvent(
      ProcessAndUploadPdfEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true, isOcrConversionSuccess: false, isUploading: true));
    try {
      final pdf = pw.Document();
      final fontData = await rootBundle.load('assets/OpenSans-VariableFont_wdth,wght.ttf');
      final ttf = pw.Font.ttf(fontData);
      final tempDir = await getTemporaryDirectory();
      File? pdfFile;

      if (event.isOcr) {
        for (var imageFile in state.imageFiles) {
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

        pdfFile = File("${tempDir.path}/output.pdf");
        final pdfBytes = await pdf.save();
        await pdfFile.writeAsBytes(pdfBytes);

        final result = await DataService().ImageToOcr(
          pdfFile,
          event.documentTypeId,
          event.documentId,
          event.fileName,
        );

        if (result.contains('successfully')) {
          emit(state.copyWith(
              fileUploadSuccess: result,
              isFileUploadSuccess: true,
              pdfFile: pdfBytes,
              isOcrConversionSuccess: true));
        } else {
          emit(state.copyWith(
              errorMessageWhileAddingFile: 'Failed to upload OCR file: $result',
              errorWhileAddingFile: true));
        }
      } else {
        final result = await DataService().ImageToPdf(
          event.imageFiles!,
          event.fileName,
          event.documentTypeId,
          event.documentId,
        );

        if (result.contains('successfully')) {
          emit(state.copyWith(
              fileUploadSuccess: result,
              isFileUploadSuccess: true));
        } else {
          emit(state.copyWith(
              errorMessageWhileAddingFile: 'Failed to upload PDF: $result',
              errorWhileAddingFile: true));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessageWhileAddingFile: 'Error processing or uploading file: $e',
          errorWhileAddingFile: true));
    } finally {
      emit(state.copyWith(
          loading: false,
          isUploading: false,
          fileName: "",
          imageFiles: [],
          fileUploadSuccess: "",
          isFileUploadSuccess: false));
    }
  }

  Future<void> openFileEvent(OpenFile event, Emitter<FileState>emit) async {
    emit(state.copyWith(isFileLoaded: true));
    try {
      final result = await DataService().getPDFBytes(event.fileId);
      if (result.success) {
        emit(state.copyWith(pdfFile: result.result));
      } else {
        emit(state.copyWith(errorWhileLoadingFile: true,
            errorMessageWhileLoadingFile: result.error));
      }
      emit(state.copyWith(isFileLoaded: false));
    } catch (e) {
      emit(state.copyWith(errorWhileLoadingFile: true,
          errorMessageWhileLoadingFile: e.toString(), isFileLoaded: false));
    } finally {
      emit(state.copyWith(isFileLoaded: false));
    }
  }

  void errorWhileLoadingFileEvent(ErrorWhileLoadingFile event,
      Emitter<FileState>emit) async {
    emit(state.copyWith(errorWhileLoadingFile: true,
        errorMessageWhileLoadingFile: event.errorMessageWhileLoadingFile));
  }

  Future<void> pickImageSourceEvent(PickImageSource event,
      Emitter<FileState>emit) async {
    emit(state.copyWith(imageSource: event.imageSource));
  }

  Future<void> addImageEvent(AddImage event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));

    try {
      final updatedImageFiles = List<File>.from(state.imageFiles);
      updatedImageFiles.add(event.image);

      emit(state.copyWith(
        imageFiles: updatedImageFiles,
        loading: false,
        errorWhileAddingFile: false,
        errorMessageWhileAddingFile: "",
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        errorWhileAddingFile: true,
        errorMessageWhileAddingFile: e.toString(),
      ));
    }
  }

  Future<void> editFileNameEvent(EditFileName event,
      Emitter<FileState> emit) async {
    try {
      emit(state.copyWith(loading: true));

      await DataService().updateFileBLOC(
          UpdateFile(file_Name: event.newFileName), state.fileId);

      emit(state.copyWith(
        fileName: event.newFileName,
        wantsToEdit: false,
        updateSuccess: true,
        updateSuccessMessage: "File updated successfully!",
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        updateSuccessMessage: e.toString(),
        updateSuccess: false,
        wantsToEdit: false,
        loading: false,
      ));
    } finally {
      emit(state.copyWith(
        updateSuccessMessage: "",
        updateSuccess: false,
        wantsToEdit: false,
        loading: false,
      ));
    }
  }

  Future<void>updateSelectedFileIdsEvent(UpdateSelectedIds event, Emitter<FileState>emit)async{
    List<int> fileIds = List<int>.from(event.fileIds ?? []);
    if(fileIds.contains(event.newFileId)){
      fileIds.remove(event.newFileId);
    }else {
      fileIds.add(event.newFileId);
    }
    emit(state.copyWith(selectedFileIds: fileIds));
  }

  Future<void>downloadFileEvent(DownloadFile event, Emitter<FileState>emit)async{
    emit(state.copyWith(wantsToDownloadFile: true));
    try{
      await DataService().downloadFile(event.downloadFileId);
      emit(state.copyWith(fileDownloadSuccess: true, fileDownloadMessage: "File downloaded successfully!"));
    }catch(e){
      emit(state.copyWith(fileDownloadSuccess: false, fileDownloadMessage: e.toString()));
    }finally{
      emit(state.copyWith(fileDownloadSuccess: false, fileDownloadMessage: "", wantsToDownloadFile: false));
    }
  }

  void resetFileStateEvent(ResetFileState event, Emitter <FileState> emit)async{
    emit(FileStateInitial());
  }

  void wantsToEditFileNameEvent(WantsToEditFileName event,
      Emitter<FileState>emit) async {
    emit(state.copyWith(wantsToEdit: event.wantsToEdit));
  }

  void saveFileNameEvent(SaveFileName event, Emitter<FileState> emit) async {
    emit(state.copyWith(fileName: event.fileName));
  }

  void chooseFileTypeEvent(FileType event, Emitter<FileState>emit) async {
    emit(state.copyWith(isOcr: event.isOcr));
  }

  void exitPageEvent(ExitPage event, Emitter <FileState> emit)async{
    emit(state.copyWith(imageFiles: event.imageFiles));
  }

  void wantsToExitPageEvent(WantsToExitPage event, Emitter<FileState> emit)async {
    emit(state.copyWith(wantsToExit: event.wantsToExit));
  }

  void wantsToDeleteEvent(WantsToDelete event, Emitter<FileState> emit)async{
    emit(state.copyWith(wantsToDelete: event.wantsToDelete));
  }

  void selectFileEvent(SelectFile event, Emitter<FileState>emit)async{
    emit(state.copyWith(isItemSelected: !state.isItemSelected));
  }

  void clearSelectedFilesEvent(ClearSelectedFiles event, Emitter<FileState>emit)async{
    emit(state.copyWith(selectedFileIds: []));
  }

  void wantsToDownloadFileEvent(WantsToDownloadFile event, Emitter<FileState>emit)async{
    emit(state.copyWith(wantsToDownloadFile: !event.wantsToDownload));
  }
}
