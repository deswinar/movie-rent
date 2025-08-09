import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/data/models/app_user_model.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/profile/controllers/user_controller.dart';

class ProfileDetailView extends StatelessWidget {
  final Rx<AppUser?> userRx;

  const ProfileDetailView({
    super.key,
    required this.userRx,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final user = userRx.value;
      if (user == null) return const CircularProgressIndicator();

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name with edit icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name?.isNotEmpty == true
                        ? user.name!
                        : "No name provided",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => _showEditNameDialog(context, user),
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: "Edit Name",
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Email
              Text(
                user.email,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.hintColor),
              ),

              const SizedBox(height: 32),

              // Info Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
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

              // Logout
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showEditNameDialog(BuildContext context, AppUser user) {
    final nameController = TextEditingController(text: user.name ?? '');

    Get.defaultDialog(
      title: "Edit Name",
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: "Name"),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () async {
        final newName = nameController.text.trim();
        if (newName.isEmpty) return;

        final userProfileController = Get.find<UserController>();
        await userProfileController.updateProfile(uid: user.uid, name: newName);

        // Update Rx value to trigger UI rebuild
        userRx.value = user.copyWith(name: newName);

        Get.back();
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
