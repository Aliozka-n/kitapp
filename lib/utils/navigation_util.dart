import 'package:flutter/material.dart';

/// Navigation Utility - Route yönetimi ve navigation işlemleri
class NavigationUtil {
  // Route isimleri
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String homeScreen = '/home';
  static const String addBookScreen = '/add-book';
  static const String bookDetailScreen = '/book-detail';
  static const String messagesScreen = '/messages';
  static const String chatDetailScreen = '/chat-detail';
  static const String profileScreen = '/profile';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String editProfileScreen = '/edit-profile';
  static const String searchScreen = '/search';

  /// Navigate to page
  static Future<T?> navigateToPage<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and replace
  static Future<T?> navigateAndReplace<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove until
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Go back until
  static void goBackUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, (route) => route.settings.name == routeName);
  }

  /// Navigate to Chat Detail Screen
  /// Helper method to standardize ChatDetailScreen navigation
  static Future<T?> navigateToChatDetail<T>(
    BuildContext context, {
    required String receiverId,
    String? receiverName,
  }) {
    return navigateToPage<T>(
      context,
      chatDetailScreen,
      arguments: {
        'receiverId': receiverId,
        'receiverName': receiverName ?? 'Kullanıcı',
      },
    );
  }
}

