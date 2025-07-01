import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final bool isTyping;
  final Function(String) onTextChanged;
  final VoidCallback onSendMessage;
  final VoidCallback onShowAttachmentOptions;

  const ChatInputBar({
    super.key,
    required this.messageController,
    required this.isTyping,
    required this.onTextChanged,
    required this.onSendMessage,
    required this.onShowAttachmentOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
                      onPressed: () {
                        // Emoji picker functionality
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: onTextChanged,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: onShowAttachmentOptions,
                    ),
                    if (!isTyping)
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        onPressed: () {
                          // Camera functionality
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: isTyping ? onSendMessage : () {
                  // Voice message functionality
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}