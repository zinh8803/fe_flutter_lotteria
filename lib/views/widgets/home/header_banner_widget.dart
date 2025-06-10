import 'package:flutter/material.dart';

class HeaderBannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://img.freepik.com/free-psd/food-menu-restaurant-facebook-cover-template_106176-3738.jpg?semt=ais_hybrid&w=740',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
