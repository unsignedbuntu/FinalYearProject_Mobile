class Supplier {
  final int supplierID;
  final String supplierName;
  final String? contactEmail; // Nullable olabilir
  final bool? status; // Nullable olabilir

  Supplier({
    required this.supplierID,
    required this.supplierName,
    this.contactEmail,
    this.status,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    // Robust parsing for supplierID
    int supplierIdValue = 0; // Default value
    final rawId = json['supplierID'];
    if (rawId is int) {
      supplierIdValue = rawId;
    } else if (rawId is String) {
      supplierIdValue = int.tryParse(rawId) ?? 0;
    }
    // Add similar robust parsing for supplierName if needed
    String supplierNameValue = json['supplierName'] as String? ?? 'Unknown';

    return Supplier(
      supplierID: supplierIdValue, // Use the safely parsed value
      supplierName: supplierNameValue, // Use the safely parsed value
      contactEmail: json['contactEmail'] as String?,
      status: json['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierID': supplierID,
      'supplierName': supplierName,
      'contactEmail': contactEmail,
      'status': status,
    };
  }
}
