import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_appflowershop/bloc/category/category_bloc.dart';
import 'package:frontend_appflowershop/bloc/category/category_event.dart';
import 'package:frontend_appflowershop/bloc/category/category_state.dart';
import 'package:frontend_appflowershop/data/models/category.dart';
import 'package:mime/mime.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý danh mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại danh mục',
            onPressed: () {
              context.read<CategoryBloc>().add(FetchCategoriesEvent());
            },
          ),
        ],
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategorySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thao tác thành công')),
            );
            context.read<CategoryBloc>().add(FetchCategoriesEvent());
          } else if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: ${state.message}')),
            );
          }
        },
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
                return const Center(child: Text('Không có danh mục nào.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return _AdminCategoryCard(category: category);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateCategoryDialog(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
        tooltip: 'Thêm danh mục',
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    String? imagePath;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm danh mục'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              final mimeType = lookupMimeType(pickedFile.path);
                              const allowedMimeTypes = [
                                'image/jpeg',
                                'image/png'
                              ];
                              if (!allowedMimeTypes.contains(mimeType)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Chỉ hỗ trợ ảnh JPEG hoặc PNG')),
                                );
                                return;
                              }
                              final fileSize =
                                  await File(pickedFile.path).length();
                              const maxFileSize = 5 * 1024 * 1024; // 5MB
                              if (fileSize > maxFileSize) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Kích thước ảnh không được vượt quá 5MB')),
                                );
                                return;
                              }
                              setState(() {
                                imagePath = pickedFile.path;
                              });
                            }
                          },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imagePath == null
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
                          : Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Tên danh mục'),
                    enabled: !isLoading,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final name = nameController.text;
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Vui lòng nhập tên danh mục')),
                          );
                          return;
                        }
                        if (imagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn ảnh')),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        context.read<CategoryBloc>().add(AddCategoryEvent(
                              name: name,
                              imagePath: imagePath!,
                            ));

                        // Đóng dialog sau khi gửi (BlocListener sẽ xử lý kết quả)
                        Navigator.of(context).pop();
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Thêm'),
              ),
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AdminCategoryCard extends StatelessWidget {
  final CategoryModel category;
  const _AdminCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
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
                category.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showUpdateCategoryDialog(context, category),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    _showDeleteConfirmationDialog(context, category),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa danh mục ${category.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<CategoryBloc>()
                  .add(DeleteCategoryEvent(category.id));
              Navigator.of(context).pop();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showUpdateCategoryDialog(BuildContext context, CategoryModel category) {
    final nameController = TextEditingController(text: category.name);
    String? imagePath;
    String? currentImageUrl = category.image;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Sửa danh mục'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              final mimeType = lookupMimeType(pickedFile.path);
                              const allowedMimeTypes = [
                                'image/jpeg',
                                'image/png'
                              ];
                              if (!allowedMimeTypes.contains(mimeType)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Chỉ hỗ trợ ảnh JPEG hoặc PNG')),
                                );
                                return;
                              }
                              final fileSize =
                                  await File(pickedFile.path).length();
                              const maxFileSize = 5 * 1024 * 1024; // 5MB
                              if (fileSize > maxFileSize) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Kích thước ảnh không được vượt quá 5MB')),
                                );
                                return;
                              }
                              setState(() {
                                imagePath = pickedFile.path;
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
                      child: imagePath != null
                          ? Image.file(File(imagePath!), fit: BoxFit.cover)
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
                    decoration:
                        const InputDecoration(labelText: 'Tên danh mục'),
                    enabled: !isLoading,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final name = nameController.text;
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Vui lòng nhập tên danh mục')),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        context.read<CategoryBloc>().add(UpdateCategoryEvent(
                              id: category.id,
                              name: name,
                              imagePath: imagePath,
                              currentImageUrl: currentImageUrl,
                            ));

                        Navigator.of(context).pop();
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cập nhật'),
              ),
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }
}
