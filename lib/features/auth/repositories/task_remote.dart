import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:milo/core/constants/constants.dart';
import 'package:milo/core/constants/utilities.dart';
import 'package:milo/features/auth/repositories/task_local.dart';
import 'package:milo/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskRemote {
  final taskLocal = TaskLocal();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required Color color,
    required DateTime deadline,
    required String token,
    required String uid,
  }) async {
    try {
      final result = await http.post(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': ColorToStr(color),
          'deadline': deadline.toIso8601String(),
        }),
      );
      if (result.statusCode != 201) {
        throw jsonDecode(result.body)['error'];
      }
      return TaskModel.fromJson(result.body);
    } catch (e) {
      try {
        final taskModel = TaskModel(
            id: const Uuid().v6(),
            uid: uid,
            title: title,
            description: description,
            color: color,
            deadline: deadline,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: 0);
        await taskLocal.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
      final result = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (result.statusCode != 200) {
        throw Exception(
            "Somthing went wrong ${jsonDecode(result.body)["error"]}");
      }

      final listofTasks = jsonDecode(result.body);
      List<TaskModel> tasksList = [];
      for (var elem in listofTasks) {
        tasksList.add(TaskModel.fromMap(elem));
      }
      return tasksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> syncTask({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskList = [];
      for (final task in tasks) {
        taskList.add(task.toMap());
      }
      final result = await http.post(
        Uri.parse("${Constants.backendUri}/tasks/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(taskList),
      );
      if (result.statusCode != 201) {
        throw jsonDecode(result.body)['error'];
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
