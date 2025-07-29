import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/work_order.dart';
import 'profiles_service.dart';

class WorkOrdersService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  final ProfilesService _profilesService = ProfilesService();

  // Get work orders for a technician by email (only open and in-progress)
  Future<List<WorkOrder>> getWorkOrdersForTechnicianByEmail(String email) async {
    try {
      // First verify the technician exists in profiles table
      final technician = await _profilesService.getTechnicianByEmail(email);
      if (technician == null) {
        throw Exception('Technician not found in profiles');
      }

      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianEmail', email)
          .inFilter('status', ['open', 'in-progress']) // Only open and in-progress jobs
          .order('createdAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch work orders: $e');
    }
  }

  // Get completed jobs by email
  Future<List<WorkOrder>> getCompletedJobsByEmail(String email) async {
    try {
      // First verify the technician exists in profiles table
      final technician = await _profilesService.getTechnicianByEmail(email);
      if (technician == null) {
        throw Exception('Technician not found in profiles');
      }

      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianEmail', email)
          .eq('status', 'completed')
          .order('resolvedAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch completed jobs: $e');
    }
  }

  // Get total completed jobs count by email
  Future<int> getCompletedJobsCountByEmail(String email) async {
    try {
      // First verify the technician exists in profiles table
      final technician = await _profilesService.getTechnicianByEmail(email);
      if (technician == null) {
        return 0; // Return 0 if technician not found
      }

      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianEmail', email)
          .eq('status', 'completed');

      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to fetch completed jobs count: $e');
    }
  }

  // Get work order by ID
  Future<WorkOrder?> getWorkOrderById(String workOrderId) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('id', workOrderId)
          .single();

      return WorkOrder.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update work order status
  Future<void> updateWorkOrderStatus(String workOrderId, String status) async {
    try {
      await _supabase
          .from('work_order')
          .update({'status': status})
          .eq('id', workOrderId);
    } catch (e) {
      throw Exception('Failed to update work order status: $e');
    }
  }

  // Update work order with photo
  Future<void> updateWorkOrderWithPhoto(String workOrderId, String photoUrl) async {
    try {
      await _supabase
          .from('work_order')
          .update({
            'photoUrl': photoUrl,
            'status': 'completed',
            'resolvedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', workOrderId);
    } catch (e) {
      throw Exception('Failed to update work order with photo: $e');
    }
  }

  // Create new work order
  Future<void> createWorkOrder({
    required String title,
    required String description,
    required String technicianEmail,
    String? propertyUnit,
    String? priority,
    DateTime? scheduledDate,
    String? comment,
  }) async {
    try {
      // First verify the technician exists in profiles table
      final technician = await _profilesService.getTechnicianByEmail(technicianEmail);
      if (technician == null) {
        throw Exception('Technician not found in profiles');
      }

      await _supabase
          .from('work_order')
          .insert({
            'title': title,
            'description': description,
            'technicianEmail': technicianEmail,
            'propertyUnit': propertyUnit,
            'priority': priority,
            'scheduledDate': scheduledDate?.toIso8601String(),
            'comment': comment,
            'status': 'open',
            'createdAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to create work order: $e');
    }
  }
} 