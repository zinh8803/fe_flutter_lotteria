import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:frontend_appflowershop/data/models/employee.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  Future<UserModel> login(String email, String password) async {
    try {
      final String url = "${Constants.baseUrl}/users/login";

      // Log request information
      print('LOGIN REQUEST:');
      print('URL: $url');
      print('Headers: ${{'Content-Type': 'application/json'}}');

      // Create request body and log it
      final body = jsonEncode({'email': email, 'password': password});
      print('Request Body: $body');

      // Make the API call
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Log response details
      print('LOGIN RESPONSE:');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        final token = jsonData['token'];

        final user = UserModel.fromJson(data, token);
        print('Login successful. User: $user');
        return user;
      } else {
        // Try to parse error message from response if possible
        String errorMessage = 'Đăng nhập thất bại';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson.containsKey('message')) {
            errorMessage = 'Đăng nhập thất bại';
          } else if (errorJson.containsKey('error')) {
            errorMessage = 'Đăng nhập thất bại';
          }
        } catch (e) {
          print('Could not parse error response: $e');
        }

        print('Login failed with error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception during login: $e');
      if (e is SocketException) {
        throw Exception(
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.');
      } else if (e is TimeoutException) {
        throw Exception(
            'Yêu cầu đăng nhập hết thời gian. Vui lòng thử lại sau.');
      } else if (e is FormatException) {
        throw Exception('Định dạng dữ liệu không hợp lệ: ${e.message}');
      }
      rethrow;
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    final String url = "${Constants.baseUrl}/users/register";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );
    print('Register response: ${response.statusCode}, ${response.body}');
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 201) {
        return UserModel.fromJson(jsonData['data'], jsonData?['token']);
      } else {
        throw Exception('Đăng ký thất bại: ${jsonData['message']}');
      }
    } else if (response.statusCode == 422) {
      final jsonData = jsonDecode(response.body);
      throw Exception('Email đã tồn tại: ${jsonData['message']}');
    } else {
      throw ('Email đã tồn tại');
    }
  }

  Future<void> changePassword({
    required String newPassword,
  }) async {
    final token = await PreferenceService.getToken();
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/users/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Đổi mật khẩu thất bại');
    }
  }

  Future<dynamic> getUserProfile() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/users/detail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetching user profile from: ${Constants.baseUrl}/users/detail');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];

        final user = UserModel.fromJson(data, token);
        print('Returning UserModel: $user');
        return user;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
    required String address,
    required String phoneNumber,
  }) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response =
        await http.put(Uri.parse('${Constants.baseUrl}/users/update'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'username': name,
              'email': email,
              'address': address,
              'phone_number': phoneNumber,
            }));

    print('Update user profile response: ${response.body}');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json['data'], token);
    } else {
      throw Exception('Failed to update user profile');
    }
  }

  Future<String> updateAvatar(String filePath) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${Constants.baseUrl}/users/update-avatar'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        filePath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('Update avatar response: ${responseBody.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(responseBody.body);
      return json['data']['avatar'] as String;
    } else {
      final json = jsonDecode(responseBody.body);
      throw Exception(
          'Failed to update avatar: ${json['message'] ?? responseBody.reasonPhrase}');
    }
  }

  Future<void> logout() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/users/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Logout request to: ${Constants.baseUrl}/logout');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] != 200) {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to logout: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }
}
