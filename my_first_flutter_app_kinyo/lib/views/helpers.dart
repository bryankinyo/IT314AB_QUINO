import 'package:flutter/material.dart';

// mo-show ug gamay nga message sa ubos sa screen
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// confirm dialog para sa delete/drop. mo-return ug true kung gi-click ang Yes
Future<bool> confirmDialog(
  BuildContext context,
  String title,
  String message,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

// VALIDATORS (gamiton sa forms)

// dili pwede empty
String? validateRequired(String? value, String label) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required';
  }
  return null;
}

// Email: kinahanglan naay @ ug dot
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email Address is required';
  }
  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailPattern.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }
  return null;
}

// Year Level: dapat 1 to 4 ra ang value
String? validateYear(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Year Level is required';
  }
  final year = int.tryParse(value.trim());
  if (year == null || year < 1 || year > 4) {
    return 'Year Level must be from 1 to 4';
  }
  return null;
}

// Time: HH:MM (24-hour) pananglitan 08:30 or 13:00
String? validateTime(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Time is required';
  }
  final timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
  if (!timePattern.hasMatch(value.trim())) {
    return 'Use HH:MM (24-hour), e.g. 08:30';
  }
  return null;
}

// Number: dapat positive nga whole number
String? validatePositiveNumber(String? value, String label) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required';
  }
  final number = int.tryParse(value.trim());
  if (number == null || number < 1) {
    return '$label must be a number greater than 0';
  }
  return null;
}

// Name: dili pwede empty ug dapat labing menos 2 ka letra
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Full Name is required';
  }
  if (value.trim().length < 2) {
    return 'Full Name must be at least 2 characters';
  }
  return null;
}

// unang letra sa name para sa avatar
String initialOf(String name) {
  return name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}
