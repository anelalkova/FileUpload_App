import 'dart:io';
import 'dart:typed_data';

import 'package:file_upload_app_part2/models/document.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../models/document_type.dart';

class DataService {
  Future<Response<List<DocumentsResponse>>> getDocumentsFromAPI() async {
    ApiService apiResponse = ApiService(Dio());
    try {
      var result = await apiResponse.getDocuments();
      return Response(success: true, result: result);
    } catch (e) {
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<List<UserResponse>>> getUsersFromAPI() async {
    ApiService apiResponse = ApiService(Dio());
    try {
      var result = await apiResponse.getUsers();
      return Response(success: true, result: result);
    } catch (e) {
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<UserResponse>> getUserByEmailFromAPI(String email) async {
    ApiService apiResponse = ApiService(Dio());
    try{
      var encodedEmail =  Uri.encodeComponent(email);
      var result = await apiResponse.getUserByEmail(encodedEmail);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<int>> userLogin(UserLogin user) async {
    ApiService apiResponse = ApiService(Dio());

    try {
      var result = await apiResponse.userLogin(user);
      return Response(success: true, result: result);
    } catch (e) {
      String? errorMessage;

      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
          errorMessage = e.response?.data.toString();
        } else {
          errorMessage = e.message;
        }
      } else {
        errorMessage = e.toString();
      }

      return Response(success: false, error: errorMessage);
    }
  }

  Future<Response<List<DocumentsResponse>>> getDocumentsByUser(int userId) async {
    ApiService apiResponse = ApiService(Dio());
    try {
      var result = await apiResponse.getDocumentsByUser(userId);
      print('Documents fetched: ${result.length}');
      return Response(success: true, result: result);
    } catch (e) {
      print('Error fetching documents: $e');
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<UserResponse>> getUserById(int id) async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.getUserById(id);
      return Response(success: true, result: result);
    }catch (e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<CreateDocumentRequest>> createDocument(CreateDocumentRequest createDocumentRequest)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.createDocument(createDocumentRequest);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<List<FilesResponse>>> getFilesForDocument(int documentId)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.getFilesForDocument(documentId);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<int>> deleteDocument(int documentId)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.deleteDocument(documentId);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<bool>> registerUser(RegisterUserRequest registerUser)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.registerUser(registerUser);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<bool>> resendVerificationLink(String email)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.resendVerificationLink(email);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<List<FileTypesResponse>>> getFileTypes()async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.getFileTypes();
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<List<DocumentTypesResponse>>>getDocumentTypes() async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.getDocumentTypes();
      return Response(success: true, result: result);
    }catch (e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<FilesResponse>> createFile(FilesResponse file) async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.createFile(file);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<Uint8List> convertImageToBytes(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes())!;
    final pngBytes = img.encodePng(image);
    return Uint8List.fromList(pngBytes);
  }

  Future<String> uploadImages(List<File> images, int documentTypeId, int documentId, String fileName) async {
    final uri = Uri.parse('http://10.20.1.101:5039/api/Files/Upload?documentType=$documentTypeId&documentId=$documentId&pdfName=$fileName');
    final request = http.MultipartRequest('POST', uri);

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return 'Images uploaded successfully: $responseBody';
      } else {
        return 'Failed to upload images: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error uploading images: $e';
    }
  }

  Future<String> ImageToOcr(
      File pdfFile,
      int documentTypeId,
      int documentId,
      String fileName,
      ) async {
    final uri = Uri.parse(
        'http://10.20.1.101:5039/api/Files/ImageToOcr?documentType=$documentTypeId&documentId=$documentId&pdfName=$fileName');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'pdf',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return 'PDF uploaded successfully: $responseBody';
      } else {
        return 'Failed to upload PDF: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error uploading PDF: $e';
    }
  }

  Future<String> ImageToPdf(List<File> images, String fileName, int documentTypeId, int documentId) async {
    final uri = Uri.parse(
        'http://10.20.1.101:5039/api/Files/ImageToPdf?documentType=$documentTypeId&documentId=$documentId&fileName=$fileName');
    final request = http.MultipartRequest('POST', uri);

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'imageFiles',
          image.path,
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return 'PDF created successfully: $responseBody';
      } else {
        return 'Failed to create PDF: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error creating PDF: $e';
    }
  }

  Future<Response<Uint8List>> getPDFBytes(int id) async {
    final String url = 'http://10.20.1.101:5039/api/Files/GetFile/$id';
    final Dio dio = Dio();

    try {
      final response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
      return Response(success: true, result: response.data);
    } catch (e) {
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<void>> deleteFile(int fileId) async{
    ApiService apiResponse = ApiService(Dio());
    try {
      await apiResponse.deleteFile(fileId);
      return Response(success: true);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }

  Future<void> downloadFile(int fileId) async {
    final Dio dio = Dio();
    final String url = 'http://10.20.1.101:5039/api/Files/GetFile/$fileId';

    try {
      final directory = await getExternalStorageDirectory();
     final downloadsDirectory = Directory('${directory?.path}/FileUploads');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      final filePath = '${downloadsDirectory.path}/file_$fileId.pdf';
      //se zacuvue u This PC\Anastasija's S22+\Internal storage\Android\data\com.example.file_upload_app_part2\files\FileUploads
      //ama ne moze da se otvore papkata na tel radi permisii na Android taka da na kompjuterot moze da se potvrde deka se siminja
      await dio.download(url, filePath);

      Fluttertoast.showToast(
        msg: "File downloaded to $filePath",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error downloading file: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      print("Error downloading file: $e");
    }
  }

  Future<Response<void>> updateUser(int id, UpdateUser updateUser)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      await apiResponse.updateUser(id, updateUser);
      return Response(success: true);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }


  //BLOC REQUESTS


  Future<List<DocumentTypeModel>> getDocumentTypesBLOC() async{
      var fetchedDocumentTypes = await getDocumentTypes();
      if(!fetchedDocumentTypes.success){
        print('Error fetching data: ${fetchedDocumentTypes.error.toString()}');
        throw Error();
      }

      List<DocumentTypesResponse> documentTypes = fetchedDocumentTypes.result!;

      return documentTypes
          .map((documentType) => DocumentTypeModel(
          id: documentType.id,
          title: documentType.title,
          active: documentType.active
          ))
          .toList();
  }

  Future<List<DocumentModel>> getDocumentsBLOC(int user_id) async {
    var fetchedDocuments = await getDocumentsByUser(user_id);
    if (!fetchedDocuments.success) {
      print("Error fetching data: ${fetchedDocuments.error.toString()}");
      throw Error();
    }
    List<DocumentsResponse> documents = fetchedDocuments.result!;

    List<DocumentModel> documentModels = documents
        .map((document) => DocumentModel(
        id: document.id,
        description: document.description,
        user_id: document.userId,
        document_type_id: document.documentTypeId,
        timestamp: document.timestamp))
        .toList();

    documentModels.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

    return documentModels;
  }

  Future<Response<List<DocumentsResponse>>> getDocumentsByUserBLOC(int userId) async {
    ApiService apiResponse = ApiService(Dio());
    try {
      var result = await apiResponse.getDocumentsByUser(userId);
      print('Documents fetched: ${result.length}');
      return Response(success: true, result: result);
    } catch (e) {
      print('Error fetching documents: $e');
      return Response(success: false, error: e.toString());
    }
  }

  Future<Response<void>> deleteUser(int userId) async{
    ApiService apiResponse = ApiService(Dio());
    try{
      await apiResponse.deleteUser(userId);
      return Response(success: true);
    }catch(e){
      return Response(success: false);
    }
  }

  Future<Response<int>> getDocumentSizeBLOC(int id) async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.getDocumentSize(id);
      return Response(success: true, result: result);
    }catch(e){
      return Response(success: false, error: e.toString());
    }
  }
}


class Response<T> {
  final bool success;
  final String? error;
  final T? result;

  Response({required this.success, this.error, this.result});
}