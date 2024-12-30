import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:milo/features/auth/cubit/auto_cubit.dart';
import 'package:milo/features/auth/pages/login.dart';

class Signup extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Signup());
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final _passwordRegex = RegExp(
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _formKey.currentState?.validate();
    super.dispose();
  }

  void signupUser() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is AuthSignup) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Signup successful, kindly login!")));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xFF000000),
                      letterSpacing: 1.8,
                      wordSpacing: 2.2,
                      textBaseline: TextBaseline.alphabetic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _nameController,
                    textAlign: TextAlign.left,
                    autofillHints: ["name", "Name"],
                    decoration: InputDecoration(hintText: "Name:"),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return "Name should be greater than 3 letters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    textAlign: TextAlign.left,
                    autofillHints: ["email", "Email"],
                    decoration: const InputDecoration(hintText: "Email:"),
                    validator: (value) {
                      if (value == null || !_emailRegex.hasMatch(value)) {
                        return "Enter valid email address";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    textAlign: TextAlign.left,
                    autofillHints: ["password", "Password"],
                    decoration: const InputDecoration(hintText: "Password:"),
                    validator: (value) {
                      if (value == null || !_passwordRegex.hasMatch(value)) {
                        return "8 chars, 1 cap, 1 small, 1 number, 1 special";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton(
                    onPressed: signupUser,
                    child:
                        Text("SignUp", style: TextStyle(color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(Login.route()),
                    child: RichText(
                      text: TextSpan(
                        text: "Alread have an account? ",
                        children: [
                          TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ))
                        ],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                ]),
          ),
        );
      },
    ));
  }
}
