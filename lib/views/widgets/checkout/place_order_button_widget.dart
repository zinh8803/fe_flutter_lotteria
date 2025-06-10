import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_event.dart';
import 'package:frontend_appflowershop/data/models/cart_item.dart';
import 'dart:math';

class PlaceOrderButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String userId;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final double totalPrice;

  const PlaceOrderButtonWidget({
    super.key,
    required this.formKey,
    required this.userId,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.paymentMethod,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (paymentMethod == 'cash') {
                  context.read<CheckoutBloc>().add(
                        PlaceOrderEvent(
                          userId: int.parse(userId),
                          name: nameController.text,
                          email: emailController.text,
                          discount_Id: '',
                          phoneNumber: phoneController.text,
                          address: addressController.text,
                          paymentMethod: paymentMethod,
                          cartItems: cartItems,
                        ),
                      );
                } else if (paymentMethod == 'vnpay') {
                  int generateRandom6DigitNumber() {
                    final random = Random();
                    return 100000 + random.nextInt(900000);
                  }

                  int randomOrderId = generateRandom6DigitNumber();
                  context.read<CheckoutBloc>().add(
                        InitiateVNPayPaymentEvent(
                          orderId: randomOrderId.toString(),
                          amount: totalPrice,
                        ),
                      );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đặt hàng',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
