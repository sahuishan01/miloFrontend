import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milo/features/auth/repositories/task_local.dart';
import 'package:milo/features/auth/repositories/task_remote.dart';
import 'package:milo/models/task_model.dart';

part 'task_state.dart';

class AddNewTaskCubit extends Cubit<AddNewTaskState> {
  AddNewTaskCubit() : super(AddNewTaskInitial());

  final taskRemote = TaskRemote();
  final taskLocal = TaskLocal();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required DateTime deadline,
    required String token,
    required String uid,
  }) async {
    try {
      emit(AddNewTaskLoading());
      final task = await taskRemote.createTask(
        title: title,
        description: description,
        color: color,
        deadline: deadline,
        token: token,
        uid: uid,
      );
      await taskLocal.insertTask(task);
      emit(AddNewTaskSuccess(task));
    } catch (e) {
      emit(AddNewTaskError(e.toString()));
    }
  }

  Future<void> syncTask({
    required String token,
  }) async {
    final unsyncedTasks = await taskLocal.getUnsyncedTasks();
    if (unsyncedTasks.isEmpty) {
      return;
    }
    final isSynced =
        await taskRemote.syncTask(token: token, tasks: unsyncedTasks);
    if (isSynced) {
      print("Synced Done");
      for (final task in unsyncedTasks) {
        taskLocal.updateRowValue(task.id, 1);
      }
    }
  }
}

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInital());

  final taskRemote = TaskRemote();
  final taskLocal = TaskLocal();

  Future<void> getTasks({
    required String token,
  }) async {
    try {
      emit(TaskLoading());
      final taskModels = await taskRemote.getTasks(token: token);
      if (taskModels.isEmpty) {
        final tasks = await taskLocal.getTasks();
        emit(TaskLoadSuccess(tasks));
        return;
      }
      await taskLocal.insertTasks(taskModels);
      emit(TaskLoadSuccess(taskModels));
    } catch (e) {
      print("Error from taskcubit: $e");
      final tasks = await taskLocal.getTasks();
      emit(TaskLoadSuccess(tasks));
    }
  }
}
