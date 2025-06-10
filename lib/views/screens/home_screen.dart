import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_state.dart';
import 'package:frontend_appflowershop/views/screens/cart_screen.dart';
import 'package:frontend_appflowershop/views/screens/search_screen.dart';
import 'package:frontend_appflowershop/views/widgets/home/productdiscount_list_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../widgets/home/header_banner_widget.dart';
import '../widgets/home/category_list_widget.dart';
import '../widgets/home/product_list_widget.dart';
import '../widgets/sreach/search_bar_widget.dart';
import 'category_tab_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 1) {
        _selectedCategoryId = null;
      }
    });
  }

  void _onSearch() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _selectedIndex = 1;
    });
  }

  List<Widget> _buildScreens() {
    return [
      // Tab Home
      SingleChildScrollView(
        child: Column(
          children: [
            HeaderBannerWidget(),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                if (categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryState is CategoryError) {
                  return Center(child: Text('Lỗi: ${categoryState.message}'));
                }
                if (categoryState is CategoryLoaded) {
                  if (categoryState.categories.isEmpty) {
                    return const Center(child: Text('Không có danh mục nào'));
                  }
                  return Column(
                    children: [
                      CategoryListWidget(
                        title: 'Danh sách danh mục sản phẩm',
                        categories: categoryState.categories,
                        onCategorySelected: _onCategorySelected,
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, productState) {
                          if (productState is ProductLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (productState is ProductError) {
                            return Center(
                                child: Text('Lỗi: ${productState.message}'));
                          }
                          if (productState is ProductLoaded) {
                            if (productState.products.isEmpty) {
                              return const Center(
                                  child: Text('Không có sản phẩm nào'));
                            }
                            return ProductListWidget(
                              title: 'Danh sách sản phẩm hôm nay',
                              products: productState.products,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      // Tab Category
      CategoryTabScreen(initialCategoryId: _selectedCategoryId),
      const SearchScreen(),
      const UserProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SearchBarWidget(onSearch: _onSearch),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildScreens()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
