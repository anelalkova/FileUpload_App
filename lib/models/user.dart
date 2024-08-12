class UserModel{
  final int id;
  final String? name;
  final String? email;
  final String? activation_code;
  final bool? active;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.activation_code,
    this.active,
  });
}