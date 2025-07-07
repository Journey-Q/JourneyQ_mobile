import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> postData;
  final Map<String, dynamic> userData;
  final int postIndex;

  const PostDetailPage({
    super.key,
    required this.postData,
    required this.userData,
    required this.postIndex,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late bool isLiked;
  late bool isSaved;
  late int likeCount;
  final TextEditingController _commentController = TextEditingController();

  // Generate mock comments based on post data
  late List<Map<String, dynamic>> comments;

  @override
  void initState() {
    super.initState();
    // Initialize with post-specific data
    isLiked = widget.postData['isLiked'] ?? false;
    isSaved = widget.postData['isSaved'] ?? false;
    likeCount = widget.postData['likes'] ?? 0;

    // Generate comments based on the post
    comments = _generateCommentsForPost();
  }

  List<Map<String, dynamic>> _generateCommentsForPost() {
    // Different comment sets based on post index for variety
    final commentSets = [
      [
        {
          'username': 'mountain_lover',
          'comment': 'Absolutely stunning view! 🏔️',
          'time': '2h',
          'likes': 15,
          'isLiked': false,
        },
        {
          'username': 'adventure_seeker',
          'comment': 'This is on my bucket list now!',
          'time': '4h',
          'likes': 8,
          'isLiked': true,
        },
        {
          'username': 'nature_enthusiast',
          'comment': 'The peaks look incredible!',
          'time': '6h',
          'likes': 3,
          'isLiked': false,
        },
      ],
      [
        {
          'username': 'nature_photographer',
          'comment': 'The lighting is perfect! 📸',
          'time': '1h',
          'likes': 12,
          'isLiked': false,
        },
        {
          'username': 'hiking_enthusiast',
          'comment': 'Which trail did you take?',
          'time': '3h',
          'likes': 5,
          'isLiked': false,
        },
      ],
      [
        {
          'username': 'travel_buddy',
          'comment': 'Golden hour magic! ✨',
          'time': '30m',
          'likes': 22,
          'isLiked': true,
        },
        {
          'username': 'sunset_chaser',
          'comment': 'I could watch this forever',
          'time': '2h',
          'likes': 18,
          'isLiked': false,
        },
        {
          'username': 'wanderlust_soul',
          'comment': 'Adding this to my travel plans!',
          'time': '5h',
          'likes': 7,
          'isLiked': false,
        },
      ],
      [
        {
          'username': 'outdoor_explorer',
          'comment': 'Amazing capture! 🎒',
          'time': '3h',
          'likes': 9,
          'isLiked': false,
        },
        {
          'username': 'camping_life',
          'comment': 'Perfect spot for camping!',
          'time': '5h',
          'likes': 6,
          'isLiked': true,
        },
      ],
      [
        {
          'username': 'ocean_lover',
          'comment': 'The colors are mesmerizing! 🌊',
          'time': '1h',
          'likes': 25,
          'isLiked': false,
        },
        {
          'username': 'beach_walker',
          'comment': 'I can almost hear the waves',
          'time': '4h',
          'likes': 11,
          'isLiked': true,
        },
        {
          'username': 'coastal_dreamer',
          'comment': 'Paradise found! 🏝️',
          'time': '6h',
          'likes': 14,
          'isLiked': false,
        },
      ],
      [
        {
          'username': 'starry_nights',
          'comment': 'Perfect for stargazing! ⭐',
          'time': '2h',
          'likes': 8,
          'isLiked': false,
        },
        {
          'username': 'desert_wanderer',
          'comment': 'The silence must be incredible',
          'time': '5h',
          'likes': 4,
          'isLiked': true,
        },
      ],
      [
        {
          'username': 'greek_islands_fan',
          'comment': 'Santorini vibes! 🇬🇷',
          'time': '45m',
          'likes': 31,
          'isLiked': true,
        },
        {
          'username': 'sunset_photographer',
          'comment': 'The composition is perfect!',
          'time': '3h',
          'likes': 19,
          'isLiked': false,
        },
        {
          'username': 'mediterranean_lover',
          'comment': 'Planning my next trip here!',
          'time': '7h',
          'likes': 12,
          'isLiked': false,
        },
      ],
      [
        {
          'username': 'ice_explorer',
          'comment': 'Iceland is magical! ❄️',
          'time': '4h',
          'likes': 16,
          'isLiked': false,
        },
        {
          'username': 'northern_lights_hunter',
          'comment': 'Did you see the aurora?',
          'time': '8h',
          'likes': 7,
          'isLiked': true,
        },
      ],
      [
        {
          'username': 'road_tripper',
          'comment': 'Classic American adventure! 🚗',
          'time': '2h',
          'likes': 13,
          'isLiked': false,
        },
        {
          'username': 'route66_traveler',
          'comment': 'The historic highway!',
          'time': '6h',
          'likes': 9,
          'isLiked': false,
        },
        {
          'username': 'vintage_car_lover',
          'comment': 'What car did you drive?',
          'time': '1d',
          'likes': 5,
          'isLiked': true,
        },
      ],
    ];

    // Select comment set based on post index
    final selectedComments = commentSets[widget.postIndex % commentSets.length];

    // Return only as many comments as specified in postData
    final commentCount = widget.postData['comments'] ?? 0;
    return selectedComments.take(commentCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              widget.userData['username'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.userData['isVerified'] == true)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
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
                          image: widget.postData['imageUrl'].startsWith('http')
                              ? NetworkImage(widget.postData['imageUrl'])
                              : FileImage(File(widget.postData['imageUrl'])) as ImageProvider,
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
                                color: isLiked ? Colors.red : Colors.black,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => _focusCommentField(),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: _sharePost,
                              child: const Icon(
                                Icons.send_outlined,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _toggleSave,
                              child: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                                color: Colors.black,
                                size: 28,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Like count
                        if (likeCount > 0)
                          Text(
                            likeCount == 1 ? '1 like' : '$likeCount likes',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Caption with location
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.userData['username'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.postData['caption'] ?? 'No caption'}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Location
                        if (widget.postData['location'] != null && widget.postData['location'] != 'Unknown')
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.postData['location'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
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
                              comments.length == 1
                                  ? 'View 1 comment'
                                  : 'View all ${comments.length} comments',
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
                        Text(
                          widget.postData['timestamp'] ?? 'Unknown time',
                          style: const TextStyle(
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
      padding: const EdgeInsets.only(bottom: 12),
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
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: ' ${comment['comment']}',
                        style: const TextStyle(
                          color: Colors.black,
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
                        comment['likes'] == 1 ? '1 like' : '${comment['likes']} likes',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // Reply functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Replying to ${comment['username']}'),
                            backgroundColor: Colors.grey[800],
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
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
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.userData['profileImage'] != null
                ? (widget.userData['profileImage'].startsWith('http')
                ? NetworkImage(widget.userData['profileImage'])
                : FileImage(File(widget.userData['profileImage'])) as ImageProvider)
                : null,
            child: widget.userData['profileImage'] == null
                ? const Icon(Icons.person, color: Colors.grey, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          GestureDetector(
            onTap: _postComment,
            child: Text(
              'Post',
              style: TextStyle(
                color: _commentController.text.trim().isNotEmpty ? Colors.blue : Colors.grey,
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
      // Update the original post data
      widget.postData['isLiked'] = isLiked;
      widget.postData['likes'] = likeCount;
    });

    // Optional: Show feedback
    if (isLiked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('❤️ Liked!'),
          backgroundColor: Colors.grey[800],
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
      // Update the original post data
      widget.postData['isSaved'] = isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? 'Post saved' : 'Post removed from saved'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  void _sharePost() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.postData['location'] ?? 'post'}...'),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  void _focusCommentField() {
    // Focus on comment input field
    FocusScope.of(context).requestFocus();
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'username': widget.userData['username'],
          'comment': _commentController.text.trim(),
          'time': 'now',
          'likes': 0,
          'isLiked': false,
        });
        // Update comment count in original post data
        widget.postData['comments'] = comments.length;
      });
      _commentController.clear();

      // Hide keyboard
      FocusScope.of(context).unfocus();
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
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.link, color: Colors.black),
                title: const Text('Copy link', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Link copied to clipboard'),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.black),
                title: const Text('Edit', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _editPost();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.black),
                title: const Text('Post info', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _showPostInfo();
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

  void _editPost() {
    // Implement edit post functionality
    showDialog(
      context: context,
      builder: (context) {
        final captionController = TextEditingController(text: widget.postData['caption']);
        final locationController = TextEditingController(text: widget.postData['location']);

        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Edit Post',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: captionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Caption',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ],
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
                setState(() {
                  widget.postData['caption'] = captionController.text;
                  widget.postData['location'] = locationController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Post updated'),
                    backgroundColor: Colors.grey[800],
                  ),
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPostInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Post Information',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Location:', widget.postData['location'] ?? 'Unknown'),
            _buildInfoRow('Posted:', widget.postData['timestamp'] ?? 'Unknown'),
            _buildInfoRow('Likes:', likeCount.toString()),
            _buildInfoRow('Comments:', comments.length.toString()),
            _buildInfoRow('Saved:', isSaved ? 'Yes' : 'No'),
            _buildInfoRow('Image URL:', widget.postData['imageUrl'].substring(0, 30) + '...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
                SnackBar(
                  content: const Text('Post deleted'),
                  backgroundColor: Colors.grey[800],
                ),
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}