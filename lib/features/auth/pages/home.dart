import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:milo/core/constants/utilities.dart';
import 'package:milo/features/auth/cubit/auto_cubit.dart';
import 'package:milo/features/auth/cubit/task_cubit.dart';
import 'package:milo/features/auth/pages/login.dart';
import 'package:milo/features/auth/pages/new_task.dart';
import 'package:milo/home/widgets/date_selector.dart';
import 'package:milo/home/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authCubit = AuthCubit();
  DateTime selectedDate = DateTime.now();

  void logout() {
    context.read<AuthCubit>().logout();
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedin;
    context.read<TaskCubit>().getTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        await context.read<AddNewTaskCubit>().syncTask(token: user.user.token);
      }
    });
  }

  void onDateChange(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushReplacement(context, Login.route());
        }
      },
      builder: (context, state) {
        if (state is AuthLoggedin) {
          return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: logout,
                      child: Text(
                        state.user.name,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const Text(
                      "My Tasks",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const Text("")
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () =>
                          {Navigator.push(context, NewTask.route())},
                      icon: Icon(CupertinoIcons.add_circled))
                ],
              ),
              body: Column(children: [
                DateSelector(
                  selectedDate: selectedDate,
                  onDateChange: onDateChange,
                ),
                BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TaskLoadError) {
                    return Expanded(
                      child: Center(
                        child: Text(state.e),
                      ),
                    );
                  } else if (state is TaskLoadSuccess) {
                    final tasks = state.taskList.where(
                      (elem) {
                        return DateFormat.yMMMd().format(elem.deadline) ==
                            DateFormat.yMMMd().format(selectedDate);
                      },
                    ).toList();
                    tasks.sort(
                      (a, b) => a.deadline.compareTo(b.deadline),
                    );
                    return Expanded(
                      child: tasks.isEmpty
                          ? Center(
                              child: Text("No deadlines today!"),
                            )
                          : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, idx) {
                                final task = tasks[idx];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TaskCard(
                                        color: task.color,
                                        headerText: task.title,
                                        description: task.description,
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color:
                                              strngthenColor(task.color, 0.6),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        DateFormat.jm().format(task.deadline),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                    );
                  }

                  return Expanded(
                      child: Center(child: Text("No task for today!")));
                })
              ]));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(""),
          ),
          body: const Center(
            child: Text("Welcome to home page, please login!"),
          ),
        );
      },
    );
  }
}
