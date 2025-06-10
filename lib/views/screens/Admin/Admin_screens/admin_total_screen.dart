import 'package:flutter/material.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/AdminOrderScreen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/admin_Category_srceen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/admin_product_screen.dart';
import 'package:frontend_appflowershop/views/screens/Admin/Admin_screens/admin_statistic_screen.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Quản lý nhân viên (Chưa triển khai)',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

// class AdminStatisticScreen extends StatelessWidget {
//   const AdminStatisticScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Thống kê doanh thu (Chưa triển khai)',
//         style: TextStyle(fontSize: 20),
//       ),
//     );
//   }
// }

class AdminTotalScreen extends StatefulWidget {
  const AdminTotalScreen({super.key});

  @override
  State<AdminTotalScreen> createState() => _AdminTotalScreenState();
}

class _AdminTotalScreenState extends State<AdminTotalScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình cho từng tab
  final List<Widget> _screens = [
    const AdminProductScreen(), // Tab quản lý sản phẩm
    const CategoryListScreen(), // Tab quản lý danh mục
    const AdminOrderScreen(), // Tab quản lý đơn hàng
    // const AdminStaffScreen(), // Tab quản lý nhân viên
    const AdminStatisticScreen(), // Tab thống kê doanh thu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await PreferenceService.clearToken();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: 'Sản phẩm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Danh mục',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Đơn hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Thống kê',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
