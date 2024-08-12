class DocumentModel{
  final int id;
  final String description;
  final int user_id;
  final int document_type_id;
  final DateTime? timestamp;

  const DocumentModel({
    required this.id,
    required this.description,
    required this.user_id,
    required this.document_type_id,
    this.timestamp,
  });

  List<Object?> get props => [id, description, user_id, document_type_id, timestamp];
}
