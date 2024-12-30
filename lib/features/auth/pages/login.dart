import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milo/features/auth/cubit/auto_cubit.dart';
import 'package:milo/features/auth/pages/home.dart';
import 'package:milo/features/auth/pages/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const Login());
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.validate();
    super.dispose();
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
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
        } else if (state is AuthLoggedin) {
          Navigator.pushAndRemoveUntil(context, HomePage.route(), (_) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.red,
            ),
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
                    "Login",
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
                    controller: _emailController,
                    textAlign: TextAlign.left,
                    autofillHints: ["email", "Email"],
                    decoration: const InputDecoration(hintText: "Email:"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                      if (value == null || value.isEmpty) {
                        return "8 chars, 1 cap, 1 small, 1 number, 1 special";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => {loginUser()},
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton(
                    onPressed: loginUser,
                    child: Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacement(Signup.route()),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                              text: 'Sign up',
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
