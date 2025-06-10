abstract class OrderDetailEvent {}

class FetchOrderDetail extends OrderDetailEvent {
  final int orderId;
  FetchOrderDetail(this.orderId);
}
