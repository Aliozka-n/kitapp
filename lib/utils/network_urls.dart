import 'network_config.dart';

/// Network URLs - Supabase API endpoint'lerinin merkezi yönetimi
class NetworkUrls {
  final _baseUrl = NetworkConfig().baseUrl;
  final _authBaseUrl = NetworkConfig().authBaseUrl;

  // Supabase Auth endpoints
  String get signUpUrl => '${_authBaseUrl}signup';
  String get signInUrl => '${_authBaseUrl}token?grant_type=password';
  String get signOutUrl => '${_authBaseUrl}logout';
  String get userUrl => '${_authBaseUrl}user';

  // Supabase REST API endpoints (table names)
  // Not: Supabase'de tablo isimleri küçük harfle ve snake_case olmalı
  String get booksUrl => '${_baseUrl}books';
  String get bookDetailUrl => '${_baseUrl}books'; // ?id=eq.{id} ile filtreleme

  String get usersUrl => '${_baseUrl}users';
  String get profileUrl => '${_baseUrl}users'; // ?id=eq.{id} ile filtreleme

  String get messagesUrl => '${_baseUrl}messages';
}
