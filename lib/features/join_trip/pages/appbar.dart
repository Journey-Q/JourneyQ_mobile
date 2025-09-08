import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/create_trip_form.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTripCreated;

  const CustomAppBar({super.key, this.onTripCreated});

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
              onTap: () => _handleCreateTrip(context),
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

  void _handleCreateTrip(BuildContext context) async {
    try {
      // FIXED: Properly handle navigation result with error handling
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateTripForm(),
          fullscreenDialog: true,
        ),
      );

      // FIXED: Only trigger refresh if result is explicitly true and callback exists
      if (result == true) {
        print('✅ Trip created successfully, triggering refresh...');
        if (onTripCreated != null) {
          // Add small delay to ensure state is properly updated
          await Future.delayed(const Duration(milliseconds: 200));
          onTripCreated!();
        }
      }
    } catch (e) {
      // FIXED: Handle any navigation errors gracefully
      print('Navigation error: $e');
      // Optionally show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigation error occurred'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}