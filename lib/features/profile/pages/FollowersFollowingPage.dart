import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/data/repositories/follow_repository/follow_repository.dart';
import 'package:journeyq/core/errors/exception.dart';

class FollowersFollowingPage extends StatefulWidget {
  final String initialTab; // 'followers' or 'following'
  final Map<String, dynamic> userData;

  const FollowersFollowingPage({
    super.key,
    required this.initialTab,
    required this.userData,
  });

  @override
  State<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Loading states
  bool _isLoadingFollowers = true;
  bool _isLoadingFollowing = true;
  bool _isLoadingMore = false;

  // Data
  List<UserFollowInfo> _followers = [];
  List<UserFollowInfo> _following = [];

  // Pagination
  int _followersPage = 0;
  int _followingPage = 0;
  final int _pageSize = 20;
  bool _hasMoreFollowers = true;
  bool _hasMoreFollowing = true;

  // Error states
  String? _followersError;
  String? _followingError;

  // Auth state
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();

   
    // Fixed: Proper string comparison with trimming and lowercase
    final String cleanTab = widget.initialTab.trim().toLowerCase();
    final int initialTabIndex = cleanTab == 'following' ? 1 : 0;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTabIndex,
    );

    _checkAuthStatusAndLoadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatusAndLoadData() async {
    try {
      // Check if user is authenticated
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token'); // Fixed: use correct key name

      if (token == null || token.isEmpty) {
        print('DEBUG: No auth token found');
        setState(() {
          _followersError = 'Please log in to view followers';
          _followingError = 'Please log in to view following';
          _isLoadingFollowers = false;
          _isLoadingFollowing = false;
          _isAuthenticated = false;
        });
        return;
      }

      print('DEBUG: Auth token found, loading data...');
      print('DEBUG: Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');

      setState(() {
        _isAuthenticated = true;
      });

      await _loadData();
    } catch (e) {
      print('DEBUG: Error checking auth status: $e');
      setState(() {
        _followersError = 'Authentication error';
        _followingError = 'Authentication error';
        _isLoadingFollowers = false;
        _isLoadingFollowing = false;
      });
    }
  }

  Future<void> _loadData() async {
    // Load both tabs concurrently
    await Future.wait([
      _loadFollowers(refresh: true),
      _loadFollowing(refresh: true),
    ]);
  }

  Future<void> _loadFollowers({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoadingFollowers = true;
        _followersError = null;
        _followersPage = 0;
        _hasMoreFollowers = true;
      });
    } else if (!_hasMoreFollowers || _isLoadingMore) {
      return;
    }

    try {
      setState(() {
        if (!refresh) _isLoadingMore = true;
      });

      late FollowListResponse response;

      // Check if this is the current user's profile or another user's profile
      final userId = widget.userData['id'] ?? widget.userData['userId'];
      final String userIdStr = userId?.toString() ?? '';

      print('DEBUG: Loading followers for userId: $userIdStr (type: ${userId.runtimeType})');
      print('DEBUG: userData[\'id\']: ${widget.userData['id']} (type: ${widget.userData['id'].runtimeType})');
      print('DEBUG: userData[\'userId\']: ${widget.userData['userId']}');
      print('DEBUG: Is current user: ${_isCurrentUserProfile()}');
      print('DEBUG: Will use ${userIdStr.isEmpty || _isCurrentUserProfile() ? "my-followers" : "getUserFollowers"} endpoint');

      // If userId is empty or this is a "my profile" context, use my-followers endpoint
      if (userIdStr.isEmpty || _isCurrentUserProfile()) {
        print('DEBUG: Using my-followers endpoint');
        response = await FollowRepository.getMyFollowers(
          page: _followersPage,
          size: _pageSize,
        );
      } else {
        print('DEBUG: Using getUserFollowers endpoint with userId: $userIdStr');
        response = await FollowRepository.getUserFollowers(
          userId: userIdStr,
          page: _followersPage,
          size: _pageSize,
        );
      }

      setState(() {
        if (refresh) {
          _followers = response.users;
        } else {
          _followers.addAll(response.users);
        }

        _hasMoreFollowers = response.users.length == _pageSize;
        _followersPage++;
        _isLoadingFollowers = false;
        _isLoadingMore = false;
        _followersError = null;
      });
    } on AppException catch (e) {
      print('DEBUG: AppException in _loadFollowers: ${e.message}');
      setState(() {
        _followersError = e.message;
        _isLoadingFollowers = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      print('DEBUG: General exception in _loadFollowers: $e');
      setState(() {
        _followersError = 'Failed to load followers. Please try again.';
        _isLoadingFollowers = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadFollowing({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoadingFollowing = true;
        _followingError = null;
        _followingPage = 0;
        _hasMoreFollowing = true;
      });
    } else if (!_hasMoreFollowing || _isLoadingMore) {
      return;
    }

    try {
      setState(() {
        if (!refresh) _isLoadingMore = true;
      });

      late FollowListResponse response;

      // Check if this is the current user's profile or another user's profile
      final userId = widget.userData['id'] ?? widget.userData['userId'];
      final String userIdStr = userId?.toString() ?? '';

      print('DEBUG: Loading following for userId: $userIdStr (type: ${userId.runtimeType})');
      print('DEBUG: Is current user: ${_isCurrentUserProfile()}');
      print('DEBUG: Will use ${userIdStr.isEmpty || _isCurrentUserProfile() ? "my-following" : "getUserFollowing"} endpoint');

      // If userId is empty or this is a "my profile" context, use my-following endpoint
      if (userIdStr.isEmpty || _isCurrentUserProfile()) {
        print('DEBUG: Using my-following endpoint');
        response = await FollowRepository.getMyFollowing(
          page: _followingPage,
          size: _pageSize,
        );
      } else {
        print('DEBUG: Using getUserFollowing endpoint with userId: $userIdStr');
        response = await FollowRepository.getUserFollowing(
          userId: userIdStr,
          page: _followingPage,
          size: _pageSize,
        );
      }

      setState(() {
        if (refresh) {
          _following = response.users;
        } else {
          _following.addAll(response.users);
        }

        _hasMoreFollowing = response.users.length == _pageSize;
        _followingPage++;
        _isLoadingFollowing = false;
        _isLoadingMore = false;
        _followingError = null;
      });
    } on AppException catch (e) {
      print('DEBUG: AppException in _loadFollowing: ${e.message}');
      setState(() {
        _followingError = e.message;
        _isLoadingFollowing = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      print('DEBUG: General exception in _loadFollowing: $e');
      setState(() {
        _followingError = 'Failed to load following. Please try again.';
        _isLoadingFollowing = false;
        _isLoadingMore = false;
      });
    }
  }

  // Helper method to determine if this is the current user's profile
  bool _isCurrentUserProfile() {
    // Check if isCurrentUser flag is explicitly set
    final isCurrentUser = widget.userData['isCurrentUser'];

    print('DEBUG: isCurrentUser flag: $isCurrentUser');
    print('DEBUG: userData keys: ${widget.userData.keys.toList()}');

    // Return true only if explicitly set to true, otherwise assume it's another user
    return isCurrentUser == true;
  }

  // Helper method to get followers count from userData stats
  int _getFollowersCount() {
    // Try to get count from userData stats first
    final followers = widget.userData['followers'];
    if (followers != null) {
      if (followers is int) return followers;
      if (followers is String) return int.tryParse(followers) ?? 0;
    }

    // Fallback to loaded list length
    return _followers.length;
  }

  // Helper method to get following count from userData stats
  int _getFollowingCount() {
    // Try to get count from userData stats first
    final following = widget.userData['following'];
    if (following != null) {
      if (following is int) return following;
      if (following is String) return int.tryParse(following) ?? 0;
    }

    // Fallback to loaded list length
    return _following.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userData['username'] ?? widget.userData['displayName'] ?? 'User',
          style: const TextStyle(
            color: Color(0xFF2D3436),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0088cc),
              unselectedLabelColor: const Color(0xFF636E72),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF0088cc),
                    width: 3,
                  ),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people, size: 18),
                      const SizedBox(width: 6),
                      Text('${_getFollowersCount()} Followers'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add, size: 18),
                      const SizedBox(width: 6),
                      Text('${_getFollowingCount()} Following'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFollowersTab(),
          _buildFollowingTab(),
        ],
      ),
    );
  }

  Widget _buildFollowersTab() {
    if (!_isAuthenticated) {
      return _buildAuthErrorWidget();
    }

    if (_isLoadingFollowers && _followers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_followersError != null && _followers.isEmpty) {
      return _buildErrorWidget(_followersError!, () => _loadFollowers(refresh: true));
    }

    if (_followers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0088cc).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 64,
                color: Color(0xFF0088cc),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No followers yet',
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start connecting with other travelers',
              style: TextStyle(
                color: Color(0xFF636E72),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadFollowers(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasMoreFollowers) {
            _loadFollowers();
          }
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _followers.length + (_hasMoreFollowers ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _followers.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _buildUserItem(_followers[index]);
          },
        ),
      ),
    );
  }

  Widget _buildFollowingTab() {
    if (!_isAuthenticated) {
      return _buildAuthErrorWidget();
    }

    if (_isLoadingFollowing && _following.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_followingError != null && _following.isEmpty) {
      return _buildErrorWidget(_followingError!, () => _loadFollowing(refresh: true));
    }

    if (_following.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF00B894).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_outlined,
                size: 64,
                color: Color(0xFF00B894),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Not following anyone yet',
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover and follow amazing travelers',
              style: TextStyle(
                color: Color(0xFF636E72),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadFollowing(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasMoreFollowing) {
            _loadFollowing();
          }
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _following.length + (_hasMoreFollowing ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _following.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _buildUserItem(_following[index]);
          },
        ),
      ),
    );
  }

  Widget _buildAuthErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE17055).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 64,
                color: Color(0xFFE17055),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Authentication Required',
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Please log in to view followers and following',
              style: TextStyle(
                color: Color(0xFF636E72),
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE17055).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: Color(0xFFE17055),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: Color(0xFF2D3436),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                color: Color(0xFF636E72),
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(UserFollowInfo user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture with gradient border for mutual follows
          GestureDetector(
            onTap: () => _navigateToProfile(user.userId),
            child: Container(
              decoration: user.isMutualFollow == true
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0088cc), Color(0xFF00B894)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0088cc).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : null,
              padding: user.isMutualFollow == true
                  ? const EdgeInsets.all(2)
                  : EdgeInsets.zero,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                onBackgroundImageError: (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                    ? (_, __) {}
                    : null,
                child: (user.profileImageUrl == null || user.profileImageUrl!.isEmpty)
                    ? Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 32,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // User Info
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(user.userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.displayName,
                          style: const TextStyle(
                            color: Color(0xFF2D3436),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isMutualFollow == true) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0088cc), Color(0xFF00B894)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Mutual',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(String userId) {
    // Get the user info from the lists
    UserFollowInfo? userInfo;

    // Search in followers list
    try {
      userInfo = _followers.firstWhere((user) => user.userId == userId);
    } catch (e) {
      // Not found in followers, try following list
      try {
        userInfo = _following.firstWhere((user) => user.userId == userId);
      } catch (e) {
        print('User not found in either list: $userId');
      }
    }

    // Navigate to user profile page with userId and userName
    final userName = userInfo?.displayName ?? 'User';
    context.push('/user-profile/$userId/$userName');
  }
}

