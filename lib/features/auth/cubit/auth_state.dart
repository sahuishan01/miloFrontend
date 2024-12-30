part of "auto_cubit.dart";

sealed class AuthState {}

final class AuthInitial extends AuthState{}

final class AuthLoading extends AuthState{}

final class AuthSignup extends AuthState{}

final class AuthError extends AuthState{
  final String error;
  AuthError(this.error);
}

final class AuthLoggedin extends AuthState{
  final UserModel user;
  AuthLoggedin(this.user);
}