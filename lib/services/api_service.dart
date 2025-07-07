import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';
import '../models/batch.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://kilimolink.e-saloon.online/api';
  static String? _token;

  // Initialize API service and load stored token
  static Future<void> init() async {
    _token = await StorageService.getValidToken();
  }

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
        final token = data['access_token'];
        setToken(token);

        // Save token and user data with expiration
        await StorageService.saveAuthData(token, data);
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
      await StorageService.clearAuthData();
    }
  }

  // Check if user is already logged in
  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getValidToken();
    if (token != null) {
      setToken(token);
      return true;
    }
    return false;
  }

  // Refresh token expiry on activity
  static Future<void> refreshSession() async {
    if (_token != null) {
      await StorageService.refreshTokenExpiry();
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

    print('🚀 API Call: GET $uri');
    print('📤 Headers: $_headers');

    final response = await http.get(uri, headers: _headers);

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📊 Parsed JSON: $data');

      try {
        final statistics = ProductStatistics.fromJson(data['statistics']);
        print('✅ Statistics parsed successfully');

        // Handle paginated products response
        final productsData = data['products'];
        final productsList = productsData['data'] as List;
        print('📝 Products list length: ${productsList.length}');

        final products = <Product>[];
        for (int i = 0; i < productsList.length; i++) {
          try {
            print('🔍 Parsing product $i: ${productsList[i]}');
            final product = Product.fromJson(productsList[i]);
            products.add(product);
            print('✅ Product $i parsed successfully');
          } catch (e) {
            print('❌ Error parsing product $i: $e');
            print('📄 Product data: ${productsList[i]}');
            rethrow;
          }
        }

        return {'statistics': statistics, 'products': products};
      } catch (e) {
        print('❌ Error parsing response data: $e');
        rethrow;
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

  // Search product across all branches
  static Future<Map<String, dynamic>?> searchProductAcrossBranches(
    String code,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/products/search-across-branches',
    ).replace(queryParameters: {'search': code});

    print('🚀 API Call: GET $uri');
    print('📤 Headers: $_headers');

    final response = await http.get(uri, headers: _headers);

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📊 Parsed JSON: $data');

      if (data['success'] == true && data['data']['products'].isNotEmpty) {
        return data['data']['products'][0]; // Return first product found
      }
    }
    return null;
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
