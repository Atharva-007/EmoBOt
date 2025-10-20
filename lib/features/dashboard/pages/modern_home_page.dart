import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/bloc/theme_cubit.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/bloc/auth_event.dart';
import '../../profile/pages/profile_page.dart';
import '../widgets/animated_avatar_3d.dart';

class ModernHomePage extends StatefulWidget {
  const ModernHomePage({super.key});

  @override
  State<ModernHomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends State<ModernHomePage>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _contentController;
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const _HomePage(),
    const _ExplorePage(),
    const _SettingsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(isDark),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(context, isDark),
                
                // Page Content
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
          
          // Floating Navigation Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buildFloatingNavbar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft + 
                  Alignment(_backgroundController.value * 2 - 1, 0),
              end: Alignment.bottomRight - 
                  Alignment(_backgroundController.value * 2 - 1, 0),
              colors: isDark
                  ? [
                      const Color(0xFF0D1B2A),
                      const Color(0xFF1B263B),
                      const Color(0xFF415A77),
                    ]
                  : [
                      const Color(0xFFF0F8FF),
                      const Color(0xFFE6F3FF),
                      const Color(0xFFCCE7FF),
                    ],
            ),
          ),
          child: CustomPaint(
            painter: BackgroundParticlesPainter(
              animationValue: _backgroundController.value,
              isDark: isDark,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Greeting
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String greeting = "Welcome to EmuBot";
                if (state is AuthAuthenticated && 
                    state.user.displayName?.isNotEmpty == true) {
                  final hour = DateTime.now().hour;
                  final timeGreeting = hour < 12 
                      ? "Good Morning" 
                      : hour < 17 
                          ? "Good Afternoon" 
                          : "Good Evening";
                  greeting = "$timeGreeting, ${state.user.displayName}";
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      "Ready to explore AI?",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Theme Toggle and Avatar
          Row(
            children: [
              // Theme Toggle
              GlassmorphicContainer(
                width: 50,
                height: 50,
                borderRadius: 25,
                blur: 20,
                alignment: Alignment.center,
                border: 1,
                linearGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: isDark ? Colors.white : Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // User Avatar
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 3; // Profile page
                  });
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated && 
                        state.user.photoURL != null) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(state.user.photoURL!),
                      );
                    }
                    return GlassmorphicContainer(
                      width: 50,
                      height: 50,
                      borderRadius: 25,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 1,
                      linearGradient: LinearGradient(
                        colors: AppTheme.primaryGradient,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: -1, duration: 800.ms, curve: Curves.easeOutBack)
        .fadeIn();
  }

  Widget _buildFloatingNavbar() {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.explore, 'label': 'Explore'},
      {'icon': Icons.settings, 'label': 'Settings'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return GlassmorphicContainer(
      width: double.infinity,
      height: 70,
      borderRadius: 35,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? LinearGradient(colors: AppTheme.primaryGradient)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected
                        ? Colors.white
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : Colors.black60),
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Main Avatar with 3D Animation
          const AnimatedAvatar3D(
            size: 150,
            primaryColor: Color(0xFF6366F1),
            secondaryColor: Color(0xFF8B5CF6),
          )
              .animate()
              .scale(delay: 300.ms, duration: 800.ms)
              .fadeIn(),
          
          const SizedBox(height: 40),
          
          // Welcome Message
          Text(
            "Hello! I'm EmuBot",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .slideY(begin: 0.3, duration: 800.ms, delay: 500.ms)
              .fadeIn(),
          
          const SizedBox(height: 16),
          
          Text(
            "Your AI companion for creative exploration,\nlearning, and fun conversations!",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .slideY(begin: 0.3, duration: 800.ms, delay: 700.ms)
              .fadeIn(),
          
          const SizedBox(height: 50),
          
          // Interactive Features
          _buildInteractiveFeatures(context),
          
          const SizedBox(height: 100), // Space for floating navbar
        ],
      ),
    );
  }

  Widget _buildInteractiveFeatures(BuildContext context) {
    final features = [
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'Start Chatting',
        'subtitle': 'Begin a conversation with AI',
        'color': const Color(0xFF6366F1),
      },
      {
        'icon': Icons.explore_outlined,
        'title': 'Explore Features',
        'subtitle': 'Discover what I can do',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Customize',
        'subtitle': 'Personalize your experience',
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassmorphicContainer(
            width: double.infinity,
            height: 80,
            borderRadius: 20,
            blur: 20,
            alignment: Alignment.center,
            border: 1,
            linearGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      feature['color'] as Color,
                      (feature['color'] as Color).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                feature['title'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              subtitle: Text(
                feature['subtitle'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white30
                    : Colors.black26,
                size: 16,
              ),
              onTap: () {
                // Handle feature tap
              },
            ),
          ),
        )
            .animate()
            .slideX(
              begin: index.isEven ? -0.3 : 0.3,
              duration: 800.ms,
              delay: Duration(milliseconds: 900 + (index * 100)),
            )
            .fadeIn();
      }).toList(),
    );
  }
}

class _ExplorePage extends StatelessWidget {
  const _ExplorePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Explore Page\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Settings Page\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class BackgroundParticlesPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  BackgroundParticlesPainter({
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.5)) % size.width;
      final y = (size.height * (i * 0.07 + animationValue * 0.3)) % size.height;
      final radius = 2 + (i % 3);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.isDark != isDark;
  }
}