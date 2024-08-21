part of 'document_bloc.dart';

class DocumentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserWantsToAddDocument extends DocumentEvent{
  final bool wantToAdd;

  UserWantsToAddDocument({required this.wantToAdd});
}

class AddDocument extends DocumentEvent{
  final DocumentModel document;

  AddDocument({
    required this.document,
  });
}

class GetDocuments  extends DocumentEvent {
  final int user_id;

  GetDocuments({
    required this.user_id,
  });
}

class GetDocumentType extends DocumentEvent {}

class ErrorWhileAddingDocument extends DocumentEvent {
  final String? error;

  ErrorWhileAddingDocument({this.error});
}

class DocumentIsTapped extends DocumentEvent {
  final int documentId;
  final int documentTypeId;

  DocumentIsTapped({required this.documentId, required this.documentTypeId});
}

class DeleteDocument extends DocumentEvent{
  final int id;

  DeleteDocument({required this.id});
}

class LoadingDocuments extends DocumentEvent{
  final bool loading;

  LoadingDocuments({required this.loading});
}
