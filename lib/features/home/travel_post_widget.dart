import 'package:flutter/material.dart';

class TravelPostWidget extends StatelessWidget {
  final String userName;
  final String location;
  final String userImage;
  final String postImage;
  final VoidCallback? onViewJourney;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMoreOptions;

  const TravelPostWidget({
    super.key,
    required this.userName,
    required this.location,
    required this.userImage,
    required this.postImage,
    this.onViewJourney,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMoreOptions,
                  child: Icon(Icons.more_horiz, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Post Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(postImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onComment,
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onShare,
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onViewJourney,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088cc),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_outlined, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'View Journey',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}