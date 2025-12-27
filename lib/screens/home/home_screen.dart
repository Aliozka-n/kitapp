import 'package:flutter/material.dart';
import '../../base/constants/app_constants.dart';
import '../../base/views/base_view.dart';
import '../../common_widgets/futuristic_bottom_nav_bar.dart';
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
  int _previousTabIndex = 0;
  late final HomeViewModel _homeViewModel;
  late final List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel(service: HomeService());
    _navItems = const [
      BottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Ana Sayfa',
      ),
      BottomNavItem(
        icon: Icons.add_box_outlined,
        activeIcon: Icons.add_box_rounded,
        label: 'Ekle',
      ),
      BottomNavItem(
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Mesajlar',
      ),
      BottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];
  }

  void _onTabChanged(int index) {
    // Profil veya başka bir sekmeden Ana Sayfa'ya dönüldüğünde yenile
    if (index == 0 && _previousTabIndex != 0) {
      _homeViewModel.loadBooks(isSilent: true);
    }
    _previousTabIndex = _tabIndex;
    setState(() => _tabIndex = index);
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Floating bottom bar requires this
      backgroundColor: AppColors.backgroundCanvas,
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
              _onTabChanged(0);
              _homeViewModel.loadBooks();
            },
          ),
          const MessagesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: FuturisticBottomNavBar(
        currentIndex: _tabIndex,
        onTap: _onTabChanged,
        items: _navItems,
      ),
    );
  }
}
