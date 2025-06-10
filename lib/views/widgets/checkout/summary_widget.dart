import 'package:flutter/material.dart';

class SummaryWidget extends StatelessWidget {
  final double totalPrice;

  const SummaryWidget({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tạm tính:', style: TextStyle(fontSize: 16)),
            Text(
              '${totalPrice.toStringAsFixed(0)}đ',
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
              '${totalPrice.toStringAsFixed(0)}đ',
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
