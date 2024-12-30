import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milo/features/auth/cubit/auto_cubit.dart';
import 'package:milo/features/auth/cubit/task_cubit.dart';
import 'package:milo/features/auth/pages/home.dart';
import 'package:milo/features/auth/pages/signup.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => AddNewTaskCubit()),
      BlocProvider(create: (_) => TaskCubit())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUserData();
    // final authLocal = AuthLocal();
    // authLocal.deleteUser();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Milo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, style: BorderStyle.solid, color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, style: BorderStyle.solid, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: Size(double.infinity, 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedin) {
            return const HomePage();
          }
          return const Signup();
        },
      ),
    );
  }
}
