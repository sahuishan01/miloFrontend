// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;
  final int? age;
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
    this.age,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
    int? age,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
      'age': age,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? "",
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      token: map['token'] ?? "",
      age: map['age'] != null ? map['age'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, token: $token, age: $age)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.token == token &&
        other.age == age;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        token.hashCode ^
        age.hashCode;
  }
}
