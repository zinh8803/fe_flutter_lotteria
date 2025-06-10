import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/cart_item.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final int totalItems;
  final double totalPrice;

  CartLoaded({
    required this.cartItems,
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [cartItems, totalItems, totalPrice];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object?> get props => [message];
}
