import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo: scale + rotate
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoController.forward();

    // Slide app name
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Fade tagline
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(seconds: 1), () {
      _fadeController.forward();
    });

    // Navigate next
    Future.delayed(const Duration(seconds: 4), _navigateNext);
  }

  void _navigateNext() {
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1A237E),
              Color(0xFFD500F9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo: scale + rotate
              ScaleTransition(
                scale: _scaleAnimation,
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    Icons.movie_creation_rounded,
                    size: 120,
                    color: Colors.amberAccent, // glowing accent
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App Name: shimmer + slide
              SlideTransition(
                position: _slideAnimation,
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.yellowAccent,
                  period: const Duration(seconds: 2),
                  child: Text(
                    "Movie Rent",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tagline: fade
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Rent your favorites instantly",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}