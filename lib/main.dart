import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/auth/Login/auth_bloc.dart';
import 'package:frontend_appflowershop/bloc/cart/cart_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
import 'package:frontend_appflowershop/bloc/checkout/checkout_bloc.dart';
import 'package:frontend_appflowershop/bloc/invoice/statistic_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_detail/order_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/ordergetall/ordergetall_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_detail/product_detail_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/avatar/avatar_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/data/models/employee.dart';
import 'package:frontend_appflowershop/data/models/user.dart';
import 'package:frontend_appflowershop/data/services/Category/api_category.dart'
    as categoryApiService;
import 'package:frontend_appflowershop/data/services/Order/api_order.dart'
    as orderApiService;
import 'package:frontend_appflowershop/data/services/Payment/api_payment.dart';
import 'package:frontend_appflowershop/data/services/Product/api_product.dart'
    as productApiService;
import 'package:frontend_appflowershop/data/services/cart/cart_service.dart';
import 'package:frontend_appflowershop/data/services/invoice/api_statistic.dart';
import 'package:frontend_appflowershop/data/services/user/api_service.dart'
    as userApiService;
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/admin_total_screen.dart';
import 'package:frontend_appflowershop/views/screens/home_screen.dart';
import 'package:frontend_appflowershop/views/screens/login_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<dynamic> _checkTokenAndUser() async {
    try {
      // Lấy token từ PreferenceService
      final token = await PreferenceService.getToken();
      if (token == null) {
        print('No token found');
        return null;
      }

      final apiService = userApiService.ApiService();
      final user = await apiService.getUserProfile();
      print('Token is valid, user profile fetched successfully');
      return user;
    } catch (e) {
      print('Error checking token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userApi = userApiService.ApiService();
    final categoryApi = categoryApiService.ApiService();
    final productApi = productApiService.ApiService_product();
    final cartService = CartService();
    final orderService = orderApiService.ApiOrderService();
    final vnpayService = ApiService_payment();
    final statisticService = ApiStatisticService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userApi),
        RepositoryProvider(create: (context) => cartService),
        RepositoryProvider(create: (context) => categoryApi),
        RepositoryProvider(create: (context) => productApi),
        RepositoryProvider(create: (context) => orderService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(context.read<userApiService.ApiService>()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(categoryApi),
          ),
          BlocProvider(
            create: (context) => ProductBloc(productApi),
          ),
          BlocProvider(
            create: (context) => ProductDetailBloc(productApi),
          ),
          BlocProvider(
            create: (context) => CategoryProductsBloc(productApi),
          ),
          BlocProvider(
            create: (context) => UserProfileBloc(userApi, PreferenceService()),
          ),
          BlocProvider(
            create: (context) => AvatarBloc(userApi),
          ),
          BlocProvider(
            create: (context) => SearchBloc(productApi),
          ),
          BlocProvider(
            create: (context) => CartBloc(context.read<CartService>()),
          ),
          BlocProvider(
            create: (context) => CheckoutBloc(orderService, vnpayService),
          ),
          BlocProvider(
            create: (context) => OrderBloc(orderService),
          ),
          BlocProvider(
            create: (context) => OrderDetailBloc(orderService),
          ),
          BlocProvider(
            create: (context) => ProductcrudBloc(productApi),
          ),
          BlocProvider(
            create: (context) => OrdergetallBloc(orderService),
          ),
          BlocProvider(
            create: (context) => StatisticBloc(statisticService),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => FutureBuilder<dynamic>(
                  future: _checkTokenAndUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      final user = snapshot.data;
                      print('User type: ${user.runtimeType}');

                      if (user is UserModel) {
                        if (user.isAdmin == 1) {
                          print('Navigating to AdminTotalScreen');
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context)
                                .pushReplacementNamed('/admin');
                          });
                          return const SizedBox(); // Trả về widget tạm để tránh build lại
                        } else {
                          print('Navigating to HomeScreen');
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          });
                          return const SizedBox();
                        }
                      }
                    }

                    print('Navigating to LoginScreen');
                    return const LoginScreen();
                  },
                ),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/admin': (context) => const AdminTotalScreen(),
          },
        ),
      ),
    );
  }
}
