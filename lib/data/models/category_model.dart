class Category {
  final int categoryID;
  final String categoryName;
  final int? parentCategoryID; // Nullable olabilir
  // API'den gelen diğer alanlar eklenebilir (status vb.)

  Category({
    required this.categoryID,
    required this.categoryName,
    this.parentCategoryID,
  });

  // JSON'dan Category nesnesi oluşturmak için factory constructor
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryID: json['categoryID'] as int,
      categoryName: json['categoryName'] as String,
      parentCategoryID: json['parentCategoryID'] as int?,
    );
  }

  // Category nesnesini JSON'a dönüştürmek için metod (gerekirse)
  Map<String, dynamic> toJson() {
    return {
      'categoryID': categoryID,
      'categoryName': categoryName,
      'parentCategoryID': parentCategoryID,
    };
  }
}
