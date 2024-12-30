// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:milo/core/constants/utilities.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final Color color;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.color,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    Color? color,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'hexColor': ColorToStr(color),
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? "",
      uid: map['uid'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      color: StrToColor(map['hexColor']),
      deadline: DateTime.parse(map['deadline']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map["isSynced"] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, description: $description, color: $color, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.color == color &&
        other.deadline == deadline &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        color.hashCode ^
        deadline.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }
}
