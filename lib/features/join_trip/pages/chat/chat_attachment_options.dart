import 'package:flutter/material.dart';

class ChatAttachmentOptions extends StatelessWidget {
  const ChatAttachmentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                icon: Icons.photo,
                label: 'Photo',
                color: Colors.pink,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildAttachmentOption(
                icon: Icons.videocam,
                label: 'Video',
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildAttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'File',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildAttachmentOption(
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}