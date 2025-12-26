/// Environment Configuration - Güvenli credentials yönetimi
///
/// Kullanım:
/// - Development: flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_KEY=xxx
/// - Production: Build-time environment variables kullanılmalı
class EnvConfig {
  // Environment variables - Build-time'da set edilir
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gxuhgqfvyxzbpeftspzt.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: 'sb_publishable_toNC6HPDYXDBJS3Zn1yDJg_NGwYWCgM',
  );

  // Environment kontrolü
  static bool get isProduction {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    return env == 'prod';
  }

  static bool get isDevelopment => !isProduction;

  // Private constructor - Singleton pattern
  EnvConfig._();
}
