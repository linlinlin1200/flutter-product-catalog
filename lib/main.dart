import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product.dart';
import 'product_api.dart';
import 'product_bloc.dart';
import 'product_widgets.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorSchemeSeed: const Color(0xFF155BE8),
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      fontFamily: 'Roboto',
    );

    return MaterialApp(
      title: 'Circuit',
      debugShowCheckedModeBanner: false,
      theme: theme,
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
    final bloc = context.read<ProductBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: const Row(
              children: [
                Icon(Icons.memory_rounded, color: Color(0xFF155BE8), size: 30),
                SizedBox(width: 8),
                Text('Circuit', style: TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
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
                    onPressed: () => bloc.add(LoadProducts()),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final products = state.visibleProducts;

          return LayoutBuilder(
            builder: (context, constraints) {
              final textScaler = MediaQuery.textScalerOf(context);
              final columns = switch (constraints.maxWidth) {
                >= 1160 => 5,
                >= 1080 => 4,
                >= 740 => 3,
                >= 360 when textScaler.scale(16) <= 22 => 2,
                _ => 1,
              };

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CatalogHero(product: products.firstOrNull),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            for (final category in ProductCategory.values)
                              ChoiceChip(
                                label: Text(category.label),
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                selected: category == state.category,
                                showCheckmark: false,
                                selectedColor: const Color(0xFFD8E6FF),
                                onSelected: (selected) {
                                  if (selected) {
                                    bloc.add(SelectCategory(category));
                                  }
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text(
                              '${products.length} ${products.length == 1 ? 'product' : 'products'}',
                              style: const TextStyle(color: Color(0xFF485773)),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<ProductSort>(
                                value: state.sort,
                                onChanged: (sort) {
                                  if (sort != null) bloc.add(SelectSort(sort));
                                },
                                items: [
                                  for (final sort in ProductSort.values)
                                    DropdownMenuItem(
                                      value: sort,
                                      child: Text(sort.label),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text('No products in this category'),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 204 + textScaler.scale(96),
                                ),
                            itemBuilder:
                                (context, index) =>
                                    ProductCard(product: products[index]),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
