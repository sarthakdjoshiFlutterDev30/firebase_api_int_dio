class Item_Model {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Item_Model({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Item_Model.fromJson(String id, Map<String, dynamic> json) {
    return Item_Model(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
