class User {
  final String id;
  final String name;
  final String email;
  final String position;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Branch? branch;
  final String? approvedBy;
  final DateTime? approvedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.branch,
    this.approvedBy,
    this.approvedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      branch: json['branch'] != null && json['branch'] is Map
          ? Branch.fromJson(json['branch'])
          : null,
      approvedBy: json['approved_by']?.toString(),
      approvedAt: json['approved_at'] != null
          ? DateTime.tryParse(json['approved_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'branch': branch?.toJson(),
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
    };
  }
}

class Branch {
  final String id;
  final String name;
  final String location;
  final String contactNumber;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.contactNumber,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      contactNumber: json['contact_number']?.toString() ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contact_number': contactNumber,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
