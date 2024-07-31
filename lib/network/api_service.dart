import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://10.20.1.101:5039')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  factory ApiService.create({required String baseUrl}) {
    final dio = Dio();
    return _ApiService(dio, baseUrl: baseUrl);
  }

  @GET('/api/Documents')
  Future<List<DocumentsResponse>> getDocuments();
  @GET('/api/User')
  Future<List<UserResponse>> getUsers();
  @GET('/User/GetUserByEmail/{email}')
  Future<UserResponse> getUserByEmail(@Path('email') String email);
  @GET('/api/Documents/GetDocumentsByUser/{user_id}')
  Future<List<DocumentsResponse>> getDocumentsByUser(@Path('user_id') int userId);
  @POST('/api/Documents')
  Future<CreateDocumentRequest> createDocument(@Body() CreateDocumentRequest createDocumentRequest);
  @GET('/GetFilesByDocumentId/{document_id}')
  Future<List<FilesResponse>> getFilesForDocument(@Path('document_id') int documentId);
  @DELETE('/api/Documents/{document_id}')
  Future<int> deleteDocument(@Path('document_id') int documentId);
  @POST('/User/Register')
  Future<bool> registerUser(@Body() RegisterUserRequest registerUser);
  @POST('/User/ResendVerificationLink')
  Future<bool> resendVerificationLink(@Query('email') String email);
  @GET('/api/FileTypes')
  Future<List<FileTypesResponse>> getFileTypes();
  @GET('/api/DocumentTypes')
  Future<List<DocumentTypesResponse>> getDocumentTypes();
  @POST('/api/Files')
  Future<FilesResponse> createFile(@Body() FilesResponse file);
  @POST('/User/Login')
  Future<int> userLogin(@Body() UserLogin userLogin);
  @GET('/User/{id}')
  Future<UserResponse> getUserById(@Path('id') int id);
}

@JsonSerializable()
class DocumentTypesResponse{
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'active')
  final bool active;

  DocumentTypesResponse({
    required this.id,
    required this.title,
    required this.active
  });

  factory DocumentTypesResponse.fromJson(Map<String, dynamic> json) => _$DocumentTypesResponseFromJson(json);
  Map<String, dynamic>toJson() =>  _$DocumentTypesResponseToJson(this);
}
@JsonSerializable()
class FileTypesResponse{
  @JsonKey(name:'id')
  final int id;
  @JsonKey(name:'title')
  final String title;

  FileTypesResponse({
    required this.id,
    required this.title
  });

  factory FileTypesResponse.fromJson(Map<String, dynamic> json) => _$FileTypesResponseFromJson(json);
  Map<String, dynamic>toJson() =>  _$FileTypesResponseToJson(this);
}

@JsonSerializable()
class FilesResponse{
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'document_Id')
  final int documentId;
  @JsonKey(name: 'document_Type_Id')
  final int documentTypeId;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'file_Name')
  final String fileName;

  FilesResponse({
    required this.id,
    required this.documentId,
    required this.documentTypeId,
    required this.path,
    required this.fileName
  });

  factory FilesResponse.fromJson(Map<String, dynamic> json) => _$FilesResponseFromJson(json);
  Map<String, dynamic>toJson() =>  _$FilesResponseToJson(this);
}

@JsonSerializable()
class RegisterUserRequest{
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'password')
  final String password;

  RegisterUserRequest({
    required this.email,
    required this.name,
    required this.password,
  });

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) => _$RegisterUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterUserRequestToJson(this);
}
@JsonSerializable()
class CreateDocumentRequest {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'user_Id')
  final int userId;
  @JsonKey(name: 'document_Type_Id')
  final int documentTypeId;
  @JsonKey(name: 'timestamp')
  final DateTime timestamp;

  CreateDocumentRequest({
    required this.id,
    required this.description,
    required this.documentTypeId,
    required this.userId,
    required this.timestamp
  });

  factory CreateDocumentRequest.fromJson(Map<String, dynamic> json) => _$CreateDocumentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDocumentRequestToJson(this);
}
@JsonSerializable()
class DocumentsResponse {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'user_Id')
  final int userId;
  @JsonKey(name: 'document_Type_Id')
  final int documentTypeId;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'timestamp')
  final DateTime timestamp;

  DocumentsResponse({
    required this.id,
    required this.userId,
    required this.documentTypeId,
    required this.description,
    required this.timestamp,
  });

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) => _$DocumentsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentsResponseToJson(this);
}

@JsonSerializable()
class UserResponse{
  @JsonKey(name:'id')
  final int id;
  @JsonKey(name:'name')
  final String name;
  @JsonKey(name:'email')
  final String email;
  @JsonKey(name:'password')
  final String password;
  @JsonKey(name:'active')
  final bool active;
  @JsonKey(name:'activation_Code')
  final String activation_Code;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.active,
    required this.activation_Code,
  });
  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class UserLogin{
  @JsonKey(name:'email')
  final String email;
  @JsonKey(name:'password')
  final String password;

  UserLogin({
    required this.email,
    required this.password
  });
  factory UserLogin.fromJson(Map<String, dynamic> json) => _$UserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}



