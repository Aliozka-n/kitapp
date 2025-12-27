import 'dart:async';
import 'package:flutter/foundation.dart';

/// Base ViewModel sınıfı - Tüm ViewModel'ler bu sınıftan türemelidir
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  bool _isInitialized = false;
  FutureOr<void> _initState;

  BaseViewModel() {
    load(); // Otomatik olarak çağrılır
  }

  // Tüm ViewModel'lerin implement etmesi gereken method
  FutureOr<void> init();

  void load() async {
    isLoading = true;
    try {
      _initState = init();
      await _initState;
    } catch (e, stackTrace) {
      // Hata olsa bile initialized olarak işaretle ki ekran açılabilsin
      // Hata ViewModel'deki errorMessage ile gösterilebilir
      if (kDebugMode) {
        // ignore: avoid_print
        print('BaseViewModel load error - ${runtimeType}: $e');
        // ignore: avoid_print
        print('Stack trace: $stackTrace');
      }
    } finally {
      _isInitialized = true;
      isLoading = false;
    }
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isDisposed => _isDisposed;

  // Setters
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }

  void reloadState() {
    if (!isLoading) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
