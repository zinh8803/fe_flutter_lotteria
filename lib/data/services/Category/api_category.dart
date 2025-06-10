import 'dart:io';

import 'package:frontend_appflowershop/data/models/category.dart';
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class ApiService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.baseUrl}/categories'));

      print('Fetching categories from: ${Constants.baseUrl}/categories');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 200) {
          List<dynamic> data = jsonResponse['data'];
          return data.map((item) => CategoryModel.fromJson(item)).toList();
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load categories: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<void> createCategory({
    required String name,
    required String imagePath,
  }) async {
    // Kiểm tra tệp ảnh tồn tại và định dạng
    if (!File(imagePath).existsSync()) {
      print('ERROR: createCategory - Image file does not exist: $imagePath');
      throw Exception('Tệp ảnh không tồn tại');
    }

    final mimeType = lookupMimeType(imagePath);
    const allowedMimeTypes = ['image/jpeg', 'image/png'];
    const maxFileSize = 5 * 1024 * 1024; // 5MB

    if (!allowedMimeTypes.contains(mimeType)) {
      print('ERROR: createCategory - Invalid image type: $mimeType');
      throw Exception('Chỉ hỗ trợ ảnh JPEG hoặc PNG');
    }

    final fileSize = await File(imagePath).length();
    if (fileSize > maxFileSize) {
      print('ERROR: createCategory - Image file too large: ${fileSize} bytes');
      throw Exception('Kích thước ảnh không được vượt quá 5MB');
    }

    final token = await PreferenceService.getToken();
    if (token == null) {
      print('ERROR: createCategory - Token not found');
      throw Exception('Token không tồn tại');
    }

    var uri = Uri.parse('${Constants.baseUrl}/categories');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      'name': name,
    });

    if (imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType.parse(mimeType!),
        filename:
            'category_${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}',
      ));
    }

    print('INFO: createCategory - Sending POST request to $uri');
    print('INFO: createCategory - Headers: ${request.headers}');
    print('INFO: createCategory - Fields: ${request.fields}');
    print(
        'INFO: createCategory - Image file: $imagePath (size: $fileSize bytes, type: $mimeType)');

    try {
      final startTime = DateTime.now();
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      print('--- Create Category Response ---');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('Response time: $duration ms');

      if (response.statusCode == 201) {
        return; // Thành công
      } else {
        print(
            'ERROR: createCategory - Failed with status: ${response.statusCode}');
        print('ERROR: createCategory - Response body: ${response.body}');
        try {
          final json = jsonDecode(response.body);
          final errorMessage = json['message'] ?? 'Lỗi không xác định';
          throw Exception('Tạo danh mục thất bại: $errorMessage');
        } catch (_) {
          throw Exception(
              'Tạo danh mục thất bại: Server trả về lỗi ${response.statusCode}');
        }
      }
    } catch (e) {
      print('ERROR: createCategory - Exception: $e');
      throw Exception('Tạo danh mục thất bại: ${e.toString()}');
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    String? imagePath,
    String? currentImageUrl,
  }) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      print('ERROR: updateCategory - Token not found');
      throw Exception('Token không tồn tại');
    }

    var uri = Uri.parse('${Constants.baseUrl}/categories/$id');
    var request = http.MultipartRequest('PUT', uri);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      'name': name,
      if (currentImageUrl != null && imagePath == null)
        'image': currentImageUrl,
    });

    if (imagePath != null && imagePath.isNotEmpty) {
      // Kiểm tra tệp ảnh
      if (!File(imagePath).existsSync()) {
        print('ERROR: updateCategory - Image file does not exist: $imagePath');
        throw Exception('Tệp ảnh không tồn tại');
      }

      final mimeType = lookupMimeType(imagePath);
      const allowedMimeTypes = ['image/jpeg', 'image/png'];
      const maxFileSize = 5 * 1024 * 1024; // 5MB

      if (!allowedMimeTypes.contains(mimeType)) {
        print('ERROR: updateCategory - Invalid image type: $mimeType');
        throw Exception('Chỉ hỗ trợ ảnh JPEG hoặc PNG');
      }

      final fileSize = await File(imagePath).length();
      if (fileSize > maxFileSize) {
        print(
            'ERROR: updateCategory - Image file too large: ${fileSize} bytes');
        throw Exception('Kích thước ảnh không được vượt quá 5MB');
      }

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType.parse(mimeType!),
        filename:
            'category_${DateTime.now().millisecondsSinceEpoch}${path.extension(imagePath)}',
      ));

      print(
          'INFO: updateCategory - Image file: $imagePath (size: $fileSize bytes, type: $mimeType)');
    }

    print('INFO: updateCategory - Sending PUT request to $uri');
    print('INFO: updateCategory - Headers: ${request.headers}');
    print('INFO: updateCategory - Fields: ${request.fields}');

    try {
      final startTime = DateTime.now();
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      print('--- Update Category Response ---');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('Response time: $duration ms');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Thành công
      } else {
        print(
            'ERROR: updateCategory - Failed with status: ${response.statusCode}');
        print('ERROR: updateCategory - Response body: ${response.body}');
        try {
          final json = jsonDecode(response.body);
          final errorMessage = json['message'] ?? 'Lỗi không xác định';
          throw Exception('Cập nhật danh mục thất bại: $errorMessage');
        } catch (_) {
          throw Exception(
              'Cập nhật danh mục thất bại: Server trả về lỗi ${response.statusCode}');
        }
      }
    } catch (e) {
      print('ERROR: updateCategory - Exception: $e');
      throw Exception('Cập nhật danh mục thất bại: ${e.toString()}');
    }
  }

  Future<void> deleteCategory(int id) async {
    final token = await PreferenceService.getToken();
    if (token == null) {
      print('ERROR: deleteCategory - Token not found');
      throw Exception('Token not found');
    }

    final url = '${Constants.baseUrl}/categories/$id';
    print('INFO: deleteCategory - Sending DELETE request to $url');
    print('INFO: deleteCategory - Headers: {Authorization: Bearer $token}');

    try {
      final startTime = DateTime.now();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      print('INFO: deleteCategory - Response status: ${response.statusCode}');
      print('INFO: deleteCategory - Response body: ${response.body}');
      print('INFO: deleteCategory - Response time: $duration ms');

      if (response.statusCode != 200) {
        print(
            'ERROR: deleteCategory - Failed with status: ${response.statusCode}');
        print('ERROR: deleteCategory - Response body: ${response.body}');
        throw Exception('Failed to delete category: ${response.body}');
      }
    } catch (e) {
      print('ERROR: deleteCategory - Exception: $e');
      throw Exception('Failed to delete category: $e');
    }
  }
}
