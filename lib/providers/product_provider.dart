import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  ProductStatistics? _statistics;
  bool _isLoading = false;
  String? _error;
  String? _searchQuery;
  String? _selectedBranchId;

  List<Product> get products => _products;
  ProductStatistics? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get searchQuery => _searchQuery;
  String? get selectedBranchId => _selectedBranchId;

  Future<void> fetchProducts({
    String? branchId,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh || _products.isEmpty) {
      _setLoading(true);
    }
    _clearError();

    try {
      _selectedBranchId = branchId;
      _searchQuery = search;

      final result = await ApiService.getProducts(
        branchId: branchId,
        search: search,
      );

      _products = result['products'] as List<Product>;
      _statistics = result['statistics'] as ProductStatistics;
    } catch (e) {
      _setError('Failed to fetch products: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Product?> searchProductByCode(String code) async {
    _clearError();

    try {
      final product = await ApiService.searchProductByCode(code);
      return product;
    } catch (e) {
      _setError('Failed to search product: $e');
      return null;
    }
  }

  void clearProducts() {
    _products.clear();
    _statistics = null;
    _searchQuery = null;
    _selectedBranchId = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Filter products locally
  List<Product> getFilteredProducts({String? category, bool? lowStock}) {
    var filtered = _products.where((product) {
      bool matchesCategory = category == null || product.category == category;
      bool matchesLowStock =
          lowStock == null ||
          (lowStock ? product.isLowStock : !product.isLowStock);
      return matchesCategory && matchesLowStock;
    }).toList();

    return filtered;
  }

  // Get unique categories
  List<String> get categories {
    return _products
        .map((p) => p.category)
        .where((category) => category != null)
        .cast<String>()
        .toSet()
        .toList()
      ..sort();
  }
}
