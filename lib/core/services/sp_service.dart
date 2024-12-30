import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  Future<void> setToken(String token) async 
  {
    final pref = await SharedPreferences.getInstance();
    pref.setString("x-auth-token", token);
  }

  Future<String?> getToken() async
  {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("x-auth-token");
  }

  Future<void> removeToken() async
  {
    final pref = await SharedPreferences.getInstance();
    pref.remove("x-auth-token");
  }
}