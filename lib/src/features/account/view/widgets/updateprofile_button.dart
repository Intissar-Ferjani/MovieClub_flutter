import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/models/app_user.dart';
import '../../../auth/repository/firestore_repository.dart';

Future<void> showProfileUpdateDialog(
    BuildContext context, AppUser user, WidgetRef ref) async {
  final nameController = TextEditingController(text: user.name);
  final emailController = TextEditingController(text: user.email);

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Update Profile"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final name = nameController.text.trim();
            final email = emailController.text.trim();

            if (name.isNotEmpty && email.isNotEmpty) {
              await ref
                  .read(firestoreRepositoryProvider)
                  .updateUserProfile(user.uid, name, email);

              Navigator.of(context).pop();
            }
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
