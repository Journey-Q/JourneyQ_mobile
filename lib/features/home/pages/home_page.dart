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
  final List<Map<String, dynamic>> _posts = post_data;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: JourneyQAppBar(
        notificationCount: 3,
        chatCount: 7,
        onNotificationTap: () {
          // Handle notification tap
        },
        onChatTap: () {
          // Handle chat tap
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
                        SnackBarService.showSuccess(
                          context,
                          "Login Successful! Welcome back!",
                        );
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
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];

          // Safely handle data conversion
          List<String> placesVisited = _convertToStringList(post['placesVisited']);
          List<String> postImages = _convertToStringList(post['postImages']);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TravelPostWidget(
              userName: post['userName']?.toString() ?? 'Unknown User',
              location: post['location']?.toString() ?? 'Unknown Location',
              userImage: post['userImage']?.toString() ?? '',
              journeyTitle: post['journeyTitle']?.toString() ?? 'Travel Adventure',
              placesVisited: placesVisited,
              postImages: postImages,
              likesCount: _convertToInt(post['likesCount']),
              commentsCount: _convertToInt(post['commentsCount']),
              onViewJourney: () => _handleViewJourney(post),
              onLike: () => _handleLike(post),
              onComment: () => _handleComment(post),
              onMoreOptions: () => _showMoreOptions(context, post['userName']?.toString() ?? 'Unknown'),
            ),
          );
        },
        childCount: _posts.length,
      ),
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
  void _handleViewJourney(Map<String, dynamic> post) {
    print('View journey tapped for ${post['userName']}');
    // Navigate to journey details page
    // context.push('/journey/${post['id']}');
  }

  void _handleLike(Map<String, dynamic> post) {
    print('Like tapped for ${post['userName']}');
    // Handle like functionality
    // Update like count in database/state management
  }

  void _handleComment(Map<String, dynamic> post) {
    print('Comment tapped for ${post['userName']}');
    // Navigate to comments page
    // context.push('/comments/${post['id']}');
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));
    // Refresh posts data
    // await _loadPosts();
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
}