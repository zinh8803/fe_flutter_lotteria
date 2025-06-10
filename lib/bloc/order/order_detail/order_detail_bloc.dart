import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_event.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final ApiOrderService apiService;

  OrderDetailBloc(this.apiService) : super(OrderDetailInitial()) {
    on<FetchOrderDetail>((event, emit) async {
      emit(OrderDetailLoading());
      try {
        final order = await apiService.getOrderDetail(event.orderId);
        emit(OrderDetailLoaded(order));
      } catch (e) {
        emit(OrderDetailError(e.toString()));
      }
    });
  }
}
