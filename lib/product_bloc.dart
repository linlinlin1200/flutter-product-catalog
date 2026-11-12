import 'package:flutter_bloc/flutter_bloc.dart';

import 'product.dart';
import 'product_api.dart';

sealed class ProductEvent {}

class LoadProducts extends ProductEvent {}

class SelectCategory extends ProductEvent {
  final ProductCategory category;

  SelectCategory(this.category);
}

class SelectSort extends ProductEvent {
  final ProductSort sort;

  SelectSort(this.sort);
}

enum ProductStatus { loading, ready, error }

enum ProductSort {
  priceLow('Price: low to high'),
  priceHigh('Price: high to low'),
  rating('Highest rated');

  final String label;

  const ProductSort(this.label);
}

class ProductState {
  final ProductStatus status;
  final List<Product> products;
  final ProductCategory category;
  final ProductSort sort;

  const ProductState({
    this.status = ProductStatus.loading,
    this.products = const [],
    this.category = ProductCategory.laptops,
    this.sort = ProductSort.priceLow,
  });

  List<Product> get visibleProducts {
    final visible =
        products.where((product) => product.category == category).toList();

    visible.sort((a, b) {
      final order = switch (sort) {
        ProductSort.priceLow => a.salePrice.compareTo(b.salePrice),
        ProductSort.priceHigh => b.salePrice.compareTo(a.salePrice),
        ProductSort.rating => b.rating.compareTo(a.rating),
      };
      return order == 0 ? a.title.compareTo(b.title) : order;
    });

    return visible;
  }
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductApi api;

  ProductBloc(this.api) : super(const ProductState()) {
    on<LoadProducts>(_loadProducts);
    on<SelectCategory>((event, emit) {
      emit(
        ProductState(
          status: state.status,
          products: state.products,
          category: event.category,
          sort: state.sort,
        ),
      );
    });
    on<SelectSort>((event, emit) {
      emit(
        ProductState(
          status: state.status,
          products: state.products,
          category: state.category,
          sort: event.sort,
        ),
      );
    });
  }

  Future<void> _loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState());

    try {
      final products = await api.getProducts();
      emit(ProductState(status: ProductStatus.ready, products: products));
    } catch (_) {
      emit(const ProductState(status: ProductStatus.error));
    }
  }
}
