import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/data/models/category.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;

  CategoryWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: category.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.image,
                size: 30,
                color: Colors.grey[400],
              ),
              maxHeightDiskCache: 1000, 
              errorListener: (dynamic error) =>
                  print('Error loading image: $error'), 
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          category.name,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
