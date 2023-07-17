import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/const/app_text.dart';
import 'package:kitapp/screens/add_book/add_view.dart';
import 'package:kitapp/screens/home/view/home_view.dart';
import 'package:kitapp/screens/message/message_view.dart';
import 'package:kitapp/screens/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Widget> tabBarList = [
    HomeView(),
    AddView(),
    MessageView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: buildAppBar(),
        bottomNavigationBar: buildConvexAppBar(),
        body: buildTabBarView(),
      ),
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(), children: tabBarList);
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text(AppText.appName),
      centerTitle: true,
    );
  }

  ConvexAppBar buildConvexAppBar() {
    return ConvexAppBar(
      backgroundColor: AppColors.primary,
      activeColor: AppColors.white,
      color: AppColors.grey,
      items: [
        TabItem(icon: Icons.home, title: 'Ana Sayfa'),
        TabItem(icon: Icons.add, title: 'Ekle'),
        TabItem(icon: Icons.message, title: 'Mesajlar'),
        TabItem(icon: Icons.people, title: 'Profil'),
      ],
      onTap: (int i) {},
    );
  }
}
