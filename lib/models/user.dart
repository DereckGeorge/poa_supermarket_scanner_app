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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      branch: json['branch'] != null ? Branch.fromJson(json['branch']) : null,
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
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
  final DateTime createdAt;
  final DateTime updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.contactNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      contactNumber: json['contact_number'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contact_number': contactNumber,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
