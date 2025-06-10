import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiOrderService apiService;

  OrderBloc(this.apiService) : super(OrderInitial()) {
    on<FetchUserOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final order = await apiService.getUserOrders();
        emit(OrderLoaded(order));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}
