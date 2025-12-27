import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../base/models/service_response.dart';
import '../../utils/shared_preferences_util.dart';

/// Settings Service - Ayar işlemleri için servis
class SettingsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Şifre doğrula (re-authenticate)
  Future<ServiceResponse<bool>> verifyPassword(String password) async {
    try {
      final email = _supabase.auth.currentUser?.email;
      if (email == null) {
        return ServiceResponse<bool>(
          isSuccessful: false,
          data: false,
          message: 'Kullanıcı bulunamadı',
        );
      }

      // Mevcut şifreyle tekrar giriş yaparak doğrula
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return ServiceResponse<bool>(
        isSuccessful: true,
        data: true,
        message: 'Şifre doğrulandı',
      );
    } catch (e) {
      return ServiceResponse<bool>(
        isSuccessful: false,
        data: false,
        message: 'Şifre yanlış',
      );
    }
  }

  /// Şifre değiştir
  Future<ServiceResponse<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Supabase ile şifre güncelleme
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return ServiceResponse<bool>(
        isSuccessful: true,
        data: true,
        message: 'Şifre başarıyla güncellendi',
      );
    } catch (e) {
      return ServiceResponse<bool>(
        isSuccessful: false,
        data: false,
        message: 'Şifre güncellenirken hata oluştu: ${e.toString()}',
      );
    }
  }

  /// Hesabı sil
  Future<ServiceResponse<bool>> deleteAccount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return ServiceResponse<bool>(
          isSuccessful: false,
          data: false,
          message: 'Kullanıcı bulunamadı',
        );
      }

      // Kullanıcının kitaplarını sil
      await _supabase.from('books').delete().eq('user_id', userId);

      // Kullanıcının favorilerini sil
      await _supabase.from('favorites').delete().eq('user_id', userId);

      // Kullanıcının mesajlarını sil
      await _supabase
          .from('messages')
          .delete()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId');

      // Kullanıcının profilini sil
      await _supabase.from('profiles').delete().eq('id', userId);

      // Oturumu kapat
      await _supabase.auth.signOut();

      // SharedPreferences'ı temizle
      final prefs = await SharedPreferencesUtil.getInstance();
      await prefs.removeAll();

      return ServiceResponse<bool>(
        isSuccessful: true,
        data: true,
        message: 'Hesap başarıyla silindi',
      );
    } catch (e) {
      return ServiceResponse<bool>(
        isSuccessful: false,
        data: false,
        message: 'Hesap silinirken hata oluştu: ${e.toString()}',
      );
    }
  }

  /// Bildirim ayarını güncelle
  Future<ServiceResponse<bool>> updateNotificationSetting({
    required String key,
    required bool value,
  }) async {
    try {
      final prefs = await SharedPreferencesUtil.getInstance();
      await prefs.setBool(key, value);

      return ServiceResponse<bool>(
        isSuccessful: true,
        data: true,
        message: 'Ayar güncellendi',
      );
    } catch (e) {
      return ServiceResponse<bool>(
        isSuccessful: false,
        data: false,
        message: 'Ayar güncellenirken hata oluştu',
      );
    }
  }

  /// Bildirim ayarını oku
  Future<bool> getNotificationSetting(String key) async {
    try {
      final prefs = await SharedPreferencesUtil.getInstance();
      return prefs.getBool(key) ?? true;
    } catch (e) {
      return true;
    }
  }

  /// Cache temizle
  Future<ServiceResponse<bool>> clearCache() async {
    try {
      final prefs = await SharedPreferencesUtil.getInstance();
      // Token ve user bilgilerini koru, sadece cache'i temizle
      final token = prefs.getToken();
      final userId = prefs.getUserId();

      await prefs.removeAll();

      // Önemli bilgileri geri yükle
      if (token != null) await prefs.setToken(token);
      if (userId != null) await prefs.setUserId(userId);

      return ServiceResponse<bool>(
        isSuccessful: true,
        data: true,
        message: 'Önbellek temizlendi',
      );
    } catch (e) {
      return ServiceResponse<bool>(
        isSuccessful: false,
        data: false,
        message: 'Önbellek temizlenirken hata oluştu',
      );
    }
  }

  /// Uygulama versiyonu
  String getAppVersion() {
    return '1.0.0';
  }
}
