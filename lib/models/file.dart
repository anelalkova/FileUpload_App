class FileModel{
  final int id;
  final String? file_name;
  final String? path;
  final int? document_id;
  final int? document_type_id;

  FileModel({
    required this.id,
    this.file_name,
    this.path,
    this.document_id,
    this.document_type_id,
  });
}