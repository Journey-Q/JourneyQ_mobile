import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class SimpleSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final String? placeholder;

  const SimpleSearchBar({
    Key? key,
    required this.onSearchTap,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                placeholder ?? 'Search...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}