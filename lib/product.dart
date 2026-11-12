enum ProductCategory {
  laptops('laptops', 'Laptops'),
  phones('smartphones', 'Phones'),
  tablets('tablets', 'Tablets'),
  accessories('mobile-accessories', 'Accessories');

  final String key;
  final String label;

  const ProductCategory(this.key, this.label);
}

class Product {
  final ProductCategory category;
  final String title;
  final String description;
  final String thumbnail;
  final double price;
  final double discount;
  final double rating;
  final int stock;

  const Product({
    required this.category,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.price,
    required this.discount,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
    ProductCategory category,
  ) {
    return Product(
      category: category,
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
