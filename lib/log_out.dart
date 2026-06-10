import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // Add this package to pubspec.yaml

Future<void> logout(BuildContext context) async {
  // Clear user session/data
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Navigate to login page using GoRouter
  if (context.mounted) {
    context.go('/login'); // Replace '/' with your login route path
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            logout(context);
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Color.fromRGBO(216, 184, 0, 1)),
          ),
        ),
      ],
    ),
  );
}
