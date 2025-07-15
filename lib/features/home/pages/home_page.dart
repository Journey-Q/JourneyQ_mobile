import 'package:flutter/material.dart';
import 'package:journeyq/shared/components/app_bar.dart';
import 'package:journeyq/features/home/pages/search_wiget.dart';
import 'package:journeyq/features/home/pages/widget.dart';
import 'package:journeyq/features/home/pages/travel_post_widget.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/features/home/data.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Using the imported post_data from data.dart
  late List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List.from(post_data); // Create a mutable copy
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: JourneyQAppBar(
        notificationCount: 3,
        chatCount: 7,
        onNotificationTap: () {
          context.push('/notification');
        },
        onChatTap: () {
          context.push('/chat');
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header Section
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Search Bar
                    SearchBarWidget(
                      onTap: () {
                        context.push('/search');
                      },
                    ),

                    const SizedBox(height: 20),

                    // Explore World Card
                    ExploreWorldCard(
                      onCreateJourney: () {
                        context.push('/planner');
                      },
                    ),

                    const SizedBox(height: 16),
                  ]),
                ),
              ),

              // Posts List
              _buildPostsList(),

              // Bottom padding for navigation bar
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final post = _posts[index];

        // Safely handle data conversion
        List<String> placesVisited = _convertToStringList(
          post['placesVisited'],
        );
        List<String> postImages = _convertToStringList(post['postImages']);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TravelPostWidget(
            postId:
                post['id']?.toString() ?? '1', // Add required postId parameter
            userName: post['userName']?.toString() ?? 'Unknown User',
            location: post['location']?.toString() ?? 'Unknown Location',
            userImage: post['userImage']?.toString() ?? '',
            journeyTitle:
                post['journeyTitle']?.toString() ?? 'Travel Adventure',
            placesVisited: placesVisited,
            postImages: postImages,
            likesCount: _convertToInt(post['likesCount']),
            commentsCount: _convertToInt(post['commentsCount']),
            isLiked: post['isLiked'] ?? false,
            isFollowed: false, // Add default value
            isBookmarked: false, // Add default value
            // Remove onViewJourney - now handled internally by the widget
            onLike: () => _handleLike(post, index),
            onComment: () => _handleComment(post, index),
            onMoreOptions: () => _showMoreOptions(
              context,
              post['userName']?.toString() ?? 'Unknown',
            ),
          ),
        );
      }, childCount: _posts.length),
    );
  }

  // Helper method to safely convert to List<String>
  List<String> _convertToStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return [];
  }

  // Helper method to safely convert to int
  int _convertToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Event handlers

  void _handleLike(Map<String, dynamic> post, int postIndex) {
    setState(() {
      // Toggle like state and update count
      bool isCurrentlyLiked = _posts[postIndex]['isLiked'] ?? false;
      _posts[postIndex]['isLiked'] = !isCurrentlyLiked;

      if (!isCurrentlyLiked) {
        _posts[postIndex]['likesCount'] =
            (_posts[postIndex]['likesCount'] ?? 0) + 1;
      } else {
        _posts[postIndex]['likesCount'] =
            (_posts[postIndex]['likesCount'] ?? 1) - 1;
      }
    });

    print(
      'Like tapped for ${post['userName']} - New count: ${_posts[postIndex]['likesCount']}',
    );
  }

  void _handleComment(Map<String, dynamic> post, int postIndex) {
    print('Comment tapped for ${post['userName']}');

    // Show comments bottom sheet using built-in method
    _showCommentsBottomSheet(
      context,
      postId: post['id']?.toString() ?? '',
      comments: List<Map<String, dynamic>>.from(post['comments'] ?? []),
      postOwnerName: post['userName']?.toString() ?? 'Unknown User',
      onCommentsUpdated: () {
        // Update the comments count when new comments are added
        setState(() {
          // Count total comments including replies
          int totalComments = 0;
          List<Map<String, dynamic>> comments = List<Map<String, dynamic>>.from(
            post['comments'] ?? [],
          );

          for (var comment in comments) {
            totalComments++; // Count the main comment
            if (comment['replies'] != null) {
              totalComments +=
                  (comment['replies'] as List).length; // Count replies
            }
          }

          _posts[postIndex]['commentsCount'] = totalComments;
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));
    // Refresh posts data
    setState(() {
      _posts = List.from(post_data); // Reload original data
    });

    if (mounted) {
      SnackBarService.showSuccess(context, 'Posts refreshed!');
    }
  }

  void _showMoreOptions(BuildContext context, String userName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
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
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
                _reportPost(userName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _blockUser(userName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link_outlined),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                _copyLink(userName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border_outlined),
              title: const Text('Save Post'),
              onTap: () {
                Navigator.pop(context);
                _savePost(userName);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _reportPost(String userName) {
    SnackBarService.showSuccess(context, 'Post reported');
  }

  void _blockUser(String userName) {
    SnackBarService.showSuccess(context, 'User blocked');
  }

  void _copyLink(String userName) {
    SnackBarService.showSuccess(context, 'Link copied to clipboard');
  }

  void _savePost(String userName) {
    SnackBarService.showSuccess(context, 'Post saved');
  }

  // Built-in Comments Bottom Sheet Method
  void _showCommentsBottomSheet(
    BuildContext context, {
    required String postId,
    required List<Map<String, dynamic>> comments,
    required String postOwnerName,
    VoidCallback? onCommentsUpdated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsBottomSheet(
        postId: postId,
        comments: comments,
        postOwnerName: postOwnerName,
        onCommentsUpdated: onCommentsUpdated,
      ),
    );
  }
}

// Built-in Comments Bottom Sheet Widget
class _CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final List<Map<String, dynamic>> comments;
  final String postOwnerName;
  final VoidCallback? onCommentsUpdated;

  const _CommentsBottomSheet({
    required this.postId,
    required this.comments,
    required this.postOwnerName,
    this.onCommentsUpdated,
  });

  @override
  State<_CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _replyingTo;
  String? _replyingToCommentId;
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Comments List
          Expanded(child: _buildCommentsList()),

          // Comment Input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (_comments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Be the first to comment!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _buildCommentItem(comment, false);
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, bool isReply) {
    return Container(
      margin: EdgeInsets.only(left: isReply ? 40 : 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              CircleAvatar(
                radius: isReply ? 14 : 16,
                backgroundImage:
                    comment['userImage'] != null &&
                        comment['userImage'].isNotEmpty
                    ? NetworkImage(comment['userImage'])
                    : null,
                backgroundColor: Colors.grey[300],
                child:
                    comment['userImage'] == null || comment['userImage'].isEmpty
                    ? Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: isReply ? 16 : 20,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Comment Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and Comment
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: comment['userName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: comment['comment'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Actions Row
                    Row(
                      children: [
                        Text(
                          comment['timeAgo'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (comment['likesCount'] > 0) ...[
                          Text(
                            '${comment['likesCount']} likes',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (!isReply) ...[
                          GestureDetector(
                            onTap: () =>
                                _startReply(comment['userName'], comment['id']),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Like Button
              GestureDetector(
                onTap: () => _toggleCommentLike(comment),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    comment['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: comment['isLiked'] ? Colors.red : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          // Replies
          if (!isReply &&
              comment['replies'] != null &&
              comment['replies'].isNotEmpty) ...[
            const SizedBox(height: 8),
            ...comment['replies']
                .map<Widget>((reply) => _buildCommentItem(reply, true))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply indicator
          if (_replyingTo != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingTo',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Input Row
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600], size: 20),
              ),
              const SizedBox(width: 12),

              // Text Input
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  decoration: InputDecoration(
                    hintText: _replyingTo != null
                        ? 'Reply...'
                        : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    suffixIcon: _commentController.text.isNotEmpty
                        ? IconButton(
                            onPressed: _postComment,
                            icon: const Icon(Icons.send, color: Colors.blue),
                          )
                        : null,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    setState(() {}); // Update send button visibility
                  },
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _postComment();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startReply(String userName, String commentId) {
    setState(() {
      _replyingTo = userName;
      _replyingToCommentId = commentId;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _replyingToCommentId = null;
    });
  }

  void _postComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final newComment = {
      'id': 'new_${DateTime.now().millisecondsSinceEpoch}',
      'userName': 'You', // Replace with actual user name
      'userImage': '', // Replace with actual user image
      'comment': commentText,
      'timeAgo': 'now',
      'likesCount': 0,
      'isLiked': false,
      'replies': [],
    };

    setState(() {
      if (_replyingTo != null && _replyingToCommentId != null) {
        // Add as reply
        final commentIndex = _comments.indexWhere(
          (c) => c['id'] == _replyingToCommentId,
        );
        if (commentIndex != -1) {
          _comments[commentIndex]['replies'].add(newComment);
        }
      } else {
        // Add as new comment
        _comments.insert(0, newComment);
      }

      _commentController.clear();
      _cancelReply();
    });

    // Hide keyboard
    _commentFocusNode.unfocus();

    // Notify parent of update
    widget.onCommentsUpdated?.call();
  }

  void _toggleCommentLike(Map<String, dynamic> comment) {
    setState(() {
      comment['isLiked'] = !comment['isLiked'];
      if (comment['isLiked']) {
        comment['likesCount']++;
      } else {
        comment['likesCount']--;
      }
    });
  }
}
