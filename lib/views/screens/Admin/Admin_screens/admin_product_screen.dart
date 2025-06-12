import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_state.dart'
    as crud;
import 'package:image_picker/image_picker.dart';
import 'package:frontend_appflowershop/bloc/category/category_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_state.dart';

import 'package:frontend_appflowershop/bloc/product/product_list/product_bloc.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_event.dart';
import 'package:frontend_appflowershop/bloc/product/product_list/product_state.dart';
import 'package:frontend_appflowershop/data/models/category.dart';
import 'package:frontend_appflowershop/data/models/product.dart';
import 'package:intl/intl.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductcrudBloc>(
          create: (context) => ProductcrudBloc(
            context.read(), // Assuming ApiService_product is provided elsewhere
          ),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            context.read(), // Assuming ApiService for categories is provided
          ),
        ),
      ],
      child: BlocListener<ProductcrudBloc, crud.ProductcrudState>(
        listener: (context, state) {
          if (state is crud.ProductcrudSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thao tác thành công')),
            );
            context.read<ProductBloc>().add(FetchProductsEvent());
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: ')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý sản phẩm'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Tải lại sản phẩm',
                onPressed: () {
                  context.read<ProductBloc>().add(FetchProductsEvent());
                },
              ),
            ],
          ),
          body: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProductError) {
                return Center(child: Text('Lỗi: ${state.message}'));
              }
              if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm nào.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return _AdminProductCard(product: product);
                  },
                );
              }
              return const SizedBox();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showCreateProductDialog(context);
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.add),
            tooltip: 'Thêm sản phẩm',
          ),
        ),
      ),
    );
  }

  void _showCreateProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    int? selectedCategoryId;
    File? selectedImage;

    // Fetch categories when dialog opens
    context.read<CategoryBloc>().add(FetchCategoriesEvent());

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm sản phẩm'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: selectedImage == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 40, color: Colors.grey),
                                  Text('Thêm ảnh'),
                                ],
                              ),
                            )
                          : Image.file(selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giá'),
                  ),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tồn kho'),
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryError) {
                        return Text('Lỗi: ${state.message}');
                      } else if (state is CategoryLoaded) {
                        return DropdownButtonFormField<int>(
                          decoration:
                              const InputDecoration(labelText: 'Danh mục'),
                          value: selectedCategoryId,
                          items: state.categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Vui lòng chọn danh mục' : null,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final name = nameController.text;
                  final description = descriptionController.text;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final stock = int.tryParse(stockController.text) ?? 0;

                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn ảnh')),
                    );
                    return;
                  }
                  if (selectedCategoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn danh mục')),
                    );
                    return;
                  }

                  final product = ProductModel(
                    product_id: 0,
                    name: name,
                    description: description,
                    price: price,
                    stock: stock,
                    categoryId: selectedCategoryId!,
                    image: '',
                  );

                  context.read<ProductcrudBloc>().add(CreateProductEvent(
                        product: product,
                        imageFile: selectedImage!,
                      ));

                  Navigator.of(context).pop();
                },
                child: const Text('Thêm'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AdminProductCard extends StatelessWidget {
  final ProductModel product;
  const _AdminProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${formatCurrency.format(product.price)}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showUpdateProductDialog(context, product),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    _showDeleteConfirmationDialog(context, product),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa sản phẩm ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ProductcrudBloc>()
                  .add(DeleteProductEvent(product.product_id!));
              Navigator.of(context).pop();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showUpdateProductDialog(BuildContext context, ProductModel product) {
    final nameController = TextEditingController(text: product.name);
    final descriptionController =
        TextEditingController(text: product.description);
    final priceController =
        TextEditingController(text: product.price.toString());
    final stockController =
        TextEditingController(text: product.stock.toString());
    int? selectedCategoryId = product.categoryId;
    File? selectedImage;
    String? currentImageUrl = product.image;

    // Fetch categories when dialog opens
    context.read<CategoryBloc>().add(FetchCategoriesEvent());

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Sửa sản phẩm'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                          currentImageUrl = null;
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: selectedImage != null
                          ? Image.file(selectedImage!, fit: BoxFit.cover)
                          : currentImageUrl != null
                              ? Image.network(currentImageUrl!,
                                  fit: BoxFit.cover)
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate,
                                          size: 40, color: Colors.grey),
                                      Text('Thêm ảnh'),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Giá'),
                  ),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tồn kho'),
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoryError) {
                        return Text('Lỗi: ${state.message}');
                      } else if (state is CategoryLoaded) {
                        return DropdownButtonFormField<int>(
                          decoration:
                              const InputDecoration(labelText: 'Danh mục'),
                          value: selectedCategoryId,
                          items: state.categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Vui lòng chọn danh mục' : null,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final name = nameController.text;
                  final description = descriptionController.text;
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final stock = int.tryParse(stockController.text) ?? 0;

                  if (selectedCategoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn danh mục')),
                    );
                    return;
                  }

                  final updatedProduct = ProductModel(
                    product_id: product.product_id,
                    name: name,
                    description: description,
                    price: price,
                    stock: stock,
                    categoryId: selectedCategoryId!,
                    image: currentImageUrl ?? '',
                  );

                  context.read<ProductcrudBloc>().add(UpdateProductEvent(
                        product: updatedProduct,
                        imageFile: selectedImage,
                      ));

                  Navigator.of(context).pop();
                },
                child: const Text('Cập nhật'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }
}
