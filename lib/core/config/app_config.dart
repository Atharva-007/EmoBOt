class AppConfig {
  static const String appName = 'EmuBot';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Firebase Configuration
  static const String firebaseProjectId = 'emuai-ee72a';
  
  // API Configuration
  static const String baseUrl = 'https://api.emubot.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Theme Configuration
  static const bool enableGlassmorphism = true;
  static const bool enableAnimations = true;
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  
  // App Settings
  static const int maxRetryAttempts = 3;
  static const Duration splashScreenDuration = Duration(seconds: 2);
}