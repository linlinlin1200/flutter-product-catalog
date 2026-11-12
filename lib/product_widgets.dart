import 'package:flutter/material.dart';

import 'product.dart';

class CatalogHero extends StatelessWidget {
  final Product? product;

  const CatalogHero({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C1835), Color(0xFF17448E), Color(0xFF629DFF)],
        ),
      ),
      constraints: const BoxConstraints(minHeight: 168),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final largeText = MediaQuery.textScalerOf(context).scale(16) > 22;

          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compact ? 'Electronics\ncatalog' : 'Electronics catalog',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 28 : 46,
                        fontWeight: FontWeight.w800,
                        height: 1.02,
                        letterSpacing: -1.2,
                      ),
                    ),
                    if (product case final featured?) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0x29FFFFFF),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onPressed: () => ProductPage.open(context, featured),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                compact ? 'View product' : featured.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_outward_rounded, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (product != null && !largeText)
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 330,
                      height: compact ? 144 : 204,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Color(0x66DDEAFF), Color(0x00DDEAFF)],
                        ),
                      ),
                      child: ProductImage(url: product!.thumbnail),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(color: Color(0xFFE0E6F1)),
      ),
      child: InkWell(
        onTap: () => ProductPage.open(context, product),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF3FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Transform.scale(
                          scale: 1.15,
                          child: ProductImage(url: product.thumbnail),
                        ),
                      ),
                      if (product.discount.round() > 0)
                        Positioned(
                          left: 7,
                          top: 7,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8E6FF),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              child: Text(
                                '−${product.discount.round()}%',
                                style: const TextStyle(
                                  color: Color(0xFF133D90),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                height: MediaQuery.textScalerOf(context).scale(38),
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF101B34),
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 17,
                    color: Color(0xFFA45A08),
                  ),
                  const SizedBox(width: 3),
                  Flexible(child: Text(product.rating.toStringAsFixed(1))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${product.salePrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF154BAF),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: Color(0xFF154BAF),
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  static void open(BuildContext context, Product product) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ProductPage(product: product)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final photo = Container(
      height: 340,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ProductImage(url: product.thumbnail),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.category.label,
          style: const TextStyle(color: Color(0xFF154BAF)),
        ),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '\$${product.salePrice.toStringAsFixed(2)}',
              style: textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF154BAF),
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.discount > 0)
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            Text('Rating: ${product.rating.toStringAsFixed(1)} / 5'),
            Text(
              product.stock > 0 ? 'In stock: ${product.stock}' : 'Out of stock',
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(product.description, style: textTheme.bodyLarge),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Product details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 680) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [photo, const SizedBox(height: 20), details],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: photo),
                    const SizedBox(width: 32),
                    Expanded(child: details),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String url;

  const ProductImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
      errorBuilder:
          (_, _, _) => const Center(child: Icon(Icons.image_not_supported)),
    );
  }
}
