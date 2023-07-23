import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_text.dart';
import 'package:kitapp/screens/add_book/add_view.dart';
import 'package:kitapp/screens/home/widgets/home_view.dart';
import 'package:kitapp/screens/profile/profile_screen.dart';

@immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Widget> tabBarList = [
    const HomeView(),
    const AddView(),
    const ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppText.appName)),
        bottomNavigationBar: buildConvexAppBar(),
        body: buildTabBarView(),
      ),
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(), children: tabBarList);
  }

  ConvexAppBar buildConvexAppBar() {
    return ConvexAppBar(
      backgroundColor: AppColors.primary,
      activeColor: AppColors.white,
      color: AppColors.grey,
      items: const [
        TabItem(icon: Icons.home, title: 'Ana Sayfa'),
        TabItem(icon: Icons.add, title: 'Ekle'),
        TabItem(icon: Icons.manage_accounts, title: 'Profil'),
      ],
      onTap: (int i) {},
    );
  }
}
