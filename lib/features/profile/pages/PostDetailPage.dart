import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

class PostDetailPage extends StatefulWidget {
  final String imagePath;
  final Map<String, dynamic> userData;

  const PostDetailPage({
    super.key,
    required this.imagePath,
    required this.userData,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isLiked = false;
  bool isSaved = false;
  int likeCount = 42;
  final TextEditingController _commentController = TextEditingController();

  // Mock comments data
  List<Map<String, dynamic>> comments = [
    {
      'username': 'travel_buddy',
      'comment': 'Amazing shot! 📸',
      'time': '2h',
      'likes': 5,
      'isLiked': false,
    },
    {
      'username': 'wanderlust_soul',
      'comment': 'Where is this place? I need to add it to my bucket list! 🌟',
      'time': '4h',
      'likes': 12,
      'isLiked': false,
    },
    {
      'username': 'adventure_seeker',
      'comment': 'The colors in this photo are incredible! 🎨',
      'time': '6h',
      'likes': 8,
      'isLiked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userData['username'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showPostOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Image
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(widget.imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Post Actions
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Like, Comment, Share, Save buttons
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_outline,
                                color: isLiked ? Colors.red : Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => _focusCommentField(),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _sharePost,
                              child: const Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _toggleSave,
                              child: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Like count
                        Text(
                          '$likeCount likes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Caption
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.userData['username'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const TextSpan(
                                text: ' Exploring this beautiful destination! The sunset here was absolutely magical 🌅 #travel #sunset #adventure',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // View all comments
                        if (comments.isNotEmpty)
                          GestureDetector(
                            onTap: () {}, // Already on detail page
                            child: Text(
                              'View all ${comments.length} comments',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),

                        // Comments
                        ...comments.map((comment) => _buildComment(comment)),

                        const SizedBox(height: 8),

                        // Post time
                        const Text(
                          '2 hours ago',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Comment input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildComment(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: comment['username'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: ' ${comment['comment']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      comment['time'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    if (comment['likes'] > 0) ...[
                      const SizedBox(width: 16),
                      Text(
                        '${comment['likes']} likes',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {}, // Reply functionality
                      child: const Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleCommentLike(comment),
            child: Icon(
              comment['isLiked'] ? Icons.favorite : Icons.favorite_outline,
              color: comment['isLiked'] ? Colors.red : Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[800],
            backgroundImage: widget.userData['profileImage'] != null
                ? FileImage(File(widget.userData['profileImage']))
                : null,
            child: widget.userData['profileImage'] == null
                ? const Icon(Icons.person, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: _postComment,
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? 'Post saved' : 'Post removed from saved'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _sharePost() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share post functionality')),
    );
  }

  void _focusCommentField() {
    // Focus on comment input field
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'username': widget.userData['username'],
          'comment': _commentController.text,
          'time': 'now',
          'likes': 0,
          'isLiked': false,
        });
      });
      _commentController.clear();
    }
  }

  void _toggleCommentLike(Map<String, dynamic> comment) {
    setState(() {
      comment['isLiked'] = !comment['isLiked'];
      comment['likes'] += comment['isLiked'] ? 1 : -1;
    });
  }

  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.link, color: Colors.white),
                title: const Text('Copy link', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Edit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Implement edit functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Post?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}