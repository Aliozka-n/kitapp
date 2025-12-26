import 'user_dto.dart';

/// Login Request DTO
class LoginRequest {
  final String email;
  final String password;
  final bool? rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe ?? false,
    };
  }
}

/// Login Response DTO
class LoginResponse {
  final String? token;
  final String? refreshToken;
  final UserResponse? user;
  final DateTime? expiresAt;

  LoginResponse({
    this.token,
    this.refreshToken,
    this.user,
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

/// Register Request DTO
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String? il;
  final String? ilce;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.il,
    this.ilce,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'il': il,
      'ilce': ilce,
    };
  }
}

/// Register Response DTO
class RegisterResponse {
  final String? token;
  final UserResponse? user;

  RegisterResponse({
    this.token,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'],
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user?.toJson(),
    };
  }
}

