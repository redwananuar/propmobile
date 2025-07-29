import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    await _fadeController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF3B82F6),
              const Color(0xFF1D4ED8),
              const Color(0xFF1E40AF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _logoAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.build_outlined,
                          size: 60,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'PropManager',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Technician Portal',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '© 2024 PropManager. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
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
} 