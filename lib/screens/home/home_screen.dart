import 'package:flutter/material.dart';
import '../../base/constants/app_constants.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/inkwell_bottom_nav_bar.dart';
import '../add_book/add_book_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/profile_screen.dart';
import 'home_service.dart';
import 'viewmodels/home_view_model.dart';
import 'views/home_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  late final HomeViewModel _homeViewModel;
  late final List<InkwellBottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel(service: HomeService());
    _navItems = const [
      InkwellBottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Ana Sayfa',
      ),
      InkwellBottomNavItem(
        icon: Icons.add_box_outlined,
        activeIcon: Icons.add_box_rounded,
        label: 'Ekle',
      ),
      InkwellBottomNavItem(
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Mesajlar',
      ),
      InkwellBottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: IndexedStack(
        index: _tabIndex,
        children: [
          BaseView<HomeViewModel>(
            useValue: true,
            vmBuilder: (_) => _homeViewModel,
            builder: (context, viewModel) => HomeView(viewModel: viewModel),
          ),
          AddBookScreen(
            onBookAdded: () {
              // Kitap eklendi -> Ana sayfaya dön ve listeyi yenile
              setState(() => _tabIndex = 0);
              _homeViewModel.loadBooks();
            },
          ),
          const MessagesScreen(),
          const ProfileScreen(),
        ],
      ),
      // UI dokümanına göre "Ekle" bir sekme: FAB ile tekrar etmiyoruz.
      bottomNavigationBar: InkwellBottomNavBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        items: _navItems,
      ),
    );
  }
}
