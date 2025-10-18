import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/shared/components/app_bar.dart';
import 'package:journeyq/features/home/pages/search_wiget.dart';
import 'package:journeyq/features/home/pages/widget.dart';
import 'package:journeyq/features/home/pages/travel_post_widget.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/data/repositories/chat_repository/chat_repository.dart';
import 'package:journeyq/features/notification/repository/notification_repository.dart';
import 'package:journeyq/data/repositories/feed_repository/feed_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ChatRepository _chatRepository = ChatRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();

  // Feed data
  List<FeedPost> _posts = [];
  bool _isChatInitialized = false;
  bool _isLoadingFeed = true;
  bool _isLoadingMore = false;
  String? _feedError;

  // Pagination
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMorePosts = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _loadFeed();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeChat() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        await _chatRepository.initialize(authProvider);
        await _chatRepository.initializeUserProfileIfNeeded(authProvider);

        if (mounted) {
          setState(() {
            _isChatInitialized = true;
          });
        }
      }
    } catch (e) {
      print('❌ Error initializing chat in home page: $e');
    }
  }

  Future<void> _loadFeed({bool refresh = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.userId?.toString();

    if (currentUserId == null) {
      print('❌ Cannot load feed: User not authenticated');
      setState(() {
        _isLoadingFeed = false;
        _feedError = 'Please log in to view posts';
      });
      return;
    }

    if (refresh) {
      setState(() {
        _isLoadingFeed = true;
        _feedError = null;
        _currentPage = 0;
        _hasMorePosts = true;
      });
    } else if (!_hasMorePosts || _isLoadingMore) {
      return;
    }

    try {
      setState(() {
        if (!refresh) _isLoadingMore = true;
      });

      print('📱 Loading feed for user: $currentUserId, page: $_currentPage');

      final feedResponse = await FeedRepository.getFeed(
        userId: currentUserId,
        page: _currentPage,
        size: _pageSize,
      );

      if (mounted) {
        setState(() {
          if (refresh) {
            _posts = feedResponse.posts;
          } else {
            _posts.addAll(feedResponse.posts);
          }

          _hasMorePosts = feedResponse.hasMore;
          _currentPage++;
          _isLoadingFeed = false;
          _isLoadingMore = false;
          _feedError = null;
        });
      }

      print('✅ Feed loaded: ${feedResponse.posts.length} posts');
    } on AppException catch (e) {
      print('❌ AppException loading feed: ${e.message}');
      if (mounted) {
        setState(() {
          _feedError = e.message;
          _isLoadingFeed = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      print('❌ Error loading feed: $e');
      if (mounted) {
        setState(() {
          _feedError = 'Failed to load feed. Please try again.';
          _isLoadingFeed = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMorePosts) {
        _loadFeed();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildDynamicAppBar() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.userId?.toString();

    if (currentUserId == null || !_isChatInitialized) {
      return JourneyQAppBar(
        notificationCount: 0,
        chatCount: 0,
        onNotificationTap: () {
          context.push('/notification');
        },
        onChatTap: () {
          context.push('/chat');
        },
      );
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: StreamBuilder<int>(
        stream: _chatRepository.streamUnreadMessageCount(currentUserId),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.hasError) {
            print('❌ Error in chat unread count stream: ${chatSnapshot.error}');
          }

          final chatUnreadCount = chatSnapshot.data ?? 0;

          return StreamBuilder<int>(
            stream: _notificationRepository.listenToUnreadCount(currentUserId),
            builder: (context, notificationSnapshot) {
              if (notificationSnapshot.hasError) {
                print('❌ Error in notification unread count stream: ${notificationSnapshot.error}');
              }

              final notificationUnreadCount = notificationSnapshot.data ?? 0;

              return JourneyQAppBar(
                notificationCount: notificationUnreadCount,
                chatCount: chatUnreadCount,
                onNotificationTap: () {
                  context.push('/notification');
                },
                onChatTap: () {
                  context.push('/chat');
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: _isChatInitialized ? _buildDynamicAppBar() : JourneyQAppBar(
        notificationCount: 0,
        chatCount: 0,
        onNotificationTap: () {
          context.push('/notification');
        },
        onChatTap: () {
          context.push('/chat');
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadFeed(refresh: true),
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

              // Posts List or Loading/Error State
              _buildContent(),

              // Loading more indicator
              if (_isLoadingMore)
                const SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

              // Bottom padding for navigation bar
              const SliverPadding(padding: EdgeInsets.only(bottom: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoadingFeed && _posts.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading your personalized feed...',
                style: TextStyle(
                  color: Color(0xFF636E72),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_feedError != null && _posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _feedError!,
                style: const TextStyle(
                  color: Color(0xFF636E72),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadFeed(refresh: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.travel_explore,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No posts to show',
                style: TextStyle(
                  color: Color(0xFF636E72),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start following travelers to see their journeys',
                style: TextStyle(
                  color: Color(0xFF636E72),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildPostsList();
  }

  Widget _buildPostsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts[index];

          // Extract first place name for location
          final location = post.placesVisited.isNotEmpty
              ? post.placesVisited.first
              : 'Unknown Location';

          // Get all images from place-wise content
          final postImages = post.getAllImages();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TravelPostWidget(
              postId: post.postId.toString(),
              userId: post.createdById.toString(),
              userName: post.creatorName,
              location: location,
              userImage: post.creatorProfileUrl ?? '',
              journeyTitle: post.journeyTitle,
              placesVisited: post.placesVisited,
              postImages: postImages,
              likesCount: post.likesCount,
              commentsCount: post.commentsCount,
              isLiked: post.isLikedByUser,
              isFollowed: false,
              isBookmarked: false,
              onMoreOptions: () => _showMoreOptions(
                context,
                post.creatorName,
                post.postId,
              ),
            ),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  void _showMoreOptions(BuildContext context, String userName, int postId) {
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
                _reportPost(userName, postId);
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
                _copyLink(postId);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _reportPost(String userName, int postId) {
    SnackBarService.showSuccess(context, 'Post reported');
  }

  void _blockUser(String userName) {
    SnackBarService.showSuccess(context, 'User blocked');
  }

  void _copyLink(int postId) {
    SnackBarService.showSuccess(context, 'Link copied to clipboard');
  }
}
