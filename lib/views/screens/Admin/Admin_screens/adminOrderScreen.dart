import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_event.dart';
import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdergetallBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại đơn hàng',
            onPressed: () {
              context.read<OrdergetallBloc>().add(FetchOrders());
            },
          ),
        ],
      ),
      body: BlocBuilder<OrdergetallBloc, OrdergetallState>(
        builder: (context, state) {
          if (state is OrdergetallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdergetallLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(child: Text('Không có đơn hàng nào.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(
                  DateTime.parse(order.orderDate),
                );
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => OrderDetailBloc(
                              context.read<ApiOrderService>(),
                            ),
                            child: OrderDetailScreen(orderId: order.id),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đơn hàng #${order.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tổng giá: ${order.totalPrice.toStringAsFixed(0)}đ',
                          ),
                          Text('Trạng thái: ${order.status}'),
                          Text('Ngày mua: $formattedDate'),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is OrdergetallError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
