part of 'file_bloc.dart';

class FileState extends Equatable {
  //For adding a file
  final bool wantToAdd;
  //List of files based on documentId
  final List<FileModel> allFilesForDocument;
  //Getting an individual file
  final FileModel file;
  //If uploading a file for error logs
  final bool errorWhileAddingFile;
  final String errorMessageWhileAddingFile;
  //
  final int fileId;
  //For uploading a file, whether its an OCR file or not
  final bool isOcr;
  //When tapping a document, and fetching files for that document, if the files are still loading
  final bool loading;
  //For uploading a file, if it was a success or not
  final String fileUploadSuccess;
  final bool isFileUploadSuccess;
  //For opening a file
  final Uint8List pdfFile;
  //When opening a file if an error occured
  final bool errorWhileLoadingFile;
  final String errorMessageWhileLoadingFile;
  //If we're choosing an image from camera or gallery
  final ImageSource imageSource;
  //List of images later used for creating the document
  final List<File> imageFiles;
  //Used for displaying file name in file_view_page, and for editing a file's name
  final String fileName;
  //If the user wants to edit a file
  final bool wantsToEdit;
  //If the update was a success (only available for file name now)
  final bool updateSuccess;
  final String updateSuccessMessage;
  //If the file is still uploading
  final bool isUploading;
  //If the user changed their mind about creating a file
  final bool wantsToExit;
  //For loading one file
  final bool isFileLoaded;
  //Whether the edit was a success
  final bool isFileEditSuccess;
  //If the user wants to delete said file;
  final bool wantsToDelete;
  //If image to OCR generation was successful
  final bool isOcrConversionSuccess;
  //List of selected files, saved their id's
  final List<int>selectedFileIds;
  final bool isItemSelected;
  //If the user wants to download a file
  final bool wantsToDownloadFile;
  final bool fileDownloadSuccess;
  final String fileDownloadMessage;
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
    this.isFileUploadSuccess = false,
    this.wantsToEdit = false,
    this.updateSuccess = false,
    this.updateSuccessMessage = "",
    this.isUploading = false,
    this.wantsToExit = false,
    this.isFileEditSuccess = false,
    this.isFileLoaded = false,
    this.wantsToDelete = false,
    this.isOcrConversionSuccess = false,
    this.selectedFileIds = const [],
    this.isItemSelected = false,
    this.wantsToDownloadFile = false,
    this.fileDownloadMessage = "",
    this.fileDownloadSuccess = false
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
    bool? isFileUploadSuccess,
    bool? wantsToEdit,
    bool? updateSuccess,
    String? updateSuccessMessage,
    bool? isUploading,
    bool? wantsToExit,
    bool? isFileLoaded,
    bool? isFileEditSuccess,
    bool? wantsToDelete,
    bool? isOcrConversionSuccess,
    List<int>? selectedFileIds,
    bool? isItemSelected,
    bool? wantsToDownloadFile,
    bool? fileDownloadSuccess,
    String? fileDownloadMessage
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
        isFileUploadSuccess: isFileUploadSuccess ?? this.isFileUploadSuccess,
        wantsToEdit: wantsToEdit ?? this.wantsToEdit,
        updateSuccess: updateSuccess ?? this.updateSuccess,
        updateSuccessMessage: updateSuccessMessage ?? this.updateSuccessMessage,
        isUploading: isUploading ?? this.isUploading,
        wantsToExit: wantsToExit ?? this.wantsToExit,
        isFileEditSuccess: isFileEditSuccess ?? this.isFileEditSuccess,
        isFileLoaded: isFileLoaded ?? this.isFileLoaded,
        wantsToDelete: wantsToDelete ?? this.wantsToDelete,
        isOcrConversionSuccess: isOcrConversionSuccess ?? this.isOcrConversionSuccess,
        selectedFileIds: selectedFileIds ?? this.selectedFileIds,
        isItemSelected: isItemSelected ?? this.isItemSelected,
        wantsToDownloadFile: wantsToDownloadFile ?? this.wantsToDownloadFile,
        fileDownloadMessage: fileDownloadMessage ?? this.fileDownloadMessage,
        fileDownloadSuccess: fileDownloadSuccess ?? this.fileDownloadSuccess
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
    isFileUploadSuccess,
    wantsToEdit,
    updateSuccessMessage,
    updateSuccess,
    isUploading,
    wantsToExit,
    isFileLoaded,
    isFileEditSuccess,
    wantsToDelete,
    isOcrConversionSuccess,
    selectedFileIds,
    isItemSelected,
    wantsToDownloadFile,
    fileDownloadSuccess,
    fileDownloadMessage
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
    super.isFileUploadSuccess,
    super.wantsToEdit,
    super.updateSuccess,
    super.updateSuccessMessage,
    super.isUploading,
    super.wantsToExit,
    super.isFileEditSuccess,
    super.isFileLoaded,
    super.wantsToDelete,
    super.isOcrConversionSuccess,
    super.isItemSelected,
    super.wantsToDownloadFile,
    super.fileDownloadMessage,
    super.fileDownloadSuccess
  });
}
