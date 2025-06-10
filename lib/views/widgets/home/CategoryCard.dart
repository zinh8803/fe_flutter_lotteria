// import 'package:flutter/material.dart';
// import 'package:frontend_appflowershop/data/models/category.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class CategoryCard extends StatelessWidget {
//   final CategoryModel category;

//   CategoryCard({required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Thêm hành động khi nhấn vào card nếu cần
//       },
//       child: Card(
//         margin:
//             EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0), // Giảm margin
//         elevation: 5.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(6.0), // Giảm padding
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: CachedNetworkImage(
//                   imageUrl: category.imageUrl,
//                   height: 90, // Giảm chiều cao ảnh
//                   width: 90,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) =>
//                       Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ),
//               ),
//               SizedBox(height: 6.0), // Giảm khoảng cách
//               Text(
//                 category.name,
//                 style: TextStyle(
//                   fontSize: 14, // Giảm kích thước chữ
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
