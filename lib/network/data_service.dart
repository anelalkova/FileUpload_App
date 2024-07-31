import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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

  Future<Response<int>> userLogin(UserLogin user)async{
    ApiService apiResponse = ApiService(Dio());
    try{
      var result = await apiResponse.userLogin(user);
      return Response(success: true, result: result);
    }catch (e){
      return Response(success: false, error: e.toString());
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
        'pdf', // Use the field name expected by the server
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
        'http://10.20.1.101:5039/api/Files/ImageToPdf?documentType=$documentTypeId&documentId=$documentId&pdfName=$fileName');
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
}


class Response<T> {
  final bool success;
  final String? error;
  final T? result;

  Response({required this.success, this.error, this.result});
}