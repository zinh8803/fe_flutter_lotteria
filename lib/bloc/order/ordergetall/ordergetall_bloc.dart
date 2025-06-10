import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_event.dart';
import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrdergetallBloc extends Bloc<OrdergetallEvent, OrdergetallState> {
  final ApiOrderService apiService;

  OrdergetallBloc(this.apiService) : super(OrdergetallInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrdergetallLoading());
      try {
        final order = await apiService.getallOrder();
        emit(OrdergetallLoaded(order));
      } catch (e) {
        emit(OrdergetallError(e.toString()));
      }
    });
  }
}
