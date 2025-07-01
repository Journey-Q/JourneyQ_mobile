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

  const ChatAppBar({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userImage,
    required this.description,
    required this.members,
    required this.isCreator,
    required this.createdDate,
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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userImage),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${members.length} members • Online',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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