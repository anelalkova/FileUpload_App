class FileModel{
  final int id;
  final String file_name;
  final String path;
  final int document_id;
  final int document_type_id;

  const FileModel({
    required this.id,
    required this.file_name,
    required this.path,
    required this.document_id,
    required this.document_type_id,
  });

  List<Object?> get props => [id, file_name, path, document_id, document_type_id];
}