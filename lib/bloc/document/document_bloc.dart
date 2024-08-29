import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';

import '../../models/document.dart';
import '../../models/document_type.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState>{
  DocumentBloc() : super(const DocumentStateInitial(userDocuments: [])) {
    on<UserWantsToAddDocument>(userWantsToAddDocumentEvent);
    on<AddDocument>(addDocumentEvent);
    on<GetDocuments>(getDocuments);
    on<GetDocumentType>(getDocumentTypes);
    on<DocumentIsTapped>(documentIsTapped);
    on<DeleteDocument>(deleteDocument);
    on<UpdateSelectedDocumentIds>(updateSelectedDocumentIdsEvent);
    on<SelectItem>(selectItemEvent);
    on<ClearSelectedItems>(clearSelectedItemsEvent);
    on<ReturnDocumentInitialState>(returnToInitialState);
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
    }finally{
      emit(state.copyWith(wantToAdd: false, errorMessageWhileAddingDocument: "", errorWhileAddingDocument: false));
    }
  }

  FutureOr<void> getDocuments(GetDocuments event, Emitter<DocumentState> emit)async{
    emit(state.copyWith(loading: true));
    try{
      List<DocumentModel> documents = await DataService().getDocumentsBLOC(event.user_id);
      emit(state.copyWith(userDocuments: documents, loading: false));
    }catch(e){
      emit(state.copyWith(errorWhileLoadingDocuments: true, errorMessagesWhileLoadingDocuments: e.toString(), loading: false));
    }finally{
      emit(state.copyWith(errorWhileLoadingDocuments: false, errorMessagesWhileLoadingDocuments: "", loading: false));
    }
  }

  FutureOr<void> getDocumentTypes(GetDocumentType event, Emitter<DocumentState> emit) async {
    try {
      List<DocumentTypeModel> documentTypes = await DataService().getDocumentTypesBLOC();
      emit(state.copyWith(allDocumentTypes: documentTypes));
    } catch (error) {
      emit(state.copyWith(
          errorWhileLoadingDocumentTypes: true,
          errorMessageWhileLoadingDocumentTypes: error.toString()
      ));
    }
  }

  Future<void>updateSelectedDocumentIdsEvent(UpdateSelectedDocumentIds event, Emitter<DocumentState>emit)async{
    List<int> documentIds = List<int>.from(event.documentIds ?? []);
    if(documentIds.contains(event.newDocumentId)){
      documentIds.remove(event.newDocumentId);
    }else {
      documentIds.add(event.newDocumentId);
    }
    emit(state.copyWith(selectedDocumentIds: documentIds));
  }

  void documentIsTapped(DocumentIsTapped event, Emitter<DocumentState> emit)async{
    emit(state.copyWith(documentId: event.documentId, documentTypeId: event.documentTypeId));
  }

  void selectItemEvent(SelectItem event, Emitter<DocumentState> emit)async{
    emit(state.copyWith(isItemSelected: !state.isItemSelected));
  }

  void clearSelectedItemsEvent(ClearSelectedItems event, Emitter<DocumentState>emit){
    emit(state.copyWith(selectedDocumentIds: []));
  }

  void returnToInitialState(ReturnDocumentInitialState event, Emitter<DocumentState>emit){
    emit(DocumentStateInitial());
  }
}