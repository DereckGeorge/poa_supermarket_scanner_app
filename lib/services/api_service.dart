import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';
import '../models/batch.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Authentication
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['access_token'] != null) {
        setToken(data['access_token']);
      }
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/logout'), headers: _headers);
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      clearToken();
    }
  }

  // Branches
  static Future<List<Branch>> getBranches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/branches'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final branches = (data['data']['branches'] as List)
            .map((branch) => Branch.fromJson(branch))
            .toList();
        return branches;
      } else {
        throw Exception('Failed to fetch branches: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch branches: ${response.body}');
    }
  }

  // Products
  static Future<Map<String, dynamic>> getProducts({
    String? branchId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (branchId != null) queryParams['branch_id'] = branchId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final uri = Uri.parse(
      '$baseUrl/products',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return {
          'statistics': ProductStatistics.fromJson(data['data']['statistics']),
          'products': (data['data']['products'] as List)
              .map((product) => Product.fromJson(product))
              .toList(),
        };
      } else {
        throw Exception('Failed to fetch products: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch products: ${response.body}');
    }
  }

  static Future<Product?> searchProductByCode(String code) async {
    try {
      final result = await getProducts(search: code);
      final products = result['products'] as List<Product>;
      return products.isNotEmpty ? products.first : null;
    } catch (e) {
      return null;
    }
  }

  // Batches
  static Future<Map<String, dynamic>> createBatch(Batch batch) async {
    final response = await http.post(
      Uri.parse('$baseUrl/batches'),
      headers: _headers,
      body: jsonEncode(batch.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create batch: ${response.body}');
    }
  }

  // Helper method to check if token is valid
  static Future<bool> isTokenValid() async {
    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
