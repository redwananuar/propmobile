class Contact {
  final String id;
  final String name;
  final String? company;
  final String email;
  final ContactType type;
  final String? phone;
  final String? address;
  final String? notes;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Contact({
    required this.id,
    required this.name,
    this.company,
    required this.email,
    required this.type,
    this.phone,
    this.address,
    this.notes,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String?,
      email: json['email'] as String,
      type: ContactType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ContactType.customer,
      ),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'email': email,
      'type': type.toString().split('.').last,
      'phone': phone,
      'address': address,
      'notes': notes,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Contact copyWith({
    String? id,
    String? name,
    String? company,
    String? email,
    ContactType? type,
    String? phone,
    String? address,
    String? notes,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      email: email ?? this.email,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ContactType {
  customer,
  technician,
  admin,
  supplier,
  contractor,
  others,
}

extension ContactTypeExtension on ContactType {
  String get displayName {
    switch (this) {
      case ContactType.customer:
        return 'Customer';
      case ContactType.technician:
        return 'Technician';
      case ContactType.admin:
        return 'Admin';
      case ContactType.supplier:
        return 'Supplier';
      case ContactType.contractor:
        return 'Contractor';
      case ContactType.others:
        return 'Others';
    }
  }

  String get databaseValue {
    switch (this) {
      case ContactType.customer:
        return 'customer';
      case ContactType.technician:
        return 'technician';
      case ContactType.admin:
        return 'admin';
      case ContactType.supplier:
        return 'supplier';
      case ContactType.contractor:
        return 'contractor';
      case ContactType.others:
        return 'others';
    }
  }
} 