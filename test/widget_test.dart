import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emubot_flutter/core/config/app_config.dart';
import 'package:emubot_flutter/core/theme/app_theme.dart';

void main() {
  testWidgets('App configuration is correct', (WidgetTester tester) async {
    // Test app configuration
    expect(AppConfig.appName, 'EmuBot');
    expect(AppConfig.appVersion, '1.0.0');
  });

  testWidgets('App theme is created correctly', (WidgetTester tester) async {
    // Test that themes can be created without errors
    final lightTheme = AppTheme.lightTheme;
    final darkTheme = AppTheme.darkTheme;
    
    expect(lightTheme, isA<ThemeData>());
    expect(darkTheme, isA<ThemeData>());
    expect(lightTheme.primaryColor, isNotNull);
    expect(darkTheme.primaryColor, isNotNull);
  });

  testWidgets('Basic MaterialApp can be created', (WidgetTester tester) async {
    // Create a simple test app without Firebase dependencies
    await tester.pumpWidget(
      MaterialApp(
        title: AppConfig.appName,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: Text('Test App'),
          ),
        ),
      ),
    );

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Test App'), findsOneWidget);
  });
}
