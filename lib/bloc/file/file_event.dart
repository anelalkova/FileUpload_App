part of 'file_bloc.dart';

class FileEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserWantsToAddFile extends FileEvent{
  final bool wantToAdd;
  final bool isOcr;

  UserWantsToAddFile({required this.wantToAdd, required this.isOcr});
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

class GeneratePdfEvent extends FileEvent{
  final List<File> imageFiles;

   GeneratePdfEvent({required this.imageFiles});
}

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

  LoadFiles({required this.loading});
}
