import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/work_order.dart';
import 'contacts_service.dart';

class WorkOrdersService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  final ContactsService _contactsService = ContactsService();

  // Get work orders for a technician by email (only open and in-progress)
  Future<List<WorkOrder>> getWorkOrdersForTechnicianByEmail(String email) async {
    try {
      final contactId = await _contactsService.getTechnicianContactId(email);
      if (contactId == null) {
        throw Exception('Technician not found');
      }

      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianId', contactId)
          .inFilter('status', ['open', 'in-progress']) // Only open and in-progress jobs
          .order('createdAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch work orders: $e');
    }
  }

  Future<List<WorkOrder>> getWorkOrdersForTechnician(String technicianId) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianId', technicianId)
          .order('createdAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch work orders: $e');
    }
  }

  // Get completed jobs for technician
  Future<List<WorkOrder>> getCompletedJobsForTechnician(String technicianId) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianId', technicianId)
          .eq('status', 'completed')
          .order('resolvedAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch completed jobs: $e');
    }
  }

  // Get completed jobs by email
  Future<List<WorkOrder>> getCompletedJobsByEmail(String email) async {
    try {
      final contactId = await _contactsService.getTechnicianContactId(email);
      if (contactId == null) {
        throw Exception('Technician not found');
      }
      return await getCompletedJobsForTechnician(contactId);
    } catch (e) {
      throw Exception('Failed to fetch completed jobs: $e');
    }
  }

  // Get total completed jobs count
  Future<int> getCompletedJobsCount(String technicianId) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianId', technicianId)
          .eq('status', 'completed');

      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to fetch completed jobs count: $e');
    }
  }

  // Get total completed jobs count by email
  Future<int> getCompletedJobsCountByEmail(String email) async {
    try {
      final contactId = await _contactsService.getTechnicianContactId(email);
      if (contactId == null) {
        throw Exception('Technician not found');
      }
      return await getCompletedJobsCount(contactId);
    } catch (e) {
      throw Exception('Failed to fetch completed jobs count: $e');
    }
  }

  Future<WorkOrder> getWorkOrderById(String workOrderId) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('id', workOrderId)
          .single();

      return WorkOrder.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch work order: $e');
    }
  }

  Future<WorkOrder> updateWorkOrder({
    required String workOrderId,
    required WorkOrderStatus status,
    String? comment,
    String? photoUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.databaseValue,
      };
      
      if (comment != null) {
        updateData['comment'] = comment;
      }
      
      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }
      
      if (status == WorkOrderStatus.completed) {
        final now = DateTime.now();
        updateData['resolvedAt'] = now.toIso8601String();
        print('Setting resolvedAt: ${now.toIso8601String()}'); // Debug
      }

      final response = await _supabase
          .from('work_order')
          .update(updateData)
          .eq('id', workOrderId)
          .select()
          .single();

      return WorkOrder.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update work order: $e');
    }
  }

  Future<List<WorkOrder>> getWorkOrdersByStatus(
    String technicianId,
    WorkOrderStatus status,
  ) async {
    try {
      final response = await _supabase
          .from('work_order')
          .select()
          .eq('technicianId', technicianId)
          .eq('status', status.databaseValue)
          .order('createdAt', ascending: false);

      return (response as List)
          .map((json) => WorkOrder.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch work orders by status: $e');
    }
  }
} 