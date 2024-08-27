part of 'document_bloc.dart';

class DocumentState extends Equatable{
  final bool wantToAdd;
  final List<DocumentTypeModel> allDocumentTypes;
  final DocumentModel document;
  final List<DocumentModel> userDocuments;
  final bool errorWhileAddingDocument;
  final String errorMessageWhileAddingDocument;
  final int expandedIndex;
  final int documentId;
  final bool loading;
  final int documentTypeId;
  final List<int>selectedDocumentIds;
  final bool isItemSelected;

  const DocumentState({
    this.wantToAdd = false,
    this.allDocumentTypes = const[],
    this.document = const DocumentModel(id: -1, description: "", document_type_id: -1, timestamp: null, user_id: -1),
    this.userDocuments = const[],
    this.errorWhileAddingDocument = false,
    this.errorMessageWhileAddingDocument = '',
    this.expandedIndex = -1,
    this.documentId = -1,
    this.loading = false,
    this.documentTypeId = -1,
    this.selectedDocumentIds = const [],
    this.isItemSelected = false
  });

  DocumentState copyWith({
    bool? wantToAdd,
    List<DocumentTypeModel>? allDocumentTypes,
    DocumentModel? document,
    List<DocumentModel>? userDocuments,
    bool? errorWhileAddingDocument,
    String? errorMessageWhileAddingDocument,
    int? expandedIndex,
    int? documentId,
    int? documentTypeId,
    bool? loading,
    List<int>? selectedDocumentIds,
    bool? isItemSelected
  }) {
    return DocumentState(
        wantToAdd: wantToAdd ?? this.wantToAdd,
        allDocumentTypes: allDocumentTypes ?? this.allDocumentTypes,
        document: document ?? this.document,
        userDocuments: userDocuments ?? List.from(this.userDocuments),
        errorWhileAddingDocument: errorWhileAddingDocument ??
            this.errorWhileAddingDocument,
        errorMessageWhileAddingDocument: errorMessageWhileAddingDocument ??
            this.errorMessageWhileAddingDocument,
        expandedIndex: expandedIndex ?? this.expandedIndex,
        documentId: documentId ?? this.documentId,
        loading: loading ?? this.loading,
        documentTypeId: documentTypeId ?? this.documentTypeId,
        selectedDocumentIds: selectedDocumentIds ?? this.selectedDocumentIds,
        isItemSelected: isItemSelected ?? this.isItemSelected
    );
  }

  @override
  List<Object?> get props => [
    wantToAdd,
    allDocumentTypes,
    document,
    userDocuments,
    errorWhileAddingDocument,
    errorMessageWhileAddingDocument,
    expandedIndex,
    documentId,
    loading,
    documentTypeId,
    selectedDocumentIds,
    isItemSelected
  ];
}

final class DocumentStateInitial extends DocumentState{
  const DocumentStateInitial({
    super.wantToAdd,
    super.allDocumentTypes,
    super.document,
    super.userDocuments,
    super.errorWhileAddingDocument,
    super.errorMessageWhileAddingDocument,
    super.expandedIndex,
    super.documentId,
    super.loading,
    super.documentTypeId,
    super.selectedDocumentIds,
    super.isItemSelected
  });
}