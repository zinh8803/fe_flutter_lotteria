import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_state.dart';
import 'package:frontend_appflowershop/views/widgets/home/product_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

import '../../data/models/category.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() {
      _selectedCategory = category;
    });

    context
        .read<CategoryProductsBloc>()
        .add(FetchCategoryProductsEvent(category.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Danh mục sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey[200],
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoryError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }
                if (state is CategoryLoaded) {
                  if (state.categories.isEmpty) {
                    return const Center(child: Text('Không có danh mục'));
                  }
                  return ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      final isSelected = _selectedCategory?.id == category.id;
                      return GestureDetector(
                        onTap: () => _onCategorySelected(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          color: isSelected ? Colors.white : Colors.grey[200],
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  isSelected ? Colors.black : Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
              builder: (context, state) {
                if (_selectedCategory == null) {
                  return const Center(child: Text('Vui lòng chọn danh mục'));
                }
                if (state is CategoryProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoryProductsError) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                }
                if (state is CategoryProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                        child:
                            Text('Không có sản phẩm nào trong danh mục này'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cột
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return ProductWidget(product: state.products[index]);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
