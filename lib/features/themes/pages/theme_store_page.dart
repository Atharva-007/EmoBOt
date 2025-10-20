import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/bloc/theme_cubit.dart';
import '../../../core/utils/animation_utils.dart';

class ThemeStorePage extends StatefulWidget {
  const ThemeStorePage({super.key});

  @override
  State<ThemeStorePage> createState() => _ThemeStorePageState();
}

class _ThemeStorePageState extends State<ThemeStorePage>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late ScrollController _scrollController;
  
  double _scrollOffset = 0.0;
  
  final List<ThemeOption> _themes = [
    ThemeOption(
      name: 'Deep Blue',
      description: 'Cool and professional',
      gradient: const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      isPremium: false,
    ),
    ThemeOption(
      name: 'Sunset Glow',
      description: 'Warm and energetic',
      gradient: const LinearGradient(
        colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
      ),
      isPremium: true,
    ),
    ThemeOption(
      name: 'Forest Breeze',
      description: 'Natural and calming',
      gradient: const LinearGradient(
        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
      ),
      isPremium: false,
    ),
    ThemeOption(
      name: 'Royal Purple',
      description: 'Elegant and luxurious',
      gradient: const LinearGradient(
        colors: [Color(0xFFe056fd), Color(0xFFf441a5)],
      ),
      isPremium: true,
    ),
    ThemeOption(
      name: 'Golden Hour',
      description: 'Rich and sophisticated',
      gradient: const LinearGradient(
        colors: [Color(0xFFfb8500), Color(0xFFffb347)],
      ),
      isPremium: true,
    ),
    ThemeOption(
      name: 'Ocean Depth',
      description: 'Deep and mysterious',
      gradient: const LinearGradient(
        colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
      ),
      isPremium: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollController();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  void _setupScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(size, isDark),
          
          // Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 100),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeaderSection(),
                      
                      const SizedBox(height: 30),
                      
                      // Theme Mode Toggle
                      _buildThemeModeToggle(),
                      
                      const SizedBox(height: 40),
                      
                      // Themes Grid
                      _buildThemesGrid(),
                      
                      const SizedBox(height: 40),
                      
                      // Premium Section
                      _buildPremiumSection(),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: FadeInLeft(
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: FadeInDown(
        child: Text(
          'Theme Store',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAnimatedBackground(Size size, bool isDark) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea),
            const Color(0xFF764ba2),
            const Color(0xFFf093fb),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating shapes
          ...List.generate(6, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final double animationValue = _backgroundController.value;
                final double offset = (index + 1) * 0.15;
                final double x = size.width * 
                    ((animationValue + offset) % 1.0);
                final double y = size.height * 0.1 + 
                    (index * size.height * 0.15);
                
                return Positioned(
                  left: x - 30,
                  top: y,
                  child: Container(
                    width: 60 + (index * 10),
                    height: 60 + (index * 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'Customize Your Experience',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
          child: Text(
            'Choose from our collection of beautiful themes to personalize your EmuBot experience.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeToggle() {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return FadeInUp(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 80,
            borderRadius: 20,
            blur: 20,
            alignment: Alignment.bottomCenter,
            border: 1.5,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Theme Mode',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      context.read<ThemeCubit>().toggleTheme();
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.3),
                    inactiveThumbColor: Colors.white.withOpacity(0.7),
                    inactiveTrackColor: Colors.white.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
          child: Text(
            'Available Themes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _themes.length,
          itemBuilder: (context, index) {
            final theme = _themes[index];
            return FadeInUp(
              delay: Duration(milliseconds: 800 + (index * 100)),
              duration: const Duration(milliseconds: 600),
              child: _buildThemeCard(theme),
            );
          },
        ),
      ],
    );
  }

  Widget _buildThemeCard(ThemeOption themeOption) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (!themeOption.isPremium) {
          // TODO: Apply theme
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${themeOption.name} theme applied!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          _showPremiumDialog(themeOption);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: themeOption.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: themeOption.gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium badge
                  if (themeOption.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.yellow[300],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.yellow[300],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Theme preview circles
                  Row(
                    children: themeOption.gradient.colors.map((color) {
                      return Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Theme name
                  Text(
                    themeOption.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Theme description
                  Text(
                    themeOption.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Lock overlay for premium themes
            if (themeOption.isPremium)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumSection() {
    return FadeInUp(
      delay: const Duration(milliseconds: 1200),
      duration: const Duration(milliseconds: 600),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 200,
        borderRadius: 24,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.yellow[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unlock Premium Themes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Get access to exclusive themes and customization options',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.yellow[400]!, Colors.orange[400]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // TODO: Navigate to premium purchase
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPremiumDialog(ThemeOption themeOption) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: GlassmorphicContainer(
          width: 300,
          height: 250,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 1.5,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.8),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 48,
                  color: Colors.orange,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Premium Theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '${themeOption.name} is a premium theme. Upgrade to unlock this and other exclusive themes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to premium purchase
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text('Upgrade'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeOption {
  final String name;
  final String description;
  final LinearGradient gradient;
  final bool isPremium;

  const ThemeOption({
    required this.name,
    required this.description,
    required this.gradient,
    required this.isPremium,
  });
}