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
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == 'following' ? 1 : 0,
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
      final String userId = widget.userData['id'] ?? widget.userData['userId'] ?? '';
      print('DEBUG: Loading followers for userId: $userId');
      print('DEBUG: Is current user: ${_isCurrentUserProfile()}');

      // If userId is empty or this is a "my profile" context, use my-followers endpoint
      if (userId.isEmpty || _isCurrentUserProfile()) {
        print('DEBUG: Using my-followers endpoint');
        response = await FollowRepository.getMyFollowers(
          page: _followersPage,
          size: _pageSize,
        );
      } else {
        print('DEBUG: Using getUserFollowers endpoint');
        response = await FollowRepository.getUserFollowers(
          userId: userId,
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
      final String userId = widget.userData['id'] ?? widget.userData['userId'] ?? '';
      print('DEBUG: Loading following for userId: $userId');

      // If userId is empty or this is a "my profile" context, use my-following endpoint
      if (userId.isEmpty || _isCurrentUserProfile()) {
        print('DEBUG: Using my-following endpoint');
        response = await FollowRepository.getMyFollowing(
          page: _followingPage,
          size: _pageSize,
        );
      } else {
        print('DEBUG: Using getUserFollowing endpoint');
        response = await FollowRepository.getUserFollowing(
          userId: userId,
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
    // You can customize this logic based on how you determine if it's the current user
    // For example, you might pass a flag in userData or check against the current user ID
    return widget.userData['isCurrentUser'] == true;
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
        title: Text(
          widget.userData['username'] ?? widget.userData['displayName'] ?? 'User',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: '${_followers.length} Followers'),
            Tab(text: '${_following.length} Following'),
          ],
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
      return const Center(
        child: Text(
          'No followers yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
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
      return const Center(
        child: Text(
          'Not following anyone yet',
          style: TextStyle(color: Colors.grey, fontSize: 16),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Please log in to view followers and following',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to login or refresh auth
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Center(
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
            error,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserFollowInfo user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () => _navigateToProfile(user.userId),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: user.profileImageUrl != null
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              child: user.profileImageUrl == null
                  ? Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(user.userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (user.isMutualFollow == true)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Mutual',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '@${user.userId}', // You might want to use username instead
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _getStatusText(user.status),
                    style: TextStyle(
                      color: _getStatusColor(user.status),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Follow Button
          _buildFollowButton(user),
        ],
      ),
    );
  }

  Widget _buildFollowButton(UserFollowInfo user) {
    return FollowButton(
      userId: user.userId,
      displayName: user.displayName,
      initialStatus: user.status, // Pass the initial status from the API response
      onFollowChanged: () {
        // Refresh the current tab when follow status changes
        if (_tabController.index == 0) {
          _loadFollowers(refresh: true);
        } else {
          _loadFollowing(refresh: true);
        }
      },
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Follows you';
      case 'pending':
        return 'Pending approval';
      case 'rejected':
        return '';
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _navigateToProfile(String userId) {
    // Navigate to user profile page
    // Replace this with your actual navigation logic
    context.push('/profile/$userId');
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
        width: 100,
        height: 32,
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
      width: 100,
      height: 32,
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
            : Text(
          _getButtonText(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
        return 'Pending';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        );
      case 'pending':
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[100],
          foregroundColor: Colors.orange[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.orange[300]!),
          ),
        );
      default:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
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