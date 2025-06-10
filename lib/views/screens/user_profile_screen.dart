import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_appflowershop/bloc/order/order_get_user/order_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_bloc.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_event.dart';
import 'package:frontend_appflowershop/bloc/user/user_profile/user_profile_state.dart';
import 'package:frontend_appflowershop/data/services/Order/api_order.dart';
import 'package:frontend_appflowershop/views/screens/login_screen.dart';
import 'package:frontend_appflowershop/views/screens/order_screen.dart';
import 'package:frontend_appflowershop/views/widgets/user/change_password_screen.dart';
import 'package:frontend_appflowershop/views/widgets/user/user_details_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(FetchUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileLoggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserProfileError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is UserProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần thông tin người dùng
                    _buildUserInfoCard(context, user),
                    const SizedBox(height: 16),
                    // Phần tài khoản
                    _buildSectionTitle('Tài khoản'),
                    _buildAccountSection(context),
                    const SizedBox(height: 16),
                    // Phần chính sách
                    _buildSectionTitle('Thông tin'),
                    _buildPolicySection(context),
                    const SizedBox(height: 16),
                    // Nút đăng xuất
                    _buildLogoutButton(context),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, dynamic user) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red[50]!, width: 1),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(user: user),
            ),
          );
          if (result == true) {
            context.read<UserProfileBloc>().add(FetchUserProfileEvent());
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red[50]!, Colors.white],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                  backgroundColor: Colors.red[100],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.red[300]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.phoneNumber ?? 'Chưa có số điện thoại',
                      style: TextStyle(
                        fontSize: 16,
                        color: user.phoneNumber != null
                            ? Colors.black54
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red[700],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red[50]!, width: 1),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.account_balance_wallet,
            title: 'Tích lũy hiện tại',
            trailing: '0đ',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.star,
            title: 'Hạng thành viên',
            trailing: 'Chưa xếp hạng',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.receipt,
            title: 'Đơn hàng của tôi',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => OrderBloc(
                      context.read<ApiOrderService>(),
                    ),
                    child: const OrderScreen(),
                  ),
                ),
              );
            },
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.location_on,
            title: 'Số địa chỉ',
            trailing: '0',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.favorite,
            title: 'Sản phẩm yêu thích',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.card_giftcard,
            title: 'Vouchers của tôi',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.password,
            title: 'Đổi mật khẩu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
            color: Colors.red[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red[50]!, width: 1),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.info,
            title: 'Chính sách giao hàng',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.info,
            title: 'Chính sách đổi trả và hoàn tiền',
            color: Colors.red[700]!,
          ),
          _buildListTile(
            icon: Icons.info,
            title: 'Chính sách bảo mật thông tin',
            color: Colors.red[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailing,
    Color color = Colors.black,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.red[50]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: trailing != null
            ? Text(
                trailing,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              )
            : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red[300]),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          context.read<UserProfileBloc>().add(LogoutEvent());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: const Text(
          'Đăng xuất',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
