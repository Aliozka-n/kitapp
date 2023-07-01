import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/screens/home/view/add_view.dart';
import 'package:kitapp/screens/home/view/home_view.dart';
import 'package:kitapp/screens/home/view/message_view.dart';
import 'package:kitapp/screens/home/view/profile_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<Widget> tabBarList = [HomeView(), AddView(), MessageView(), ProfileView()];

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
    return TabBarView(children: tabBarList);
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text("KitApp"),
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
