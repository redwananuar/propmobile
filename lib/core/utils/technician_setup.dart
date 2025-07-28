import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class TechnicianSetup {
  static final SupabaseClient _supabase = SupabaseConfig.client;

  // Get all technician IDs from work orders
  static Future<List<String>> getTechnicianIds() async {
    try {
      final response = await _supabase
          .from('work_order')
          .select('technicianId')
          .not('technicianId', 'is', null);
      
      final Set<String> uniqueIds = {};
      for (final item in response as List) {
        uniqueIds.add(item['technicianId'] as String);
      }
      
      return uniqueIds.toList();
    } catch (e) {
      print('Error getting technician IDs: $e');
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
    String? technicianId,
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
   - Use these technician IDs from your data:
     * dadff537-b7fb-4996-8eda-b9c402aa8196
     * 6b0d7ce1-80fe-4c57-a6d4-eb17d21defa1
     * 052d37ee-7ecf-41f8-96e0-2b81baf2b470

2. ALTERNATIVE: Update work_order table
   - Replace technicianId with actual auth user IDs
   - Or create a mapping table

3. TEST LOGIN:
   - Use the email/password you created
   - The app will automatically check if user is a technician

=== END SETUP INSTRUCTIONS ===
    ''');
  }
} 