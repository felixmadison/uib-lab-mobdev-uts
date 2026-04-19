// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FavoriteChip extends StatelessWidget {
  final String city;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FavoriteChip({
    super.key,
    required this.city,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InputChip(
        label: Text(city, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black.withOpacity(0.3),
        onPressed: onTap,
        onDeleted: onDelete,
        side: BorderSide.none,
        deleteIconColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}