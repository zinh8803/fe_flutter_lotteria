// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_bloc.dart';
// import 'package:frontend_appflowershop/bloc/product/product_crud/productcrud_event.dart';
// import 'package:frontend_appflowershop/data/models/product.dart';

// class ProductForm extends StatefulWidget {
//   final ProductModel? product;

//   const ProductForm({super.key, this.product});

//   @override
//   _ProductFormState createState() => _ProductFormState();
// }

// class _ProductFormState extends State<ProductForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _priceController;
//   late TextEditingController _stockController;
//   late TextEditingController _categoryIdController;
//   late TextEditingController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.product?.name ?? '');
//     _descriptionController =
//         TextEditingController(text: widget.product?.description ?? '');
//     _priceController =
//         TextEditingController(text: widget.product?.price.toString() ?? '');
//     _stockController =
//         TextEditingController(text: widget.product?.stock.toString() ?? '');
//     _categoryIdController = TextEditingController(
//         text: widget.product?.categoryId.toString() ?? '');
//     _imageController = TextEditingController(text: widget.product?.image ?? '');
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _stockController.dispose();
//     _categoryIdController.dispose();
//     _imageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 widget.product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Vui lòng nhập tên' : null,
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration:
//                     const InputDecoration(labelText: 'Mô tả (tùy chọn)'),
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Giá'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Vui lòng nhập giá' : null,
//               ),
//               TextFormField(
//                 controller: _stockController,
//                 decoration: const InputDecoration(labelText: 'Tồn kho'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Vui lòng nhập số lượng' : null,
//               ),
//               TextFormField(
//                 controller: _categoryIdController,
//                 decoration: const InputDecoration(labelText: 'ID danh mục'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Vui lòng nhập ID danh mục' : null,
//               ),
//               TextFormField(
//                 controller: _imageController,
//                 decoration: const InputDecoration(labelText: 'URL hình ảnh'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Vui lòng nhập URL hình ảnh' : null,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Hủy'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final event = widget.product == null
//                             ? CreateProductEvent(
//                                 name: _nameController.text,
//                                 description: _descriptionController.text.isEmpty
//                                     ? null
//                                     : _descriptionController.text,
//                                 price: double.parse(_priceController.text),
//                                 stock: int.parse(_stockController.text),
//                                 categoryId:
//                                     int.parse(_categoryIdController.text),
//                                 image: _imageController.text,
//                               )
//                             : UpdateProductEvent(
//                                 productId: widget.product!.product_id,
//                               );
//                         context.read<ProductcrudBloc>().add(event);
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text('Lưu'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
