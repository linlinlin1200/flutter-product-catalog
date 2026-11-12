import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product.dart';

class ProductApi {
  Future<List<Product>> getProducts() async {
    final url = Uri.https('dummyjson.com', '/products');
    final response = await http.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final products = data['products'] as List;
    return products
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
