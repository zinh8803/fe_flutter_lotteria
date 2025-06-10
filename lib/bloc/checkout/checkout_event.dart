import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/cart_item.dart';

abstract class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCheckoutDataEvent extends CheckoutEvent {}

class PlaceOrderEvent extends CheckoutEvent {
  final int userId;
  final String name;
  final String? discount_Id;
  final String email;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final List<CartItem> cartItems;

  PlaceOrderEvent({
    required this.userId,
    required this.name,
    this.discount_Id,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.cartItems,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        discount_Id,
        email,
        phoneNumber,
        address,
        paymentMethod,
        cartItems,
      ];
}

class InitiateVNPayPaymentEvent extends CheckoutEvent {
  final String orderId;
  final double amount;

  InitiateVNPayPaymentEvent({
    required this.orderId,
    required this.amount,
  });

  @override
  List<Object?> get props => [orderId, amount];
}
