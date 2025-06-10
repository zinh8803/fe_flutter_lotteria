class VNPay {
  final int status;
  final String message;
  final String paymentUrl;

  VNPay({
    required this.status,
    required this.message,
    required this.paymentUrl,
  });

  factory VNPay.fromJson(Map<String, dynamic> json) {
    return VNPay(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      paymentUrl: json['payment_url'] ?? '',
    );
  }
}
