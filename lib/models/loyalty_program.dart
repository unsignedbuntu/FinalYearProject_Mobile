class LoyaltyProgram {
  final int id;
  final String name;
  final String? description;
  final int points;
  final double discount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LoyaltyProgram({
    required this.id,
    required this.name,
    this.description,
    required this.points,
    required this.discount,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgram(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      points: json['points'],
      discount: json['discount'].toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'discount': discount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
