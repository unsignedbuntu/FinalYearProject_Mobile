class Store {
  final int storeID;
  final String storeName;
  // API'den gelen diğer alanlar eklenebilir (rating, status vb.)
  final double? rating; // Rating eklendi (örnek)

  Store({required this.storeID, required this.storeName, this.rating});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeID: json['storeID'] as int,
      storeName: json['storeName'] as String,
      // Rating alanı varsa JSON'dan oku
      rating: (json['rating'] as num?)?.toDouble(), // double veya null olabilir
    );
  }

  Map<String, dynamic> toJson() {
    return {'storeID': storeID, 'storeName': storeName, 'rating': rating};
  }
}
