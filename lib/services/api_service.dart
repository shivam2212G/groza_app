import 'dart:convert';
import 'package:groza/models/category_model.dart';
import 'package:groza/models/subcategory_model.dart';
import 'package:groza/models/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.82.81:8000/api/user';

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
}