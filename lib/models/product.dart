import 'user.dart';

class Product {
  final String id;
  final String name;
  final String? code;
  final String? description;
  final double price;
  final double costPrice;
  final int quantity;
  final bool isLoan;
  final int reorderLevel;
  final String? unit;
  final String? category;
  final String branchId;
  final User? createdBy;
  final User? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final double? profit;
  final Branch? branch;

  Product({
    required this.id,
    required this.name,
    this.code,
    this.description,
    required this.price,
    required this.costPrice,
    required this.quantity,
    required this.isLoan,
    required this.reorderLevel,
    this.unit,
    this.category,
    required this.branchId,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.profit,
    this.branch,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      costPrice: double.tryParse(json['cost_price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      isLoan: json['is_loan'] == true || json['is_loan'] == 1,
      reorderLevel: int.tryParse(json['reorder_level']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString(),
      category: json['category']?.toString(),
      branchId: json['branch_id']?.toString() ?? '',
      createdBy: json['created_by'] != null && json['created_by'] is Map
          ? User.fromJson(json['created_by'])
          : null,
      updatedBy: json['updated_by'] != null && json['updated_by'] is Map
          ? User.fromJson(json['updated_by'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      profit: json['profit'] != null
          ? double.tryParse(json['profit'].toString())
          : null,
      branch: json['branch'] != null && json['branch'] is Map
          ? Branch.fromJson(json['branch'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'price': price,
      'cost_price': costPrice,
      'quantity': quantity,
      'is_loan': isLoan,
      'reorder_level': reorderLevel,
      'unit': unit,
      'category': category,
      'branch_id': branchId,
      'created_by': createdBy?.toJson(),
      'updated_by': updatedBy?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'profit': profit,
      'branch': branch?.toJson(),
    };
  }

  bool get isLowStock => quantity <= reorderLevel;
  bool get isOutOfStock => quantity <= 0;
}

class ProductStatistics {
  final int totalProducts;
  final int outOfStockProducts;
  final int lowStockProducts;
  final double inventoryValue;
  final double totalBuyingCost;
  final double totalProfitPotential;
  final int expiredProducts;
  final int expiringInWeek;
  final int expiringInMonth;
  final int expiringIn3Months;

  ProductStatistics({
    required this.totalProducts,
    required this.outOfStockProducts,
    required this.lowStockProducts,
    required this.inventoryValue,
    required this.totalBuyingCost,
    required this.totalProfitPotential,
    required this.expiredProducts,
    required this.expiringInWeek,
    required this.expiringInMonth,
    required this.expiringIn3Months,
  });

  factory ProductStatistics.fromJson(Map<String, dynamic> json) {
    return ProductStatistics(
      totalProducts: json['total_products'] ?? 0,
      outOfStockProducts: json['out_of_stock_products'] ?? 0,
      lowStockProducts: json['low_stock_products'] ?? 0,
      inventoryValue:
          double.tryParse(json['inventory_value']?.toString() ?? '0') ?? 0.0,
      totalBuyingCost:
          double.tryParse(json['total_buying_cost']?.toString() ?? '0') ?? 0.0,
      totalProfitPotential:
          double.tryParse(json['total_profit_potential']?.toString() ?? '0') ??
          0.0,
      expiredProducts: json['expired_products'] ?? 0,
      expiringInWeek: json['expiring_in_week'] ?? 0,
      expiringInMonth: json['expiring_in_month'] ?? 0,
      expiringIn3Months: json['expiring_in_3_months'] ?? 0,
    );
  }
}
