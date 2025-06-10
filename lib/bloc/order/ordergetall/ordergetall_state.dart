import 'package:equatable/equatable.dart';
import 'package:frontend_appflowershop/data/models/ordergetuser.dart';

abstract class OrdergetallState extends Equatable {
  const OrdergetallState();

  @override
  List<Object> get props => [];
}

class OrdergetallInitial extends OrdergetallState {}

class OrdergetallLoading extends OrdergetallState {}

class OrdergetallLoaded extends OrdergetallState {
  final List<OrdergetuserModel> orders;

  OrdergetallLoaded(this.orders);
}

class OrdergetallError extends OrdergetallState {
  final String message;

  OrdergetallError(this.message);
}
