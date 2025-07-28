import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/work_orders_service.dart';
import '../services/contacts_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Work Orders Service Provider
final workOrdersServiceProvider = Provider<WorkOrdersService>((ref) {
  return WorkOrdersService();
});

// Contacts Service Provider
final contactsServiceProvider = Provider<ContactsService>((ref) {
  return ContactsService();
});

// Current User Provider
final currentUserProvider = StreamProvider((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((event) => event.session?.user);
});

// Current User Technician Status Provider
final currentUserTechnicianProvider = FutureProvider((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isCurrentUserTechnician();
});

// Current User Technician ID Provider
final currentUserTechnicianIdProvider = FutureProvider((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUserTechnicianId();
});

// Work Orders for Current Technician Provider (by email)
final workOrdersByEmailProvider = FutureProvider.family<List<dynamic>, String>((ref, email) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrdersForTechnicianByEmail(email);
});

// Completed Jobs for Current Technician Provider (by email)
final completedJobsByEmailProvider = FutureProvider.family<List<dynamic>, String>((ref, email) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getCompletedJobsByEmail(email);
});

// Completed Jobs Count for Current Technician Provider (by email)
final completedJobsCountProvider = FutureProvider.family<int, String>((ref, email) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getCompletedJobsCountByEmail(email);
});

// Work Orders for Current Technician Provider (by contact ID)
final workOrdersProvider = FutureProvider.family<List<dynamic>, String>((ref, technicianId) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrdersForTechnician(technicianId);
});

// Work Order by ID Provider
final workOrderByIdProvider = FutureProvider.family<dynamic, String>((ref, workOrderId) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrderById(workOrderId);
});

// Technicians Provider
final techniciansProvider = FutureProvider<List<dynamic>>((ref) async {
  final contactsService = ref.watch(contactsServiceProvider);
  return await contactsService.getTechnicians();
});

// Contact by ID Provider
final contactByIdProvider = FutureProvider.family<dynamic, String>((ref, contactId) async {
  final contactsService = ref.watch(contactsServiceProvider);
  return await contactsService.getContactById(contactId);
});

// Technician by Email Provider
final technicianByEmailProvider = FutureProvider.family<dynamic, String>((ref, email) async {
  final contactsService = ref.watch(contactsServiceProvider);
  return await contactsService.getTechnicianByEmail(email);
}); 