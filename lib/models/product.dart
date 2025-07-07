import 'user.dart';

class Product {
  final String id;
  final String name;
  final String code;
  final String? description;
  final double price;
  final double costPrice;
  final int quantity;
  final bool isLoan;
  final int reorderLevel;
  final String unit;
  final String category;
  final String branchId;
  final User? createdBy;
  final User? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final double profit;
  final Branch? branch;

  Product({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.price,
    required this.costPrice,
    required this.quantity,
    required this.isLoan,
    required this.reorderLevel,
    required this.unit,
    required this.category,
    required this.branchId,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.profit,
    this.branch,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      costPrice: double.parse(json['cost_price'].toString()),
      quantity: json['quantity'],
      isLoan: json['is_loan'],
      reorderLevel: json['reorder_level'],
      unit: json['unit'],
      category: json['category'],
      branchId: json['branch_id'],
      createdBy: json['created_by'] != null
          ? User.fromJson(json['created_by'])
          : null,
      updatedBy: json['updated_by'] != null
          ? User.fromJson(json['updated_by'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      profit: json['profit'].toDouble(),
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
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
      totalProducts: json['total_products'],
      outOfStockProducts: json['out_of_stock_products'],
      lowStockProducts: json['low_stock_products'],
      inventoryValue: json['inventory_value'].toDouble(),
      totalBuyingCost: json['total_buying_cost'].toDouble(),
      totalProfitPotential: json['total_profit_potential'].toDouble(),
      expiredProducts: json['expired_products'],
      expiringInWeek: json['expiring_in_week'],
      expiringInMonth: json['expiring_in_month'],
      expiringIn3Months: json['expiring_in_3_months'],
    );
  }
}
