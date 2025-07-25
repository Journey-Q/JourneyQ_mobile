import 'package:flutter/material.dart';
import 'package:journeyq/app/themes/theme.dart';

class TripTabBar extends StatelessWidget {
  final TabController tabController;

  const TripTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildTabButton(
            context: context,
            index: 0,
            title: 'Trip Groups',
            isSelected: tabController.index == 0,
          ),
          const SizedBox(width: 6),
          _buildTabButton(
            context: context,
            index: 1,
            title: 'Join Request',
            isSelected: tabController.index == 1,
          ),
          const SizedBox(width: 6),
          _buildTabButton(
            context: context,
            index: 2,
            title: 'Created Trips',
            isSelected: tabController.index == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required int index,
    required String title,
    required bool isSelected,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              tabController.animateTo(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.blue[700] 
                      : const Color(0xFF757575),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}