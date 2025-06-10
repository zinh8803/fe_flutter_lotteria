// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend_appflowershop/bloc/category/category_bloc.dart';
// import 'package:frontend_appflowershop/bloc/category/category_event.dart';
// import 'package:frontend_appflowershop/bloc/category/category_product/category_products_bloc.dart';
// import 'package:frontend_appflowershop/bloc/category/category_product/category_products_event.dart';
// import 'package:frontend_appflowershop/bloc/category/category_product/category_products_state.dart';
// import 'package:frontend_appflowershop/bloc/category/category_state.dart';
// import 'package:frontend_appflowershop/views/widgets/home/product_widget.dart';

// class CategoryTabScreen extends StatefulWidget {
//   const CategoryTabScreen({super.key});

//   @override
//   State<CategoryTabScreen> createState() => _CategoryTabScreenState();
// }

// class _CategoryTabScreenState extends State<CategoryTabScreen> {
//   int _selectedCategoryIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     context.read<CategoryBloc>().add(FetchCategoriesEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BlocBuilder<CategoryBloc, CategoryState>(
//           builder: (context, state) {
//             if (state is CategoryLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state is CategoryError) {
//               return Center(child: Text('Lỗi: ${state.message}'));
//             }
//             if (state is CategoryLoaded) {
//               if (state.categories.isEmpty) {
//                 return const Center(child: Text('Không có danh mục nào'));
//               }
//               return SizedBox(
//                 height: 50,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.categories.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: ChoiceChip(
//                         label: Text(state.categories[index].name),
//                         selected: _selectedCategoryIndex == index,
//                         onSelected: (selected) {
//                           if (selected) {
//                             setState(() {
//                               _selectedCategoryIndex = index;
//                             });
//                             context.read<CategoryProductsBloc>().add(
//                                   FetchCategoryProductsEvent(
//                                     state.categories[index].id,
//                                   ),
//                                 );
//                           }
//                         },
//                         selectedColor: Colors.pink[100],
//                         backgroundColor: Colors.grey[200],
//                         labelStyle: TextStyle(
//                           color: _selectedCategoryIndex == index
//                               ? Colors.pink
//                               : Colors.black,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//             return const SizedBox();
//           },
//         ),
//         // Danh sách sản phẩm theo danh mục
//         Expanded(
//           child: BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
//             builder: (context, state) {
//               if (state is CategoryProductsLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state is CategoryProductsError) {
//                 return Center(child: Text('Lỗi: ${state.message}'));
//               }
//               if (state is CategoryProductsLoaded) {
//                 if (state.products.isEmpty) {
//                   return const Center(child: Text('Không có sản phẩm nào'));
//                 }
//                 return GridView.builder(
//                   padding: const EdgeInsets.all(16),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 0.65,
//                   ),
//                   itemCount: state.products.length,
//                   itemBuilder: (context, index) {
//                     return ProductWidget(product: state.products[index]);
//                   },
//                 );
//               }
//               return const Center(child: Text('Chọn danh mục để xem sản phẩm'));
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
