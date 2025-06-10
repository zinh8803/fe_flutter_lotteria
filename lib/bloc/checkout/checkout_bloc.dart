import 'package:bloc/bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_event.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/data/services/Payment/api_payment.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ApiOrderService apiOrderService;
  final ApiService_payment apiPaymentService;

  CheckoutBloc(this.apiOrderService, this.apiPaymentService)
      : super(CheckoutInitial()) {
    on<LoadCheckoutDataEvent>((event, emit) {
      emit(CheckoutLoading());
    });

    on<PlaceOrderEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final order = await apiOrderService.placeOrder(
          userId: event.userId,
          discount_id: event.discount_Id,
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          address: event.address,
          paymentMethod: event.paymentMethod,
          cartItems: event.cartItems,
        );
        emit(CheckoutSuccess(order));
      } catch (e) {
        emit(CheckoutError(e.toString()));
      }
    });

    on<InitiateVNPayPaymentEvent>((event, emit) async {
      emit(CheckoutLoading());
      try {
        final vnPay = await apiPaymentService.getPaymentUrl(
          event.orderId,
          event.amount,
        );
        if (vnPay.status == 200) {
          emit(CheckoutPaymentUrlLoaded(vnPay.paymentUrl));
        } else {
          emit(CheckoutError(vnPay.message));
        }
      } catch (e) {
        print('Error in InitiateVNPayPaymentEvent: $e'); // Log lỗi
        emit(CheckoutError('Lỗi khi khởi tạo thanh toán VNPay: $e'));
      }
    });
  }
}
