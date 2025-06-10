import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrdergetuserModel orders;

  OrderDetailLoaded(this.orders);
}

class OrderDetailError extends OrderDetailState {
  final String message;

  OrderDetailError(this.message);
}
