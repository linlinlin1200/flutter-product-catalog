import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product.dart';

class ProductApi {
  Future<List<Product>> getProducts() async {
    final url = Uri.https('dummyjson.com', '/products', {
      'limit': '0',
      'select':
          'category,title,description,thumbnail,price,discountPercentage,rating,stock',
    });
    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final items = (data['products'] as List).cast<Map<String, dynamic>>();
    final categories = {
      for (final category in ProductCategory.values) category.key: category,
    };
    final products = <Product>[];

    for (final item in items) {
      final category = categories[item['category']];
      if (category != null) {
        products.add(Product.fromJson(item, category));
      }
    }

    return products;
  }
}
