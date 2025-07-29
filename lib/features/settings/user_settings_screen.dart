import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../core/models/contact.dart';

class UserSettingsScreen extends ConsumerStatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  ConsumerState<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends ConsumerState<UserSettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isChangingPassword = false;
  bool _isUpdatingAvatar = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateAvatar() async {
    setState(() {
      _isUpdatingAvatar = true;
    });

    try {
      // TODO: Implement actual photo upload to Supabase Storage
      // For now, we'll simulate the upload and update the profile record
      await Future.delayed(const Duration(seconds: 2));
      
      // Get the current user
      final currentUser = ref.read(currentUserProvider);
      final user = currentUser.value;
      if (user != null) {
        final profilesService = ref.read(profilesServiceProvider);
        
        // Simulate a photo URL (in real implementation, this would be the uploaded photo URL)
        const avatarUrl = 'https://example.com/avatar.jpg';
        
        // Update the profile's avatar_url in the database
        await profilesService.updateAvatarUrl(user.email!, avatarUrl);
        
        // Invalidate the avatar provider to refresh the UI
        ref.invalidate(avatarUrlByEmailProvider(user.email!));
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update avatar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingAvatar = false;
        });
      }
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isChangingPassword = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.updatePassword(_currentPasswordController.text, _newPasswordController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear the form
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChangingPassword = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Please log in to view settings'),
            ),
          );
        }

        final technicianProfileAsync = ref.watch(technicianProfileByEmailProvider(user.email!));
        final avatarUrlAsync = ref.watch(avatarUrlByEmailProvider(user.email!));

        return Scaffold(
          appBar: AppBar(
            title: const Text('User Settings'),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card
                technicianProfileAsync.when(
                  data: (technician) {
                    final technicianName = technician?['name'] as String? ?? 'Technician';
                    final technicianEmail = user.email ?? '';
                    
                    return avatarUrlAsync.when(
                      data: (avatarUrl) => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.blue[50]!, Colors.blue[100]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Avatar Section
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.blue[200],
                                    backgroundImage: avatarUrl != null 
                                        ? NetworkImage(avatarUrl) 
                                        : null,
                                    child: avatarUrl == null
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.blue[700],
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue[600],
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: _isUpdatingAvatar ? null : _updateAvatar,
                                        icon: _isUpdatingAvatar
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // User Details
                              Text(
                                technicianName,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                technicianEmail,
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Technician',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      loading: () => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      error: (_, __) => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.blue[200],
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'User',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email ?? '',
                                style: TextStyle(
                                  color: Colors.blue[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () => Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  error: (_, __) => Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue[200],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'User',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Change Password Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Colors.orange[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Current Password
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Current Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // New Password
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Confirm New Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isChangingPassword ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isChangingPassword
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Update Password',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Account Information Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Account Information',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        _InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: user.email ?? 'Not available',
                        ),
                        _InfoRow(
                          icon: Icons.access_time,
                          label: 'Last Sign In',
                          value: user.lastSignInAt != null 
                              ? _formatDate(DateTime.parse(user.lastSignInAt!))
                              : 'Not available',
                        ),
                        _InfoRow(
                          icon: Icons.person_add,
                          label: 'Account Created',
                          value: user.createdAt != null 
                              ? _formatDate(DateTime.parse(user.createdAt))
                              : 'Not available',
                        ),
                      ],
                    ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 