import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milo/core/services/sp_service.dart';
import 'package:milo/features/auth/repositories/auth_local.dart';
import 'package:milo/features/auth/repositories/auth_remote.dart';
import 'package:milo/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authRemote = AuthRemoteRepository();
  final authLocal = AuthLocal();
  final spService = SpService();

  Future<UserModel?> checkLocalData() async {
    final user = await authLocal.getUser();
    return user;
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemote.getUserData();
      if (userModel != null) {
        authLocal.insertUser(userModel);
        emit(AuthLoggedin(userModel));
        return;
      }
      final user = await checkLocalData();
      if (user == null) {
        emit(AuthInitial());
      } else {
        emit(AuthLoggedin(user));
      }
    } catch (e) {
      final user = await checkLocalData();
      if (user == null) {
        emit(AuthInitial());
      } else {
        emit(AuthLoggedin(user));
      }
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemote.signUp(name: name, email: email, password: password);
      emit(AuthSignup());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel =
          await authRemote.login(email: email, password: password);
      if (userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
        emit(AuthLoggedin(userModel));
        await authLocal.insertUser(userModel);
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      await authLocal.deleteUser();
    }
  }

  void logout() async {
    try {
      emit(AuthLoading());
      await authLocal.deleteUser();
      print("logged out");
      emit(AuthInitial());
    } catch (e) {
      print(e);
      emit(AuthInitial());
    }
  }
}
