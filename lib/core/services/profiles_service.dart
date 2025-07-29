import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class ProfilesService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Get profile by email
  Future<Map<String, dynamic>?> getProfileByEmail(String email) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Get avatar URL by email
  Future<String?> getAvatarUrlByEmail(String email) async {
    try {
      final profile = await getProfileByEmail(email);
      return profile?['avatar_url'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Get technician profile by email
  Future<Map<String, dynamic>?> getTechnicianByEmail(String email) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .eq('type', 'technician')
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Get all technicians
  Future<List<Map<String, dynamic>>> getTechnicians() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('type', 'technician')
          .order('name', ascending: true);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch technicians: $e');
    }
  }

  // Validate if a user is a technician
  Future<bool> isTechnician(String email) async {
    try {
      final technician = await getTechnicianByEmail(email);
      return technician != null;
    } catch (e) {
      return false;
    }
  }

  // Get technician name by email
  Future<String?> getTechnicianNameByEmail(String email) async {
    try {
      final technician = await getTechnicianByEmail(email);
      return technician?['name'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Update avatar URL for a profile
  Future<void> updateAvatarUrl(String email, String avatarUrl) async {
    try {
      // Check if profile exists
      final existingProfile = await getProfileByEmail(email);
      
      if (existingProfile != null) {
        // Update existing profile
        await _supabase
            .from('profiles')
            .update({'avatar_url': avatarUrl})
            .eq('email', email);
      } else {
        // Create new profile
        await _supabase
            .from('profiles')
            .insert({
              'email': email,
              'avatar_url': avatarUrl,
            });
      }
    } catch (e) {
      throw Exception('Failed to update avatar URL: $e');
    }
  }

  // Create or update profile
  Future<void> upsertProfile({
    required String email,
    required String type,
    String? name,
    String? avatarUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final data = {
        'email': email,
        'type': type,
        if (name != null) 'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (additionalData != null) ...additionalData,
      };

      await _supabase
          .from('profiles')
          .upsert(data, onConflict: 'email');
    } catch (e) {
      throw Exception('Failed to upsert profile: $e');
    }
  }
} 