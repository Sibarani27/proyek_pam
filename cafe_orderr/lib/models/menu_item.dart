// lib/models/menu_item.dart
class MenuItem {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl; // Pastikan sesuai dengan 'image_url' dari Laravel
  // final String? category; // Jika ada di Laravel

  MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    // this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(), // Pastikan double
      imageUrl: json['image_url'], // Sesuaikan dengan 'image_url'
      // category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      // 'category': category,
    };
  }
}