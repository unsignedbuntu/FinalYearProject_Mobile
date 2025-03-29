class ImageCache {
  final int? id;
  final String pageId;
  final String prompt;
  final String? image;
  final DateTime? createdAt;

  ImageCache({
    this.id,
    required this.pageId,
    required this.prompt,
    this.image,
    this.createdAt,
  });

  factory ImageCache.fromJson(Map<String, dynamic> json) {
    return ImageCache(
      id: json['id'],
      pageId: json['pageID'],
      prompt: json['prompt'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageID': pageId,
      'prompt': prompt,
      'image': image,
      'checkOnly': false,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCheckJson() {
    return {'pageID': pageId, 'prompt': prompt, 'checkOnly': true};
  }
}
