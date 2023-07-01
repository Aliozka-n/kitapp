import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kitapp/const/app_colors.dart';
import 'package:kitapp/screens/home/view/home_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: buildAppBar(),
        bottomNavigationBar: buildConvexAppBar(),
        body: TabBarView(children: [
          HomeView(),
          Text(""),
          Text(""),
          Text(""),
        ]),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Text("sasa"),
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
      onTap: (int i) => print('click index=$i'),
    );
  }
}
