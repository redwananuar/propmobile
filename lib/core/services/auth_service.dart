import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'profiles_service.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  final ProfilesService _profilesService = ProfilesService();

  User? get currentUser => _supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get currentUserId => currentUser?.id;
  String? get currentUserEmail => currentUser?.email;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // First authenticate with Supabase Auth
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Then validate if the user is a technician
      final isTechnician = await _profilesService.isTechnician(email);
      if (!isTechnician) {
        // Sign out if not a technician
        await _supabase.auth.signOut();
        throw Exception('Access denied. Only technicians can use this app.');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // First check if the email exists in profiles as a technician
      final isTechnician = await _profilesService.isTechnician(email);
      if (!isTechnician) {
        throw Exception('Access denied. Only existing technicians can register.');
      }

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Validate that the email belongs to a technician
      final isTechnician = await _profilesService.isTechnician(email);
      if (!isTechnician) {
        throw Exception('Access denied. Only technicians can reset passwords.');
      }

      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Check if current user is a technician
  Future<bool> isCurrentUserTechnician() async {
    try {
      final email = currentUserEmail;
      if (email == null) return false;
      
      return await _profilesService.isTechnician(email);
    } catch (e) {
      return false;
    }
  }

  // Get current user's technician email
  Future<String?> getCurrentUserTechnicianEmail() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      
      return user.email;
    } catch (e) {
      return null;
    }
  }

  // Update password
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
} 