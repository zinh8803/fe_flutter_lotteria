import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Hình thức thanh toán',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: paymentMethod,
          hint: const Text(
              'Chọn phương thức thanh toán'), 
          isExpanded: true, 
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: const [
            DropdownMenuItem(
              value: 'cash',
              child: Text('Thanh toán khi nhận hàng'),
            ),
            DropdownMenuItem(
              value: 'vnpay',
              child: Text('Thanh toán qua VNPay'),
            ),
          ],
          onChanged: (value) {
            print('Selected payment method: $value'); 
            onChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn phương thức thanh toán';
            }
            return null;
          },
        ),
      ],
    );
  }
}
