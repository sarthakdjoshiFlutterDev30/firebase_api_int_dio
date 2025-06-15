import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://firebaseapi-l60f.onrender.com/',
      headers: {'Content-Type': 'application/json'},
    ),
  );
  Future<void> signup(String email, String password) async {
    final res = await _dio.post(
      '/signup',
      data: {'email': email, 'password': password},
    );
    print("Signup successful: ${res.data}");
  }

  Future<void> login(String email, String password) async {
    final res = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', res.data['token']);
    if (kDebugMode) {
      print("Login successful: ${res.data}");
    }
    if (kDebugMode) {
      print("Login token: ${res.data['token']}");
    }
    if (kDebugMode) {
      print("Login successful, token saved.");
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> getItems() async {
    final token = await getToken();
    final res = await _dio.get(
      '/api/items',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data;
  }

  Future<void> createItem(Map<String, dynamic> itemData) async {
    final token = await getToken();
    await _dio.post(
      '/api/items',
      data: itemData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> deleteItem(String id) async {
    final token = await getToken();
    await _dio.delete(
      '/api/items/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<String?> uploadImage(File image) async {
    final token = await getToken();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final res = await _dio.post(
      '/api/upload-image',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    print("Image Url=${res.data['imageUrl']}");
    return res.data['imageUrl'];
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print("Logged out, token cleared.");
  }
}
