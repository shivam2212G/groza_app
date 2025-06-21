import 'dart:convert';
import 'package:groza/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? googleId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.googleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      googleId: json['google_id'],
    );
  }
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  final ApiService apiService;
  User? _currentUser;

  AuthService({required this.apiService});

  User? get currentUser => _currentUser;

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await apiService.post(
      '/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return _handleAuthResponse(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiService.post(
      '/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return _handleAuthResponse(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
    }
  }

  Map<String, dynamic> _handleAuthResponse(String responseBody) {
    final data = json.decode(responseBody);
    _storage.write(key: 'auth_token', value: data['access_token']);

    if (data['user'] != null) {
      _currentUser = User.fromJson(data['user']);
    }

    return data;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _currentUser = null;
  }

  Future<User?> fetchUserProfile() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await apiService.get(
        '/user',
        token: token,
      );

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(json.decode(response.body));
        return _currentUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}