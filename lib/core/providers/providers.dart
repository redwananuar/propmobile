import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/work_orders_service.dart';
import '../services/contacts_service.dart';
import '../services/profiles_service.dart';
import '../models/work_order.dart';
import '../models/contact.dart';

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

// Profiles Service Provider
final profilesServiceProvider = Provider<ProfilesService>((ref) {
  return ProfilesService();
});

// Avatar URL Provider (by email)
final avatarUrlByEmailProvider = FutureProvider.family<String?, String>((ref, email) async {
  final profilesService = ref.watch(profilesServiceProvider);
  return await profilesService.getAvatarUrlByEmail(email);
});

// Technician Profile Provider (by email)
final technicianProfileByEmailProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, email) async {
  final profilesService = ref.watch(profilesServiceProvider);
  return await profilesService.getTechnicianByEmail(email);
});

// Technician Name Provider (by email)
final technicianNameByEmailProvider = FutureProvider.family<String?, String>((ref, email) async {
  final profilesService = ref.watch(profilesServiceProvider);
  return await profilesService.getTechnicianNameByEmail(email);
});

// Technicians List Provider
final techniciansProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final profilesService = ref.watch(profilesServiceProvider);
  return await profilesService.getTechnicians();
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

// Current User Technician Email Provider
final currentUserTechnicianEmailProvider = FutureProvider((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUserTechnicianEmail();
});

// Work Orders for Current Technician Provider (by email)
final workOrdersByEmailProvider = FutureProvider.family<List<WorkOrder>, String>((ref, email) async {
  final workOrdersService = ref.read(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrdersForTechnicianByEmail(email);
});

// Active work orders (open and in-progress only)
final activeWorkOrdersByEmailProvider = FutureProvider.family<List<WorkOrder>, String>((ref, email) async {
  final workOrdersService = ref.read(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrdersForTechnicianByEmail(email);
});

// Completed Jobs for Current Technician Provider (by email)
final completedJobsByEmailProvider = FutureProvider.family<List<WorkOrder>, String>((ref, email) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getCompletedJobsByEmail(email);
});

// Completed Jobs Count for Current Technician Provider (by email)
final completedJobsCountProvider = FutureProvider.family<int, String>((ref, email) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getCompletedJobsCountByEmail(email);
});

// Contact by ID Provider
final contactByIdProvider = FutureProvider.family<Contact?, String>((ref, contactId) async {
  final contactsService = ref.watch(contactsServiceProvider);
  return await contactsService.getContactById(contactId);
});

// Work Order by ID Provider
final workOrderByIdProvider = FutureProvider.family<WorkOrder?, String>((ref, workOrderId) async {
  final workOrdersService = ref.watch(workOrdersServiceProvider);
  return await workOrdersService.getWorkOrderById(workOrderId);
}); 