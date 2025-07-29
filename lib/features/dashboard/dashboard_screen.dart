import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../core/models/work_order.dart';
import '../../core/models/activity.dart';
import '../../common/widgets/activity_card.dart';
import '../work_orders/work_orders_list_screen.dart';
import '../settings/user_settings_screen.dart';
import 'completed_jobs_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Please log in to view dashboard'),
            ),
          );
        }

        final completedJobsCountAsync = ref.watch(completedJobsCountProvider(user.email!));
        final completedJobsAsync = ref.watch(completedJobsByEmailProvider(user.email!));
        final activeWorkOrdersAsync = ref.watch(activeWorkOrdersByEmailProvider(user.email!));
        final technicianProfileAsync = ref.watch(technicianProfileByEmailProvider(user.email!));
        final avatarUrlAsync = ref.watch(avatarUrlByEmailProvider(user.email!));

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'PropManager',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E293B),
            elevation: 0,
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserSettingsScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  await authService.signOut();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                technicianProfileAsync.when(
                  data: (technician) {
                    final technicianName = technician?['name'] as String? ?? 'Technician';
                    final currentDate = DateTime.now();
                    final dateString = _getFormattedDate(currentDate);
                    
                    return avatarUrlAsync.when(
                      data: (avatarUrl) => Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3B82F6),
                              const Color(0xFF1D4ED8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // User Avatar
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: avatarUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Image.network(
                                        avatarUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 40,
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    technicianName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateString,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      loading: () => Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Error loading profile'),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Error loading profile'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics Section
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                
                completedJobsCountAsync.when(
                  data: (count) => activeWorkOrdersAsync.when(
                    data: (activeWorkOrders) => Column(
                      children: [
                        // First row - Completed Jobs and Active Jobs
                        Row(
                          children: [
                            Expanded(
                              child: _ClickableStatCard(
                                title: 'Completed Jobs',
                                value: count.toString(),
                                icon: Icons.check_circle_outline,
                                color: const Color(0xFF10B981),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CompletedJobsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ClickableStatCard(
                                title: 'Active Jobs',
                                value: activeWorkOrders.length.toString(),
                                icon: Icons.work_outline,
                                color: const Color(0xFFF59E0B),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WorkOrdersListScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Second row - Leaves and Bookings
                        Row(
                          children: [
                            Expanded(
                              child: _ClickableStatCard(
                                title: 'Leaves',
                                value: '0',
                                icon: Icons.event_busy_outlined,
                                color: const Color(0xFFEF4444),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                                ),
                                onTap: () {
                                  // TODO: Navigate to Leaves screen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Leaves feature coming soon!'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ClickableStatCard(
                                title: 'Bookings',
                                value: '0',
                                icon: Icons.calendar_today_outlined,
                                color: const Color(0xFF8B5CF6),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                                ),
                                onTap: () {
                                  // TODO: Navigate to Bookings screen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Bookings feature coming soon!'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    loading: () => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _StatCardSkeleton()),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCardSkeleton()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _StatCardSkeleton()),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCardSkeleton()),
                          ],
                        ),
                      ],
                    ),
                    error: (_, __) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _StatCardSkeleton()),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCardSkeleton()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _StatCardSkeleton()),
                            const SizedBox(width: 16),
                            Expanded(child: _StatCardSkeleton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  loading: () => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _StatCardSkeleton()),
                          const SizedBox(width: 16),
                          Expanded(child: _StatCardSkeleton()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _StatCardSkeleton()),
                          const SizedBox(width: 16),
                          Expanded(child: _StatCardSkeleton()),
                        ],
                      ),
                    ],
                  ),
                  error: (_, __) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Error loading statistics'),
                  ),
                ),
                const SizedBox(height: 32),

                // Recent Activity Section
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                
                completedJobsAsync.when(
                  data: (completedJobs) {
                    if (completedJobs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No recent activity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Activity will appear here as you complete work orders',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Convert completed jobs to activities
                    final activities = completedJobs.take(5).map((workOrder) {
                      return Activity.fromWorkOrderCompleted(
                        id: workOrder.id,
                        workOrderId: workOrder.id,
                        workOrderTitle: workOrder.title,
                        technicianName: technicianProfileAsync.value?['name'] as String? ?? 'Technician',
                        completedAt: workOrder.resolvedAt ?? DateTime.now(),
                        photoUrl: workOrder.photoUrl,
                      );
                    }).toList();

                    return Column(
                      children: activities.map((activity) {
                        return ActivityCard(
                          activity: activity,
                          onTap: () {
                            // TODO: Navigate to work order detail
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing work order: ${activity.description}'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                  loading: () => Column(
                    children: List.generate(3, (index) => const ActivityCardSkeleton()),
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Error loading activities: $error'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    
    return '$dayName, $monthName $day, $year';
  }
}

class _ClickableStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ClickableStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 