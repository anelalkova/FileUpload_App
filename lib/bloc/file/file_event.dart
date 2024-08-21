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
  final List<File> imageFiles;
  final String fileName;
  final int documentTypeId;
  final int documentId;
  final bool isOcr;

  UploadPdfEvent({
    required this.imageFiles,
    this.pdfFile,
    required this.fileName,
    required this.documentId,
    required this.documentTypeId,
    required this.isOcr
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

