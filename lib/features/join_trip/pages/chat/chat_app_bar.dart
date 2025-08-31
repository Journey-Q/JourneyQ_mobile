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

  String _getLocationBasedImage(String? destination) {
    final dest = destination?.toLowerCase() ?? '';
    
    if (dest.contains('kandy')) {
      return 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800';
    } else if (dest.contains('ella')) {
      return 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=800';
    } else if (dest.contains('sigiriya')) {
      return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800';
    } else if (dest.contains('galle')) {
      return 'https://images.unsplash.com/photo-1539650116574-75c0c6d24e14?w=800';
    } else if (dest.contains('nuwara eliya')) {
      return 'https://images.unsplash.com/photo-1605640957230-d8b5b3c7b1e4?w=800';
    } else if (dest.contains('yala')) {
      return 'https://images.unsplash.com/photo-1539650116574-75c0c6d24e14?w=800';
    } else if (dest.contains('mirissa')) {
      return 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=800&h=600&fit=crop';
    } else {
      return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop';
    }
  }

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
                // Profile image as rounded square - now using location-based image
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
                      _getLocationBasedImage(groupName),
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