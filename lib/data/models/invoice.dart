class InvoiceModel {
  final int invoiceId;
  final DateTime invoiceDate;
  final String invoiceStatus;
  final int orderId;
  final DateTime orderDate;
  final String customerName;
  final String phoneNumber;
  final String address;
  final String paymentMethod;
  final double totalAmount;
  final String orderStatus;
  final String username;
  final String email;

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceDate,
    required this.invoiceStatus,
    required this.orderId,
    required this.orderDate,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.totalAmount,
    required this.orderStatus,
    required this.username,
    required this.email,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceId: json['invoice_id'],
      invoiceDate: DateTime.parse(json['invoice_date']),
      invoiceStatus: json['invoice_status'],
      orderId: json['order_id'],
      orderDate: DateTime.parse(json['order_date']),
      customerName: json['customer_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      paymentMethod: json['payment_method'],
      totalAmount: double.parse(json['total_amount'].toString()),
      orderStatus: json['order_status'],
      username: json['username'],
      email: json['email'],
    );
  }
}
