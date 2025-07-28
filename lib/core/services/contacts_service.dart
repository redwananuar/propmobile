import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/contact.dart';

class ContactsService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  Future<List<Contact>> getTechnicians() async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('type', 'technician')
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Contact.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch technicians: $e');
    }
  }

  Future<Contact?> getContactById(String contactId) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('id', contactId)
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Contact?> getTechnicianById(String technicianId) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('id', technicianId)
          .eq('type', 'technician')
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get technician by email for authentication
  Future<Contact?> getTechnicianByEmail(String email) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('email', email)
          .eq('type', 'technician')
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      return null;
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

  // Get technician contact ID by email
  Future<String?> getTechnicianContactId(String email) async {
    try {
      final technician = await getTechnicianByEmail(email);
      return technician?.id;
    } catch (e) {
      return null;
    }
  }

  Future<List<Contact>> getContactsByType(ContactType type) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('type', type.databaseValue)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Contact.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch contacts by type: $e');
    }
  }
} 