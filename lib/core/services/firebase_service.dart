import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../utils/logger.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
  static FirebaseDatabase get realtimeDatabase => FirebaseDatabase.instance;
  static FirebaseFunctions get functions => FirebaseFunctions.instance;
  
  static Future<void> initialize() async {
    try {
      // Configure Firestore settings
      await _configureFirestore();
      
      // Configure Analytics
      await _configureAnalytics();
      
      // Configure Storage
      await _configureStorage();
      
      // Configure Messaging
      await _configureMessaging();
      
      // Configure Realtime Database
      await _configureRealtimeDatabase();
      
      // Configure Functions
      await _configureFunctions();
      
      AppLogger.info('Firebase services initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Firebase services: $e');
      throw e;
    }
  }
  
  static Future<void> _configureFirestore() async {
    try {
      // Enable offline persistence
      await firestore.enablePersistence();
      
      // Configure settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      AppLogger.info('Firestore configured successfully');
    } catch (e) {
      AppLogger.warning('Firestore configuration warning: $e');
      // Continue without custom settings
    }
  }
  
  static Future<void> _configureAnalytics() async {
    try {
      // Set analytics collection enabled
      await analytics.setAnalyticsCollectionEnabled(true);
      
      // Set default user properties
      await analytics.setUserProperty(
        name: 'app_version',
        value: '1.0.0',
      );
      
      AppLogger.info('Analytics configured successfully');
    } catch (e) {
      AppLogger.warning('Analytics configuration warning: $e');
      // Continue without analytics
    }
  }
  
  static Future<void> _configureStorage() async {
    try {
      // Set max upload retry time
      storage.setMaxUploadRetryTime(const Duration(minutes: 5));
      
      AppLogger.info('Storage configured successfully');
    } catch (e) {
      AppLogger.warning('Storage configuration warning: $e');
    }
  }
  
  static Future<void> _configureMessaging() async {
    try {
      // Request notification permissions
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.info('Messaging permission status: ${settings.authorizationStatus}');

      // Get FCM token (only for non-web platforms or if service worker is properly configured)
      try {
        String? token = await messaging.getToken();
        if (token != null) {
          AppLogger.info('FCM Token: $token');
        }
      } catch (e) {
        AppLogger.warning('Failed to get FCM token (this is normal for web without proper service worker): $e');
      }

      AppLogger.info('Messaging configured successfully');
    } catch (e) {
      AppLogger.warning('Messaging configuration warning: $e');
    }
  }
  
  static Future<void> _configureRealtimeDatabase() async {
    try {
      // Enable offline persistence (only works on mobile platforms)
      try {
        realtimeDatabase.setPersistenceEnabled(true);
        // Set cache size
        realtimeDatabase.setPersistenceCacheSizeBytes(10000000); // 10MB
      } catch (e) {
        AppLogger.warning('Realtime Database persistence not supported on this platform: $e');
      }

      AppLogger.info('Realtime Database configured successfully');
    } catch (e) {
      AppLogger.warning('Realtime Database configuration warning: $e');
    }
  }
  
  static Future<void> _configureFunctions() async {
    try {
      // For development, you might want to use the emulator
      // functions.useFunctionsEmulator('localhost', 5001);
      
      AppLogger.info('Functions configured successfully');
    } catch (e) {
      AppLogger.warning('Functions configuration warning: $e');
    }
  }
  
  // Auth state stream
  static Stream<User?> get authStateChanges => auth.authStateChanges();
  
  // User stream
  static Stream<User?> get userChanges => auth.userChanges();
  
  // Helper methods for common Firebase operations
  
  // Storage helpers
  static Reference getStorageRef(String path) => storage.ref(path);
  
  // Firestore helpers
  static DocumentReference getUserDoc(String userId) => 
      firestore.collection('users').doc(userId);
  
  static CollectionReference get chatSessionsCollection => 
      firestore.collection('chat_sessions');
      
  static CollectionReference get chatMessagesCollection => 
      firestore.collection('chat_messages');
  
  // Analytics helpers
  static Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      AppLogger.warning('Failed to log analytics event: $e');
    }
  }
  
  // Messaging helpers
  static Future<String?> getFCMToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      AppLogger.warning('Failed to get FCM token: $e');
      return null;
    }
  }
}