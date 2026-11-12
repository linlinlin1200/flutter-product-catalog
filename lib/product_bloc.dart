import 'package:flutter_bloc/flutter_bloc.dart';

import 'product.dart';
import 'product_api.dart';

class LoadProducts {}

enum ProductStatus { loading, ready, error }

class ProductState {
  final ProductStatus status;
  final List<Product> products;

  const ProductState(this.status, [this.products = const []]);
}

class ProductBloc extends Bloc<LoadProducts, ProductState> {
  final ProductApi api;

  ProductBloc(this.api) : super(const ProductState(ProductStatus.loading)) {
    on<LoadProducts>(_loadProducts);
  }

  Future<void> _loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState(ProductStatus.loading));

    try {
      final products = await api.getProducts();
      emit(ProductState(ProductStatus.ready, products));
    } catch (_) {
      emit(const ProductState(ProductStatus.error));
    }
  }
}
