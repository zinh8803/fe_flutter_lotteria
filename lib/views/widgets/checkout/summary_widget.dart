import 'package:flutter/material.dart';
import 'package:intl/src/intl/number_format.dart';

class SummaryWidget extends StatelessWidget {
  final double totalPrice;

  const SummaryWidget(
      {super.key,
      required this.totalPrice,
      required NumberFormat formatCurrency});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tạm tính:', style: TextStyle(fontSize: 16)),
            Text(
              '${formatCurrency.format(totalPrice)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển:', style: TextStyle(fontSize: 16)),
            Text(
              '0đ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng tiền:', style: TextStyle(fontSize: 16)),
            Text(
              '${formatCurrency.format(totalPrice)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
