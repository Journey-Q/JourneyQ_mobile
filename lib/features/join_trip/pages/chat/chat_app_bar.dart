import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/group_details_page.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String groupId;
  final String groupName;
  final String userImage;
  final String description;
  final List<Map<String, dynamic>> members;
  final bool isCreator;
  final String createdDate;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onBudgetPressed;

  const ChatAppBar({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userImage,
    required this.description,
    required this.members,
    required this.isCreator,
    required this.createdDate,
    this.onGalleryPressed,
    this.onBudgetPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: () => _navigateToGroupDetails(context),
        child: Row(
          children: [
            Stack(
              children: [
                // Profile image as rounded square
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Rounded square
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      userImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 20, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                groupName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Budget Icon
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12), // Rounded rectangle
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.green[700],
                size: 20,
              ),
            ),
            onPressed: onBudgetPressed,
            tooltip: 'Group Budget',
          ),
        ),
        
        // Gallery Icon
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0088cc).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12), // Rounded rectangle
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0088cc).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.photo_library,
                color: Color(0xFF0088cc),
                size: 20,
              ),
            ),
            onPressed: onGalleryPressed,
            tooltip: 'Trip Gallery',
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _navigateToGroupDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailsPage(
          groupId: groupId,
          groupName: groupName,
          groupImage: userImage,
          description: description,
          members: members,
          isCreator: isCreator,
          createdDate: createdDate,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}