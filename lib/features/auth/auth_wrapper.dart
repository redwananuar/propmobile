import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_screen.dart';
import 'login_screen.dart';
import '../../core/providers/providers.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return currentUser.when(
      data: (user) {
        if (user != null) {
          // User is logged in, show dashboard
          return const DashboardScreen();
        } else {
          // User is not logged in, show login screen
          return const LoginScreen();
        }
      },
      loading: () {
        // Show loading screen while checking auth state
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
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Checking authentication...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        // Show error screen, then redirect to login
        print('Auth wrapper error: $error');
        return const LoginScreen();
      },
    );
  }
} 