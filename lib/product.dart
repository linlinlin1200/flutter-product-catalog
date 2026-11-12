class Product {
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final double discount;
  final double rating;
  final int stock;

  const Product({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.discount,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      price: (json['price'] as num).toDouble(),
      discount: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
    );
  }

  double get salePrice => price * (1 - discount / 100);
}
