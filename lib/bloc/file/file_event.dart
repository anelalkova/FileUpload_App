part of 'file_bloc.dart';

class FileEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserWantsToAddFile extends FileEvent{
  final bool wantToAdd;

  UserWantsToAddFile({required this.wantToAdd});
}

class AddFile extends FileEvent{
  final FileModel file;

  AddFile({
    required this.file,
  });
}

class GetFiles extends FileEvent{
  final int documentId;

  GetFiles({
    required this.documentId,
  });
}

class ErrorWhileAddingFile extends FileEvent{
  final String? error;

  ErrorWhileAddingFile({this.error});
}

class DeleteFile extends FileEvent{
  final int id;

  DeleteFile({required this.id});
}

class FileIsTapped extends FileEvent{
  final int fileId;

  FileIsTapped({required this.fileId});
}

class GeneratePdfEvent extends FileEvent{}

class UploadPdfEvent extends FileEvent{
  final File? pdfFile;
  final List<File>? imageFiles;
  final String fileName;
  final int documentTypeId;
  final int documentId;
  final bool isOcr;

  UploadPdfEvent({
    this.imageFiles,
    this.pdfFile,
    required this.fileName,
    required this.documentId,
    required this.documentTypeId,
    required this.isOcr,
  });
}

class LoadFiles extends FileEvent{
  final bool loading;
  final int documentId;
  final int documentTypeId;

  LoadFiles({required this.loading, required this.documentId, required this.documentTypeId});
}

class OpenFile extends FileEvent{
  final int fileId;

  OpenFile({required this.fileId});
}

class ErrorWhileLoadingFile extends FileEvent {
  final bool errorWhileLoadingFile;
  final String errorMessageWhileLoadingFile;

  ErrorWhileLoadingFile({
    required this.errorWhileLoadingFile,
    required this.errorMessageWhileLoadingFile
  });
}

class PickImageSource extends FileEvent{
  final ImageSource imageSource;

  PickImageSource({required this.imageSource});
}

class AddImage extends FileEvent{
  final File image;

  AddImage({required this.image});
}

class SaveFileName extends FileEvent{
  final String fileName;

  SaveFileName({required this.fileName});
}

class FileType extends FileEvent{
  final bool isOcr;

  FileType({required this.isOcr});
}

class WantsToEditFileName extends FileEvent{
  final bool wantsToEdit;

  WantsToEditFileName({required this.wantsToEdit});
}

class EditFileName extends FileEvent{
  final String newFileName;

  EditFileName({required this.newFileName});
}

class WantsToExitPage extends FileEvent{
  final bool wantsToExit;

  WantsToExitPage({required this.wantsToExit});
}

class ExitPage extends FileEvent{
  final List<File> imageFiles;

  ExitPage({required this.imageFiles});
}

class WantsToDelete extends FileEvent{
  final bool wantsToDelete;

  WantsToDelete({required this.wantsToDelete});
}

class ProcessAndUploadPdfEvent extends FileEvent{
  final bool isOcr;
  final String fileName;
  final int documentId;
  final int documentTypeId;
  final File? pdfFile;
  final List<File>? imageFiles;

  ProcessAndUploadPdfEvent({
    required this.isOcr,
    required this.fileName,
    required this.documentId,
    required this.documentTypeId,
    this.pdfFile,
    this.imageFiles});
}

class UpdateSelectedIds extends FileEvent {
  final List<int>? fileIds;
  final int newFileId;

  UpdateSelectedIds({required this.fileIds, required this.newFileId});
}

class SelectFile extends FileEvent{
  final bool isItemSelected;

  SelectFile({required this.isItemSelected});
}

class ClearSelectedFiles extends FileEvent{}

class ResetFileState extends FileEvent{}

class WantsToDownloadFile extends FileEvent{
  final bool wantsToDownload;

  WantsToDownloadFile({required this.wantsToDownload});
}

class DownloadFile extends FileEvent{
  final int downloadFileId;

  DownloadFile({required this.downloadFileId});
}

class ShareFile extends FileEvent{}

class ReturnFileInitialState extends FileEvent{}
