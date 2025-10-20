import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../core/layout/app_layout.dart';
import '../../../core/theme/bloc/theme_cubit.dart';
import '../widgets/theme_card.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;

  final List<ThemeOption> _themes = [
    ThemeOption(
      name: 'Auto (System)',
      description: 'Follows system theme',
      mode: ThemeMode.system,
      gradientColors: [Colors.grey.shade400, Colors.grey.shade600],
      icon: Icons.auto_awesome,
    ),
    ThemeOption(
      name: 'Light Mode',
      description: 'Clean and bright',
      mode: ThemeMode.light,
      gradientColors: [Colors.blue.shade300, Colors.purple.shade300],
      icon: Icons.light_mode,
    ),
    ThemeOption(
      name: 'Dark Mode',
      description: 'Easy on the eyes',
      mode: ThemeMode.dark,
      gradientColors: [Colors.indigo.shade800, Colors.purple.shade900],
      icon: Icons.dark_mode,
    ),
  ];

  final List<ColorTheme> _colorThemes = [
    ColorTheme(
      name: 'Gmail Red',
      description: 'Classic Gmail colors',
      primaryColor: const Color(0xFFDB4437),
      secondaryColor: const Color(0xFFEA4335),
      gradientColors: [const Color(0xFFDB4437), const Color(0xFFEA4335)],
    ),
    ColorTheme(
      name: 'Ocean Blue',
      description: 'Deep ocean vibes',
      primaryColor: const Color(0xFF667eea),
      secondaryColor: const Color(0xFF764ba2),
      gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
    ),
    ColorTheme(
      name: 'Sunset Orange',
      description: 'Warm sunset colors',
      primaryColor: const Color(0xFFf093fb),
      secondaryColor: const Color(0xFFf5576c),
      gradientColors: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    ),
    ColorTheme(
      name: 'Forest Green',
      description: 'Nature inspired',
      primaryColor: const Color(0xFF11998e),
      secondaryColor: const Color(0xFF38ef7d),
      gradientColors: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
    ),
    ColorTheme(
      name: 'Royal Purple',
      description: 'Elegant and royal',
      primaryColor: const Color(0xFFe056fd),
      secondaryColor: const Color(0xFFf441a5),
      gradientColors: [const Color(0xFFe056fd), const Color(0xFFf441a5)],
    ),
    ColorTheme(
      name: 'Golden Hour',
      description: 'Warm golden tones',
      primaryColor: const Color(0xFFfb8500),
      secondaryColor: const Color(0xFFffb347),
      gradientColors: [const Color(0xFFfb8500), const Color(0xFFffb347)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppLayout(
      title: 'Themes',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    const Color(0xFF0F0F0F),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFFF8FAFF),
                    const Color(0xFFE8F4FD),
                    const Color(0xFFD4EDDA),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Mode Section
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Mode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose how the app looks',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Theme Mode Cards
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, currentTheme) {
                    return Column(
                      children: _themes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final theme = entry.value;
                        
                        return FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: Duration(milliseconds: 100 * index),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ThemeCard(
                              theme: theme,
                              isSelected: currentTheme == theme.mode,
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(theme.mode);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Color Themes Section
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color Themes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pick your favorite color palette',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Color Theme Grid
                AnimatedBuilder(
                  animation: _staggerController,
                  builder: (context, child) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _colorThemes.length,
                      itemBuilder: (context, index) {
                        final colorTheme = _colorThemes[index];
                        final delay = (index * 100).clamp(0, 800);
                        
                        return FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: Duration(milliseconds: delay + 600),
                          child: _buildColorThemeCard(colorTheme, isDark),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Personalization Section
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 800),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Colors.purple.withOpacity(0.2),
                                Colors.blue.withOpacity(0.1),
                              ]
                            : [
                                Colors.blue.withOpacity(0.1),
                                Colors.purple.withOpacity(0.05),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.palette_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'More Customization Coming Soon!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Custom colors, fonts, and animations',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorThemeCard(ColorTheme colorTheme, bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement color theme switching
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${colorTheme.name} theme selected!'),
            backgroundColor: colorTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colorTheme.gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorTheme.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.color_lens,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  colorTheme.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  colorTheme.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
      .scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1.0, 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
      )
      .fadeIn(duration: const Duration(milliseconds: 300));
  }
}

class ThemeOption {
  final String name;
  final String description;
  final ThemeMode mode;
  final List<Color> gradientColors;
  final IconData icon;

  ThemeOption({
    required this.name,
    required this.description,
    required this.mode,
    required this.gradientColors,
    required this.icon,
  });
}

class ColorTheme {
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color> gradientColors;

  ColorTheme({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gradientColors,
  });
}