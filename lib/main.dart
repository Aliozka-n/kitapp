import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'base/constants/app_constants.dart';
import 'base/constants/app_texts.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/add_book/add_book_screen.dart';
import 'screens/book_detail/book_detail_screen.dart';
import 'screens/chat_detail/chat_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/edit_profile/edit_profile_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/views/privacy_policy_view.dart';
import 'screens/settings/views/terms_of_service_view.dart';
import 'utils/navigation_util.dart';
import 'utils/network_config.dart';
import 'utils/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Turkish locale
  await initializeDateFormatting('tr_TR', null);

  // Supabase'i initialize et - Environment variables kullanarak
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  // NetworkConfig'e Supabase bilgilerini kaydet
  NetworkConfig.setSupabaseUrl(EnvConfig.supabaseUrl);
  NetworkConfig.setSupabaseAnonKey(EnvConfig.supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          title: AppTexts.appName,
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case NavigationUtil.loginScreen:
                return MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                );
              case NavigationUtil.registerScreen:
                return MaterialPageRoute(
                  builder: (_) => const RegisterScreen(),
                );
              case NavigationUtil.homeScreen:
                return MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                );
              case NavigationUtil.addBookScreen:
                return MaterialPageRoute(
                  builder: (_) => const AddBookScreen(),
                );
              case NavigationUtil.bookDetailScreen:
                return MaterialPageRoute(
                  builder: (_) => BookDetailScreen(
                    bookId: settings.arguments as String?,
                  ),
                );
              case NavigationUtil.chatDetailScreen:
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    receiverId: args?['receiverId'] as String? ?? '',
                    receiverName:
                        args?['receiverName'] as String? ?? 'Kullanıcı',
                  ),
                );
              case NavigationUtil.profileScreen:
                return MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                );
              case NavigationUtil.forgotPasswordScreen:
                return MaterialPageRoute(
                  builder: (_) => const ForgotPasswordScreen(),
                );
              case NavigationUtil.editProfileScreen:
                return MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                );
              case NavigationUtil.searchScreen:
                return MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                );
              case NavigationUtil.settingsScreen:
                return MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                );
              case NavigationUtil.privacyPolicyScreen:
                return MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyView(),
                );
              case NavigationUtil.termsOfServiceScreen:
                return MaterialPageRoute(
                  builder: (_) => const TermsOfServiceView(),
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                );
            }
          },
        );
      },
    );
  }
}
