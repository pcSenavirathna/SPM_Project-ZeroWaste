import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/screens/binManagement/schedule_details.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';
import 'package:zero_waste/utils/user_types.dart';
import '../../providers/user_provider.dart';

class ProfileViewScreen extends StatelessWidget {
  final User loginedUser;
  final HouseholdUser? householdUser;
  final Employee? employee;

  const ProfileViewScreen(
      {super.key,
      required this.loginedUser,
      required this.householdUser,
      required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    profileCard(context),
                    const SizedBox(height: 20),
                    buttonCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard(BuildContext context) {
    late String id;
    late String name;
    late String img;

    if (loginedUser.userType == UserTypes.HOUSEHOLD_USER) {
      id = householdUser!.id;
      name = '${householdUser!.fName} ${householdUser!.lName}';
      img = householdUser!.imageUrl;
    } else if (loginedUser.userType == UserTypes.EMPLOYEE) {
      id = employee!.id;
      name = '${employee!.fName} ${employee!.lName}';
      img = employee!.imageUrl;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    img == '' ? 'https://via.placeholder.com/150' : img,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              id,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              loginedUser.email,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildProfileOption(
            context: context,
            icon: Icons.person,
            text: 'Update Profile',
            onTap: () => context.go('/user/update'),
          ),
          privilegeButtons(context),
          _buildProfileOption(
            context: context,
            icon: Icons.nights_stay,
            text: 'Dark Mode',
            onTap: () => {},
          ),
          _buildProfileOption(
            context: context,
            icon: Icons.logout,
            text: 'Sign Out',
            onTap: () => {
              Provider.of<UserProvider>(context, listen: false).logout(),
              context.go('/user/login')
            },
          ),
        ],
      ),
    );
  }

  Widget privilegeButtons(BuildContext context) {
    if (loginedUser.userType == UserTypes.EMPLOYEE) {
      switch (employee!.employeeType) {
        case UserTypes.EMPLOYEE:
          return Column(
            children: [
              _buildProfileOption(
                context: context,
                icon: Icons.person_add,
                text: 'Add Employee',
                onTap: () => context.go('/employee/register'),
              ),
              _buildProfileOption(
                context: context,
                icon: CustomBins.wasteBin,
                text: 'Create Bin',
                onTap: () => context.go('/bin/create'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.add_road_outlined,
                text: 'Create Route',
                onTap: () => context.go('/route/create'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.schedule_outlined,
                text: 'Schedule Route',
                onTap: () => context.go('/route/assign'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.history,
                text: 'User Garbage History',
                onTap: () => context.go('/collection/history'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.control_point_duplicate_outlined,
                text: 'Update Point Allocation',
                onTap: () => context.go('/reward/gifts'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.card_giftcard,
                text: 'Reward Items',
                onTap: () => context.go('/reward/items'),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.card_giftcard,
                text: 'Reward Points',
                onTap: () => context.go('/reward/points'),
              ),
              _buildProfileOption(
                context: context,
                text: 'Smart Bin Level',
                icon: Icons.recycling,
                onTap: () => context.go('/smartbin/garabagelevel'),
              ),
              _buildProfileOption(
                context: context,
                text: 'SmartBin QR Code Gen',
                icon: Icons.qr_code,
                onTap: () => context.go('/smartbin/qrgenarate'),
              ),
              _buildProfileOption(
                context: context,
                text: 'QR Code Scanner',
                icon: Icons.qr_code,
                onTap: () => context.go('/smartbin/qrscanner'),
              ),_buildProfileOption(
                context: context,
                text: 'notification',
                icon: Icons.notification_important,
                onTap: () => context.go('/notifications'),
              ),
            ],
          );
        case UserTypes.TRUCK_DRIVER:
          return const Column(
            children: [
              SizedBox(height: 0),
            ],
          );
        default:
          return const SizedBox(height: 0);
      }
    } else {
      return Column(
        children: [
          _buildProfileOption(
            context: context,
            icon: Icons.card_giftcard,
            text: 'Reward Gifts',
            onTap: () => context.go('/reward/gifts'),
          ),
        ],
      );
    }
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
      onTap: onTap,
    );
  }
}
