import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:milo/core/constants/constants.dart';
import 'package:milo/core/services/sp_service.dart';
import 'package:milo/models/user_model.dart';

class AuthRemoteRepository {
  final spService = SpService();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/auth/signup"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name, "password": password, "email": email}),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"password": password, "email": email}),
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse(
          "${Constants.backendUri}/auth/validateToken",
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (res.statusCode != 200) {
        return null;
      }

      final user = await http.get(
        Uri.parse(
          "${Constants.backendUri}/auth",
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (user.statusCode != 200) {
        throw jsonDecode(user.body)['error'];
      }
      return UserModel.fromJson(user.body);
    } catch (e) {
      return null;
    }
  }
}
