part of 'task_cubit.dart';

sealed class AddNewTaskState {
  const AddNewTaskState();
}

final class AddNewTaskInitial extends AddNewTaskState {}

final class AddNewTaskLoading extends AddNewTaskState {}

final class AddNewTaskError extends AddNewTaskState {
  final String e;
  const AddNewTaskError(this.e);
}

final class AddNewTaskSuccess extends AddNewTaskState {
  final TaskModel taskModel;
  const AddNewTaskSuccess(this.taskModel);
}

sealed class TaskState {
  const TaskState();
}

final class TaskInital extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoadError extends TaskState {
  final String e;
  const TaskLoadError(this.e);
}

final class TaskLoadSuccess extends TaskState {
  final List<TaskModel> taskList;
  const TaskLoadSuccess(this.taskList);
}
