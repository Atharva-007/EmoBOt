import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../features/profile/pages/profile_page.dart';
import '../../../features/themes/pages/themes_page.dart';
import '../../../core/animations/premium_animations.dart';

class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({super.key});

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _rippleController;

  final List<_NavBarItem> _items = [
    _NavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavBarItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
    _NavBarItem(
      icon: Icons.palette_outlined,
      activeIcon: Icons.palette_rounded,
      label: 'Themes',
    ),
    _NavBarItem(
      icon: Icons.tune_rounded,
      activeIcon: Icons.tune_rounded,
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _rippleController.forward().then((_) => _rippleController.reverse());
      
      // Handle navigation based on index
      switch (index) {
        case 0:
          // Navigate to home
          break;
        case 1:
          // Navigate to profile
          Navigator.push(
            context,
            PremiumAnimations.premiumPageRoute(const ProfilePage()),
          );
          break;
        case 2:
          // Navigate to themes
          Navigator.push(
            context,
            PremiumAnimations.modalPageRoute(const ThemesPage()),
          );
          break;
        case 3:
          // Navigate to settings
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - _animationController.value)),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 70,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 1.5,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ]
                    : [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.6),
                      ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ]
                    : [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.4),
                      ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _items.length,
                    (index) => _EnhancedNavBarButton(
                      item: _items[index],
                      isSelected: _selectedIndex == index,
                      onTap: () => _onItemTapped(index),
                      theme: theme,
                      animationController: _rippleController,
                      index: index,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().slideY(
      begin: 1.0,
      end: 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
    ).fadeIn(
      duration: const Duration(milliseconds: 400),
    );
  }
}

class _EnhancedNavBarButton extends StatefulWidget {
  final _NavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final AnimationController animationController;
  final int index;

  const _EnhancedNavBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.animationController,
    required this.index,
  });

  @override
  State<_EnhancedNavBarButton> createState() => _EnhancedNavBarButtonState();
}

class _EnhancedNavBarButtonState extends State<_EnhancedNavBarButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _tapController,
        widget.animationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTapDown: (_) => _tapController.forward(),
              onTapUp: (_) => _tapController.reverse(),
              onTapCancel: () => _tapController.reverse(),
              onTap: () {
                _tapController.reverse();
                widget.onTap();
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: widget.isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.theme.colorScheme.primary,
                            widget.theme.colorScheme.secondary,
                          ],
                        )
                      : null,
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: widget.theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple effect for selected item
                    if (widget.isSelected)
                      AnimatedBuilder(
                        animation: widget.animationController,
                        builder: (context, child) {
                          return Container(
                            width: 52 * (1 + widget.animationController.value * 0.3),
                            height: 52 * (1 + widget.animationController.value * 0.3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: widget.theme.colorScheme.primary.withOpacity(
                                  0.3 * (1 - widget.animationController.value),
                                ),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    
                    // Main content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                          color: widget.isSelected
                              ? Colors.white
                              : isDark
                                  ? Colors.white70
                                  : Colors.black54,
                          size: 22,
                        ).animate(target: widget.isSelected ? 1 : 0)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.1, 1.1),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.elasticOut,
                          ),
                        
                        const SizedBox(height: 2),
                        
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: widget.isSelected ? 10 : 9,
                            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: widget.isSelected
                                ? Colors.white
                                : isDark
                                    ? Colors.white70
                                    : Colors.black54,
                          ),
                          child: Text(
                            widget.item.label,
                          ).animate(target: widget.isSelected ? 1 : 0)
                            .fadeIn(duration: const Duration(milliseconds: 150))
                            .slideY(
                              begin: 0.3,
                              end: 0.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
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
      },
    );
  }
}

class _NavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}