import 'package:frontend_appflowershop/data/models/product.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final ProductModel product;

  AddToCartEvent(this.product);
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  RemoveFromCartEvent(this.productId);
}

class IncreaseQuantityEvent extends CartEvent {
  final int productId;

  IncreaseQuantityEvent(this.productId);
}

class DecreaseQuantityEvent extends CartEvent {
  final int productId;

  DecreaseQuantityEvent(this.productId);
}

class ClearCartEvent extends CartEvent {
  final int productId;

  ClearCartEvent(this.productId);
}

class ClearCartEventall extends CartEvent {}
