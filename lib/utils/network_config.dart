/// Environment enum
enum Environment {
  test,
  prod,
}

/// Network Configuration - Supabase Base URL yönetimi
class NetworkConfig {
  static Environment _environment = Environment.test;
  static String? _supabaseUrl;
  static String? _supabaseAnonKey;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static void setSupabaseUrl(String url) {
    _supabaseUrl = url;
  }

  static void setSupabaseAnonKey(String key) {
    _supabaseAnonKey = key;
  }

  /// Supabase Anon Key
  String? get supabaseAnonKey => _supabaseAnonKey;

  /// Supabase REST API Base URL
  String get baseUrl {
    if (_supabaseUrl == null) {
      throw Exception('Supabase URL is not set. Please initialize Supabase in main.dart');
    }
    return '$_supabaseUrl/rest/v1/';
  }

  /// Supabase Auth API Base URL
  String get authBaseUrl {
    if (_supabaseUrl == null) {
      throw Exception('Supabase URL is not set. Please initialize Supabase in main.dart');
    }
    return '$_supabaseUrl/auth/v1/';
  }

  Environment get environment => _environment;
}

