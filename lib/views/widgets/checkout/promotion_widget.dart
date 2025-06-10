import 'package:flutter/material.dart';

class PromotionWidget extends StatelessWidget {
  const PromotionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Khuyến mãi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Handle promotion code input here
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Nhập mã khuyến mãi'),
                  content: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập mã khuyến mãi',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text(
            'Nhập mã khuyến mãi >',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
