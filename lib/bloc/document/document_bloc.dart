import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';

import '../../models/document.dart';
import '../../models/document_type.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState>{
  List<DocumentModel> lastDocuments = [];

  DocumentBloc() : super(const DocumentStateInitial(userDocuments: [])) {
    on<UserWantsToAddDocument>(userWantsToAddDocumentEvent);
    on<AddDocument>(addDocumentEvent);
    on<GetDocuments>(getDocuments);
    on<GetDocumentType>(getDocumentTypes);
    on<ErrorWhileAddingDocument>(errorWhileAddingDocument);
    on<DocumentIsTapped>(documentIsTapped);
    on<DeleteDocument>(deleteDocument);
  }

  Future<void> deleteDocument(DeleteDocument event, Emitter<DocumentState> emit) async{
    await DataService().deleteDocument(event.id);
    emit(state.copyWith(userDocuments: state.userDocuments.where((element) => element.id != event.id).toList()));
  }

  Future<void> userWantsToAddDocumentEvent(UserWantsToAddDocument event, Emitter <DocumentState> emit) async{
    emit(state.copyWith(wantToAdd: event.wantToAdd));
  }

  void addDocumentEvent(AddDocument event, Emitter<DocumentState> emit) async {
    try {
      DataService().createDocument(CreateDocumentRequest(
        id: event.document.id,
        description: event.document.description,
        documentTypeId: event.document.document_type_id,
        userId: event.document.user_id,
        timestamp: event.document.timestamp,
      ));

      List<DocumentModel> currentDocuments = List.from(state.userDocuments);
      currentDocuments.add(event.document);

      emit(state.copyWith(
        wantToAdd: false,
        errorMessageWhileAddingDocument: null,
        errorWhileAddingDocument: false,
        userDocuments: currentDocuments,
      ));
    } catch (error) {
      emit(state.copyWith(
        wantToAdd: false,
        errorWhileAddingDocument: true,
        errorMessageWhileAddingDocument: error.toString(),
      ));
    }
  }

  FutureOr<void> getDocuments(GetDocuments event, Emitter<DocumentState> emit)async{
    List<DocumentModel> documents = await DataService().getDocumentsBLOC(event.user_id);
    var document = documents.reversed.toList();
    emit(state.copyWith(userDocuments: document, loading: false));
  }

  FutureOr<void> getDocumentTypes(GetDocumentType event, Emitter<DocumentState> emit) async {
    try {
      List<DocumentTypeModel> documentTypes = await DataService().getDocumentTypesBLOC();
      emit(state.copyWith(allDocumentTypes: documentTypes));
    } catch (error) {
      emit(state.copyWith(
          errorWhileAddingDocument: true,
          errorMessageWhileAddingDocument: error.toString()
      ));
    }
  }


  void errorWhileAddingDocument(ErrorWhileAddingDocument event, Emitter<DocumentState> emit) async{
    emit(state.copyWith(errorWhileAddingDocument: true, errorMessageWhileAddingDocument: event.error, wantToAdd: false));
  }

  void documentIsTapped(DocumentIsTapped event, Emitter<DocumentState> emit)async{
    emit(state.copyWith(documentId: event.documentId, documentTypeId: event.documentTypeId));
  }
}