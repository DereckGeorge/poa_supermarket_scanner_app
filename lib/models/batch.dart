class Batch {
  final String? id;
  final String supplierName;
  final String branchId;
  final DateTime deliveryDate;
  final String supplierPhone;
  final String supplierEmail;
  final String supplierAddress;
  final List<BatchItem> items;

  Batch({
    this.id,
    required this.supplierName,
    required this.branchId,
    required this.deliveryDate,
    required this.supplierPhone,
    required this.supplierEmail,
    required this.supplierAddress,
    required this.items,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      supplierName: json['supplier_name'],
      branchId: json['branch_id'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      supplierPhone: json['supplier_phone'],
      supplierEmail: json['supplier_email'],
      supplierAddress: json['supplier_address'],
      items: (json['items'] as List)
          .map((item) => BatchItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier_name': supplierName,
      'branch_id': branchId,
      'delivery_date': deliveryDate.toIso8601String().split('T')[0],
      'supplier_phone': supplierPhone,
      'supplier_email': supplierEmail,
      'supplier_address': supplierAddress,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class BatchItem {
  final String? productId; // For existing products (restock)
  final String? name; // For new products
  final String? code;
  final String? description;
  final double? price;
  final double? costPrice;
  final int quantity;
  final int? reorderLevel;
  final String? unit;
  final String? category;
  final DateTime? expiryDate;
  final double? loanAmount;
  final double? loanPaid;
  final String? taxCode; // Tax code for the product

  BatchItem({
    this.productId,
    this.name,
    this.code,
    this.description,
    this.price,
    this.costPrice,
    required this.quantity,
    this.reorderLevel,
    this.unit,
    this.category,
    this.expiryDate,
    this.loanAmount,
    this.loanPaid,
    this.taxCode,
  });

  factory BatchItem.fromJson(Map<String, dynamic> json) {
    return BatchItem(
      productId: json['product_id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      price: json['price']?.toDouble(),
      costPrice: json['cost_price']?.toDouble(),
      quantity: json['quantity'],
      reorderLevel: json['reorder_level'],
      unit: json['unit'],
      category: json['category'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      loanAmount: json['loan_amount']?.toDouble(),
      loanPaid: json['loan_paid']?.toDouble(),
      taxCode: json['tax_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'quantity': quantity};

    if (productId != null) {
      // For existing products (restock)
      data['product_id'] = productId;
    } else {
      // For new products
      data['name'] = name;
      data['code'] = code;
      data['description'] = description;
      data['price'] = price;
      data['cost_price'] = costPrice;
      data['reorder_level'] = reorderLevel;
      data['unit'] = unit;
      data['category'] = category;
    }

    if (expiryDate != null) {
      data['expiry_date'] = expiryDate!.toIso8601String().split('T')[0];
    }
    if (loanAmount != null) {
      data['loan_amount'] = loanAmount;
    }
    if (loanPaid != null) {
      data['loan_paid'] = loanPaid;
    }
    if (taxCode != null) {
      data['tax_code'] = taxCode;
    }

    return data;
  }

  bool get isExistingProduct => productId != null;
  bool get isNewProduct => productId == null;
}
