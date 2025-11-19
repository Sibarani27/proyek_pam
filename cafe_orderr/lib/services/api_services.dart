import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";  // sesuaikan

  // LOGIN
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String token = data['token'];

      // SIMPAN TOKEN
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } else {
      return false;
    }
  }

  // REGISTER
  static Future<bool> register(String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    return response.statusCode == 200;
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
