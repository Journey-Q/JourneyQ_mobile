import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/create_trip_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCreateTrip;

  const CustomAppBar({super.key, required this.onCreateTrip});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'My Trips',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0088cc).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onCreateTrip,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}