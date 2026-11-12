import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product.dart';
import 'product_api.dart';
import 'product_bloc.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, fontFamily: 'Roboto'),
      home: BlocProvider(
        create: (_) => ProductBloc(ProductApi())..add(LoadProducts()),
        child: const CatalogPage(),
      ),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProductStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load products'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(LoadProducts());
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (state.products.isEmpty) {
            return const Center(child: Text('No products'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    child: ListTile(
                      leading: ProductImage(url: product.thumbnail, size: 48),
                      title: Text(product.title),
                      subtitle: Text(
                        '\$${product.salePrice.toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductPage(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(child: ProductImage(url: product.thumbnail, size: 220)),
              const SizedBox(height: 16),
              Text(product.title, style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                '\$${product.salePrice.toStringAsFixed(2)}',
                style: textTheme.titleLarge,
              ),
              if (product.discount > 0)
                Text('Discount: ${product.discount.toStringAsFixed(1)}%'),
              Text('Rating: ${product.rating.toStringAsFixed(1)} / 5'),
              Text('In stock: ${product.stock}'),
              const SizedBox(height: 16),
              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String url;
  final double size;

  const ProductImage({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
      ),
    );
  }
}
