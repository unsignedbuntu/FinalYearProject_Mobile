class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final List<AddressModel>? addresses;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.addresses,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      addresses:
          json['addresses'] != null
              ? List<AddressModel>.from(
                json['addresses'].map((x) => AddressModel.fromJson(x)),
              )
              : null,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'addresses': addresses?.map((e) => e.toJson()).toList(),
      'isVerified': isVerified,
    };
  }
}

class AddressModel {
  final String id;
  final String title;
  final String fullName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phoneNumber;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullName,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phoneNumber,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      fullName: json['fullName'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      phoneNumber: json['phoneNumber'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fullName': fullName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
    };
  }
}
