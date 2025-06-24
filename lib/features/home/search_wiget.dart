import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search travellers, destinations, trips...',
    this.onTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.35), // Slightly increased from 0.1 to 0.15
            spreadRadius: 4, // Slightly increased from 3 to 4
            blurRadius: 10, // Slightly increased from 8 to 10
            offset: const Offset(0, 3), // Slightly increased from (0, 2) to (0, 3)
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}