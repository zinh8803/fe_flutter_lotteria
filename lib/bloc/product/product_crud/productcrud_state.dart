import 'package:frontend_appflowershop/data/models/product.dart';

abstract class ProductcrudState {}

class ProductInitial extends ProductcrudState {}

class ProductLoading extends ProductcrudState {}
class ProductcrudSuccess extends ProductcrudState {}
class ProductcrudLoaded extends ProductcrudState {
  final List<ProductModel> products;

  ProductcrudLoaded(this.products);
}

class ProductError extends ProductcrudState {
  final String message;

  ProductError(this.message);
}
