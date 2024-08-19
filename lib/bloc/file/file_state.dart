part of 'file_bloc.dart';

class FileState extends Equatable{
  final bool wantToAdd;
  final List<FileModel> allFilesForDocument;
  final FileModel file;
  final bool errorWhileAddingFile;
  final String errorMessageWhileAddingFile;
  final int fileId;
  final bool isOcr;
  final int index;
  final bool loading;
  final String fileUploadSuccess;

  const FileState({
    this.wantToAdd = false,
    this.allFilesForDocument = const[],
    this.file = const FileModel(id: -1, file_name: "", path: "", document_id: -1, document_type_id: -1),
    this.errorMessageWhileAddingFile = "",
    this.errorWhileAddingFile = false,
    this.fileId = -1,
    this.isOcr = false,
    this.index = -1,
    this.loading = false,
    this.fileUploadSuccess = ""
  });

  FileState copyWith({
    bool? wantToAdd,
    List<FileModel>? allFilesForDocument,
    FileModel? file,
    bool? errorWhileAddingFile,
    String? errorMessageWhileAddingFile,
    int? fileId,
    bool? isOcr,
    int? index,
    bool? loading,
    String? fileUploadSuccess
  }){
    return FileState(
      wantToAdd: wantToAdd ?? this.wantToAdd,
      allFilesForDocument: allFilesForDocument ?? List.from(this.allFilesForDocument),
      file: file ?? this.file,
      errorMessageWhileAddingFile: errorMessageWhileAddingFile ?? this.errorMessageWhileAddingFile,
      errorWhileAddingFile: errorWhileAddingFile ?? this.errorWhileAddingFile,
      fileId: fileId ?? this.fileId,
      isOcr: isOcr ?? this.isOcr,
      index: index ?? this.index,
      loading: loading ?? this.loading,
      fileUploadSuccess: fileUploadSuccess ?? this.fileUploadSuccess
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    wantToAdd,
    allFilesForDocument,
    file,
    errorWhileAddingFile,
    errorMessageWhileAddingFile,
    fileId,
    isOcr,
    index,
    loading,
    fileUploadSuccess,
  ];
}

final class FileStateInitial extends FileState{
  const FileStateInitial({
    super.wantToAdd,
    super.allFilesForDocument,
    super.file,
    super.errorMessageWhileAddingFile,
    super.errorWhileAddingFile,
    super.fileId,
    super.isOcr,
    super.index,
    super.loading,
    super.fileUploadSuccess
  });
}