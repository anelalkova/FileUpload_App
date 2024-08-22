part of 'file_bloc.dart';

class FileState extends Equatable {
  final bool wantToAdd;
  final List<FileModel> allFilesForDocument;
  final FileModel file;
  final bool errorWhileAddingFile;
  final String errorMessageWhileAddingFile;
  final int fileId;
  final bool isOcr;
  final bool loading;
  final String fileUploadSuccess;
  final Uint8List pdfFile;
  final bool errorWhileLoadingFile;
  final String errorMessageWhileLoadingFile;
  final ImageSource imageSource;
  final List<File> imageFiles;
  final String fileName;
  final bool isFileUploadSuccess;

  FileState({
    this.wantToAdd = false,
    this.allFilesForDocument = const [],
    this.file = const FileModel(id: -1, file_name: "", path: "", document_id: -1, document_type_id: -1, file_size: 0),
    this.errorMessageWhileAddingFile = "",
    this.errorWhileAddingFile = false,
    this.fileId = -1,
    this.isOcr = false,
    this.loading = false,
    this.fileUploadSuccess = "",
    Uint8List? pdfFile,
    this.errorWhileLoadingFile = false,
    this.errorMessageWhileLoadingFile = "",
    this.imageSource = ImageSource.camera,
    this.imageFiles = const [],
    this.fileName = "",
    this.isFileUploadSuccess = false
  }) : pdfFile = pdfFile ?? Uint8List(0);

  FileState copyWith({
    bool? wantToAdd,
    List<FileModel>? allFilesForDocument,
    FileModel? file,
    bool? errorWhileAddingFile,
    String? errorMessageWhileAddingFile,
    int? fileId,
    bool? isOcr,
    bool? loading,
    String? fileUploadSuccess,
    Uint8List? pdfFile,
    bool? errorWhileLoadingFile,
    String? errorMessageWhileLoadingFile,
    ImageSource? imageSource,
    List<File>? imageFiles,
    String? fileName,
    bool? isFileUploadSuccess
  }) {
    return FileState(
        wantToAdd: wantToAdd ?? this.wantToAdd,
        allFilesForDocument: allFilesForDocument ??
            List.from(this.allFilesForDocument),
        file: file ?? this.file,
        errorMessageWhileAddingFile: errorMessageWhileAddingFile ??
            this.errorMessageWhileAddingFile,
        errorWhileAddingFile: errorWhileAddingFile ?? this.errorWhileAddingFile,
        fileId: fileId ?? this.fileId,
        isOcr: isOcr ?? this.isOcr,
        loading: loading ?? this.loading,
        fileUploadSuccess: fileUploadSuccess ?? this.fileUploadSuccess,
        pdfFile: pdfFile ?? this.pdfFile,
        errorMessageWhileLoadingFile: errorMessageWhileLoadingFile ??
            this.errorMessageWhileLoadingFile,
        errorWhileLoadingFile: errorWhileLoadingFile ??
            this.errorWhileLoadingFile,
        imageSource: imageSource ?? this.imageSource,
        imageFiles: imageFiles ?? this.imageFiles,
        fileName: fileName ?? this.fileName,
        isFileUploadSuccess: isFileUploadSuccess ?? this.isFileUploadSuccess
    );
  }

  @override
  List<Object?> get props => [
    wantToAdd,
    allFilesForDocument,
    file,
    errorWhileAddingFile,
    errorMessageWhileAddingFile,
    fileId,
    isOcr,
    loading,
    fileUploadSuccess,
    pdfFile,
    errorWhileLoadingFile,
    errorMessageWhileLoadingFile,
    imageSource,
    imageFiles,
    fileName,
    isFileUploadSuccess
  ];
}

final class FileStateInitial extends FileState {
  FileStateInitial({
    super.wantToAdd,
    super.allFilesForDocument,
    super.file,
    super.errorMessageWhileAddingFile,
    super.errorWhileAddingFile,
    super.fileId,
    super.isOcr,
    super.loading,
    super.fileUploadSuccess,
    super.pdfFile,
    super.errorMessageWhileLoadingFile,
    super.errorWhileLoadingFile,
    super.imageSource,
    super.imageFiles,
    super.fileName,
    super.isFileUploadSuccess
  });
}
