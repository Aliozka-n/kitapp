import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/constants/app_constants.dart';
import '../../base/constants/app_size.dart';
import '../../base/views/base_view.dart';
import 'home_service.dart';
import 'viewmodels/home_view_model.dart';
import 'views/home_view.dart';
import '../add_book/add_book_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/profile_screen.dart';

/// Home Screen - Modern TabBar yapısı ile ana ekran
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          // TabBarView index'ini bottom nav index'ine çevir
          // TabBarView: [0: HomeView, 1: AddBookScreen, 2: MessagesScreen, 3: ProfileScreen]
          // Bottom nav: [0: Ana Sayfa, 1: Ekle, 2: Mesajlar, 3: Profil]
          final tabIndex = _tabController.index;
          if (tabIndex == 0) {
            _currentIndex = 0; // HomeView -> Ana Sayfa
          } else if (tabIndex == 1) {
            _currentIndex = 1; // AddBookScreen -> Ekle
          } else if (tabIndex == 2) {
            _currentIndex = 2; // MessagesScreen -> Mesajlar
          } else if (tabIndex == 3) {
            _currentIndex = 3; // ProfileScreen -> Profil
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          BaseView<HomeViewModel>(
            vmBuilder: (_) => HomeViewModel(
              service: HomeService(),
            ),
            builder: (context, viewModel) => HomeView(viewModel: viewModel),
          ),
          const AddBookScreen(),
          const MessagesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.sizeMedium.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Ana Sayfa', 0),
              _buildNavItem(Icons.add_rounded, 'Ekle', 1),
              _buildNavItem(Icons.message_rounded, 'Mesajlar', 2),
              _buildNavItem(Icons.person_rounded, 'Profil', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // TabBarView index mapping:
          // Bottom nav: [0: Ana Sayfa, 1: Ekle, 2: Mesajlar, 3: Profil]
          // TabBarView: [0: HomeView, 1: AddBookScreen, 2: MessagesScreen, 3: ProfileScreen]
          // Index'ler aynı olduğu için direkt kullanabiliriz
          _tabController.animateTo(index);
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isActive ? 8.w : 6.w),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.textLight,
                size: isActive ? 26.sp : 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textLight,
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
