import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:milo/features/auth/cubit/auto_cubit.dart';
import 'package:milo/features/auth/cubit/task_cubit.dart';
import 'package:milo/features/auth/pages/home.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const NewTask());
  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Color _selectedColor = Colors.orange;
  Color _displayColor = Color.from(
      alpha: 0.25,
      red: Colors.orange.r,
      green: Colors.orange.g,
      blue: Colors.orange.b);
  final formKey = GlobalKey<FormState>();

  void createNewTask() async {
    AuthLoggedin user = context.read<AuthCubit>().state as AuthLoggedin;

    if (formKey.currentState!.validate()) {
      await context.read<AddNewTaskCubit>().createNewTask(
            uid: user.user.id,
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            color: _selectedColor,
            deadline: _selectedDate,
            token: user.user.token,
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _displayColor,
        title: Center(child: const Text(" New Task")),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () async {
                final selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    currentDate: _selectedDate,
                    builder: (context, child) {
                      return Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.dark(
                              brightness:
                                  MediaQuery.platformBrightnessOf(context),
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!);
                    });
                if (selectedDate != null) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                }
              },
              child: Text(
                DateFormat("dd-MM-yy").format(_selectedDate),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<AddNewTaskCubit, AddNewTaskState>(
        listener: (context, state) {
          if (state is AddNewTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.e),
                duration: Duration(seconds: 15),
              ),
            );
          } else if (state is AddNewTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Task added successfuly"),
              ),
            );
            Navigator.pushAndRemoveUntil(
                context, HomePage.route(), (_) => false);
          }
        },
        builder: (context, state) {
          if (state is AddNewTaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                color: _displayColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description cannot be empty";
                        }
                        return null;
                      },
                    ),
                    ColorPicker(
                        color: _selectedColor,
                        heading: Text("Select Color"),
                        subheading: Text("Select a different shade"),
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                        },
                        onColorChanged: (Color color) => setState(() {
                              _selectedColor = color;
                              _displayColor = Color.from(
                                  alpha: 0.25,
                                  red: color.r,
                                  green: color.g,
                                  blue: color.b);
                            })),
                    ElevatedButton(
                      onPressed: createNewTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _displayColor,
                      ),
                      child: const Text("Submit",
                          style: TextStyle(color: Colors.black)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
