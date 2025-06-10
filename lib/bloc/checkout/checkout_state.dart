import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'package:frontend_appflowershop/data/models/order.dart';
import 'package:frontend_appflowershop/data/models/user.dart';

abstract class CheckoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final UserModel user;
  final List<CartItem> cartItems;
  final double totalPrice;

  CheckoutLoaded({
    required this.user,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [user, cartItems, totalPrice];
}

class CheckoutSuccess extends CheckoutState {
  final OrderModel order;

  CheckoutSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class CheckoutPaymentUrlLoaded extends CheckoutState {
  final String paymentUrl;

  CheckoutPaymentUrlLoaded(this.paymentUrl);

  @override
  List<Object?> get props => [paymentUrl];
}

class CheckoutPaymentSuccess extends CheckoutState {
  final Map<String, dynamic> paymentData;

  CheckoutPaymentSuccess(this.paymentData);

  @override
  List<Object?> get props => [paymentData];
}

class CheckoutPaymentFailed extends CheckoutState {
  final String message;

  CheckoutPaymentFailed(this.message);

  @override
  List<Object?> get props => [message];
}
