import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/sreach_product/sreach_event.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback? onSearch;

  const SearchBarWidget({super.key, this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    // Loại bỏ khoảng trắng ở đầu và cuối
    query = query.trim();
    if (query.isEmpty) {
      // Không gửi sự kiện tìm kiếm nếu từ khóa rỗng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập từ khóa tìm kiếm'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    // Gửi sự kiện tìm kiếm nếu từ khóa không rỗng
    context.read<SearchBloc>().add(SearchProductsEvent(query));
    // Gọi callback để điều hướng đến tab Search
    if (widget.onSearch != null) {
      widget.onSearch!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Từ khóa sản phẩm...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        ),
        onSubmitted: _onSearch, // Gọi tìm kiếm khi nhấn Enter
        onChanged: (value) {
          if (value.trim().isEmpty) {
            // Reset kết quả tìm kiếm khi từ khóa rỗng
            context.read<SearchBloc>().add(SearchProductsEvent(''));
          }
        },
      ),
    );
  }
}
