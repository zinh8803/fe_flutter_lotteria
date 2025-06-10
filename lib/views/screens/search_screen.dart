import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_state.dart';
import 'package:frontend_appflowershop/views/widgets/sreach/search_product_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchError) {
          return Center(
            child: Text(
              'Không tìm thấy sản phẩm',
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        if (state is SearchLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('Không tìm thấy sản phẩm nào'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return SearchProductItem(product: state.products[index]);
            },
          );
        }
        return const Center(child: Text('Vui lòng nhập từ khóa tìm kiếm'));
      },
    );
  }
}
