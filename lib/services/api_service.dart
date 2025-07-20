import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2/robot_cleaner"; // For emulator

  static Future<String> registerUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: {
        "username": username,
        "email": email,
        "password": password,
      },
    );

    return response.body;
  }

  static Future<String> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {
        "email": email,
        "password": password,
      },
    );

    return response.body;
  }

  static Future<String> insertBin(String bins, String date) async {
    final response = await http.post(
      Uri.parse("$baseUrl/insert_bins.php"),
      body: {
        "bins_filled": bins,
        "date_collected": date,
      },
    );

    return response.body;
  }

static Future<List<Map<String, dynamic>>> fetchBins() async {
  final response = await http.get(Uri.parse("$baseUrl/fetch_bins.php"));
  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  } else {
    return [];
  }
}
}