// ==================== FOLLOW BUTTON WIDGET ====================

class FollowButton extends StatefulWidget {
  final String userId;
  final String displayName;
  final String? initialStatus; // Add initial status parameter
  final VoidCallback? onFollowChanged;
  final ButtonStyle? style;

  const FollowButton({
    super.key,
    required this.userId,
    required this.displayName,
    this.initialStatus,
    this.onFollowChanged,
    this.style,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isLoading = false; // Start with false since we have initial status
  bool _isActionLoading = false;
  String _followStatus = 'none'; // none, pending, accepted, rejected

  @override
  void initState() {
    super.initState();
    // Use initial status if provided, otherwise load from cache/API
    if (widget.initialStatus != null) {
      _followStatus = widget.initialStatus!;
    } else {
      _isLoading = true;
      _loadFollowStatus();
    }
  }

  Future<void> _loadFollowStatus() async {
    try {
      final status = await FollowRepository.getFollowStatus(widget.userId);
      if (mounted) {
        setState(() {
          _followStatus = status ?? 'none';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG: Error loading follow status: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleFollowToggle() async {
    if (_isActionLoading) return;

    setState(() {
      _isActionLoading = true;
    });

    try {
      late Map<String, dynamic> result;
      String successMessage = '';

      switch (_followStatus) {
        case 'accepted':
          result = await FollowRepository.unfollowUser(widget.userId);
          successMessage = 'Unfollowed ${widget.displayName}';
          break;
        case 'pending':
          result = await FollowRepository.unfollowUser(widget.userId);
          successMessage = 'Cancelled follow request';
          break;
        default:
          result = await FollowRepository.sendFollowRequest(widget.userId);
          successMessage = 'Follow request sent to ${widget.displayName}';
          break;
      }

      if (result['success'] == true) {
        // Reload status
        await _loadFollowStatus();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Notify parent widget
        widget.onFollowChanged?.call();
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Error in _handleFollowToggle: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isActionLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: 95,
        height: 34,
        child: ElevatedButton(
          onPressed: null,
          style: widget.style ?? _getDefaultButtonStyle(),
          child: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 95, // Slightly reduced width to prevent overflow
      height: 34,
      child: ElevatedButton(
        onPressed: _isActionLoading ? null : _handleFollowToggle,
        style: widget.style ?? _getButtonStyle(),
        child: _isActionLoading
            ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : FittedBox( // Ensures text fits within button
          fit: BoxFit.scaleDown,
          child: Text(
            _getButtonText(),
            style: const TextStyle(
              fontSize: 13, // Slightly smaller font
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_followStatus) {
      case 'accepted':
        return 'Following';
      case 'pending':
        return 'Requested'; // Shorter text to prevent overflow
      default:
        return 'Follow';
    }
  }

  ButtonStyle _getButtonStyle() {
    switch (_followStatus) {
      case 'accepted':
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        );
      case 'pending':
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[50], // Blue background
          foregroundColor: Colors.blue[700], // Blue text
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.blue[200]!),
          ),
        );
      default:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
    }
  }

  ButtonStyle _getDefaultButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[300],
      foregroundColor: Colors.grey[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// Extension to help with follow status management
extension FollowStatusExtension on UserFollowInfo {
  bool get isFollowing => status == 'accepted';
  bool get isPending => status == 'pending';
  bool get canFollow => status != 'accepted' && status != 'pending';
}