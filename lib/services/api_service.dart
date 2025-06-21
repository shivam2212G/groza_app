import 'dart:convert';
import 'package:groza/models/category_model.dart';
import 'package:groza/models/subcategory_model.dart';
import 'package:groza/models/product_model.dart';
import 'package:groza/services/ip_storage.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String myip = IpManager.currentIp;
  static const String baseUrl = 'http://$myip:8000/api/user';
  static const auth_baseUrl = 'http://$myip:8000/api';

  Future<http.Response> post(String endpoint, {required Map<String, dynamic> body}) async {
    return await http.post(
      Uri.parse('$auth_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    return await http.get(
      Uri.parse('$auth_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Subcategory>> getSubcategories() async {
    final response = await http.get(Uri.parse('$baseUrl/subcategories'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Subcategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];
      return data.map((dynamic item) => Product.fromJson({
        ...item,
        // Provide default price if missing
        'product_price': item['product_price'] ?? 0.0,
      })).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Subcategory>> getSubcategoriesByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$categoryId/subcategories'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Subcategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load subcategories by category');
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$categoryId/products'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  Future<List<Product>> getProductsByCategoryAndSubcategory(int categoryId, int subcategoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$categoryId/$subcategoryId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products by category and subcategory');
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?query=$query'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['data'] as List).map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }

}


