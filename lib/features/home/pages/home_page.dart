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
              const SliverPadding(padding: EdgeInsets.only(bottom:10)),
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
            postId: post['id']?.toString() ?? '1',
            userName: post['userName']?.toString() ?? 'Unknown User',
            location: post['location']?.toString() ?? 'Unknown Location',
            userImage: post['userImage']?.toString() ?? '',
            journeyTitle: post['journeyTitle']?.toString() ?? 'Travel Adventure',
            placesVisited: placesVisited,
            postImages: postImages,
            likesCount: _convertToInt(post['likesCount']),
            commentsCount: _convertToInt(post['commentsCount']),
            isLiked: post['isLiked'] ?? false,
            isFollowed: false,
            isBookmarked: false,
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
}