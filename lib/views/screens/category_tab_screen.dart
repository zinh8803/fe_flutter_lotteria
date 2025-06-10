import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_product/category_products_state.dart';
import 'package:frontend_appflowershop/views/widgets/category_products/category_product_item.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

class CategoryTabScreen extends StatefulWidget {
  final int? initialCategoryId;

  const CategoryTabScreen({super.key, this.initialCategoryId});

  @override
  State<CategoryTabScreen> createState() => _CategoryTabScreenState();
}

class _CategoryTabScreenState extends State<CategoryTabScreen> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    print('CategoryTabScreen initState: Fetching categories');
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    if (widget.initialCategoryId != null) {
      print('Initial Category ID: ${widget.initialCategoryId}');
      _selectInitialCategory();
    }
  }

  void _selectInitialCategory() {
    context.read<CategoryBloc>().stream.listen((state) {
      if (state is CategoryLoaded && state.categories.isNotEmpty) {
        final index = state.categories
            .indexWhere((category) => category.id == widget.initialCategoryId);
        print(
            'Found category index: $index for ID ${widget.initialCategoryId}');
        if (index != -1 && index != _selectedCategoryIndex) {
          setState(() {
            _selectedCategoryIndex = index;
          });
          context.read<CategoryProductsBloc>().add(
                FetchCategoryProductsEvent(state.categories[index].id),
              );
        } else if (index == -1) {
          print('Category ID ${widget.initialCategoryId} not found');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                print('CategoryBloc Error: ${state.message}');
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is CategoryLoaded) {
                if (state.categories.isEmpty) {
                  print('No categories loaded');
                  return const Center(child: Text('Không có danh mục'));
                }
                return ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedCategoryIndex == index;
                    return Material(
                      color: isSelected ? Colors.white : Colors.grey[200],
                      child: InkWell(
                        onTap: () {
                          print(
                              'Selected category: ${state.categories[index].id}');
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          context.read<CategoryProductsBloc>().add(
                                FetchCategoryProductsEvent(
                                  state.categories[index].id,
                                ),
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              state.categories[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.red : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
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
              if (state is CategoryProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CategoryProductsError) {
                print('CategoryProductsBloc Error: ${state.message}');
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is CategoryProductsLoaded) {
                if (state.products.isEmpty) {
                  print('No products loaded for category');
                  return const Center(child: Text('Không có sản phẩm nào'));
                }
                print('Loaded ${state.products.length} products');
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return CategoryProductItem(product: state.products[index]);
                  },
                );
              }
              return const Center(child: Text('Chọn danh mục để xem sản phẩm'));
            },
          ),
        ),
      ],
    );
  }
}
