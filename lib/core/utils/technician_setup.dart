import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class TechnicianSetup {
  static final SupabaseClient _supabase = SupabaseConfig.client;

  // Get all technician emails from work orders
  static Future<List<String>> getTechnicianEmails() async {
    try {
      final response = await _supabase
          .from('work_order')
          .select('technicianEmail')
          .not('technicianEmail', 'is', null);
      
      final Set<String> uniqueEmails = {};
      for (final item in response as List) {
        uniqueEmails.add(item['technicianEmail'] as String);
      }
      
      return uniqueEmails.toList();
    } catch (e) {
      print('Error getting technician emails: $e');
      return [];
    }
  }

  // Get all users from Supabase Auth
  static Future<List<Map<String, dynamic>>> getAuthUsers() async {
    try {
      // Note: This requires admin privileges
      final response = await _supabase.auth.admin.listUsers();
      return response.map((user) => {
        'id': user.id,
        'email': user.email,
        'created_at': user.createdAt,
      }).toList();
    } catch (e) {
      print('Error getting auth users: $e');
      return [];
    }
  }

  // Create a technician user in Auth
  static Future<bool> createTechnicianUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
        ),
      );
      
      print('Created user: ${response.user?.id}');
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Print technician setup instructions
  static void printSetupInstructions() {
    print('''
=== TECHNICIAN AUTHENTICATION SETUP ===

1. MANUAL SETUP (Recommended):
   - Go to your Supabase Dashboard
   - Navigate to Authentication → Users
   - Create users for each technician
   - Use these technician emails from your data:
     * technician1@example.com
     * technician2@example.com
     * technician3@example.com

2. ALTERNATIVE: Update work_order table
   - Replace technicianEmail with actual auth user emails
   - Or create a mapping table

3. TEST LOGIN:
   - Use the email/password you created
   - The app will automatically check if user is a technician

=== END SETUP INSTRUCTIONS ===
    ''');
  }
} 