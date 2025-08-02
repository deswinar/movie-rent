import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/data/models/app_user_model.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';

class ProfileDetailView extends StatelessWidget {
  final AppUser user;

  const ProfileDetailView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
      
            // Name
            Text(
              user.name?.isNotEmpty == true ? user.name! : "No name provided",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
      
            const SizedBox(height: 8),
      
            // Email
            Text(
              user.email,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
      
            const SizedBox(height: 32),
      
            // Profile Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text("Email"),
                      subtitle: Text(user.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified_user),
                      title: const Text("Role"),
                      subtitle: Text(user.role ?? "User"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text("Joined"),
                      subtitle: Text(
                        user.createdAt != null
                            ? _formatDate(user.createdAt!)
                            : "Unknown",
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            const SizedBox(height: 24),
      
            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.find<AuthController>().logout(),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format as "August 2, 2025"
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}
