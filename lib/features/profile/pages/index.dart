import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/data/repositories/follow_repository/follow_repository.dart';
import 'package:journeyq/data/repositories/post_repository/post_repository.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/features/profile/pages/followersfollowingpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool isSubscribed = false;
  String selectedTab = 'posts';

  // Loading and data states
  bool _isLoading = true;
  bool _isLoadingStats = true;
  bool _isLoadingPosts = true;
  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? _statsData;
  List<Map<String, dynamic>> _userPosts = [];
  String? _userId;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      print("=== Loading Profile Data ===");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authUser = authProvider.user;

      if (authUser?.userId == null) {
        throw Exception('User not found. Please login again.');
      }

      _userId = authUser!.userId?.toString();
      print("Loading profile for userId: $_userId");

      setState(() {
        _isLoading = true;
        _isLoadingStats = true;
        _isLoadingPosts = true;
      });

      // Load profile data, stats, and posts concurrently
      final List<dynamic> results = await Future.wait([
        ProfileRepository.getProfile(_userId!),
        _loadUserStats(),
        _loadUserPosts(),
      ]);

      final profileData = results[0] as Map<String, dynamic>;
      final statsData = results[1] as Map<String, dynamic>?;
      final postsData = results[2] as List<Map<String, dynamic>>;

      print("Profile data loaded: $profileData");
      print("Stats data loaded: $statsData");
      print("Posts data loaded: ${postsData.length} posts");

      setState(() {
        _profileData = profileData;
        _statsData = statsData;
        _userPosts = postsData;
        _isLoading = false;
        _isLoadingStats = false;
        _isLoadingPosts = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        _isLoading = false;
        _isLoadingStats = false;
        _isLoadingPosts = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // New method to load user stats
  Future<Map<String, dynamic>?> _loadUserStats() async {
    try {
      final statsResponse = await FollowRepository.getMyProfileStats();
      return statsResponse;
    } catch (e) {
      print("Error loading user stats: $e");
      // Try to create stats if they don't exist
      try {
        if (_userId != null) {
          await FollowRepository.createUserStats(_userId!);
          // Try again after creating
          final statsResponse = await FollowRepository.getMyProfileStats();
          return statsResponse;
        }
      } catch (createError) {
        print("Error creating user stats: $createError");
      }
      return null;
    }
  }

  // New method to load user posts
  Future<List<Map<String, dynamic>>> _loadUserPosts() async {
    try {
      if (_userId == null) return [];
      
      final postsResponse = await PostRepository.getUserPosts(_userId!);
      print("Loaded ${postsResponse.length} posts for user $_userId");
      
      // Transform the backend response to match the UI format
      return postsResponse.map((post) {
        final postImages = (post['postImages'] as List? ?? []).cast<String>();
        final firstImage = postImages.isNotEmpty 
            ? postImages.first 
            : 'assets/images/placeholder.jpg';
        
        return {
          'id': post['id']?.toString() ?? '',
          'imageUrl': firstImage,
          'postImages': postImages,
          'likes': 0, // Will be fetched separately if needed
          'comments': 0, // Will be fetched separately if needed
          'isLiked': false,
          'isSaved': false,
          'caption': post['journeyTitle']?.toString() ?? 'Untitled Journey',
          'location': post['location']?.toString() ?? 'Unknown Location',
          'destination': post['journeyTitle']?.toString() ?? 'Unknown Destination',
          'description': 'Explore this amazing journey',
          'timestamp': _formatTimestamp(post['createdAt']?.toString()),
          'isVisited': true,
          'visitDate': post['createdAt']?.toString()?.split('T').first ?? '',
          'journeyId': post['id']?.toString() ?? '',
          'postId': post['id']?.toString() ?? '', // For navigation to journey details
        };
      }).toList();
    } catch (e) {
      print("Error loading user posts: $e");
      return [];
    }
  }

  // Method to refresh stats after follow actions
  Future<void> _refreshStats() async {
    try {
      final statsData = await _loadUserStats();
      if (mounted) {
        setState(() {
          _statsData = statsData;
        });
      }
    } catch (e) {
      print("Error refreshing stats: $e");
    }
  }

  // Helper method to format timestamp
  String _formatTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'Recently';
    
    try {
      final DateTime postTime = DateTime.parse(timestamp);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(postTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()}w ago';
      } else {
        return '${(difference.inDays / 30).floor()}mo ago';
      }
    } catch (e) {
      print('Error parsing timestamp: $e');
      return 'Recently';
    }
  }

  // Updated method to get user data with dynamic stats
  Map<String, dynamic> _getUserData(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authUser = authProvider.user;

    // Get follower/following counts from stats data
    int followersCount = 0;
    int followingCount = 0;

    if (_statsData != null) {
      followersCount = _statsData!['followersCount'] ?? 0;
      followingCount = _statsData!['followingCount'] ?? 0;
    }

    if (_profileData != null) {
      return {
        'id': _userId,
        'userId': _userId,
        'name': _profileData!['display_name'] ?? authUser?.username ?? 'Unknown User',
        'username': authUser?.username ?? 'unknown_user',
        'displayName': _profileData!['display_name'] ?? authUser?.username ?? 'Unknown User',
        'bio': _profileData!['bio'] ?? 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ ${_userPosts.length} amazing journeys completed',
        'posts': _userPosts.length,
        'followers': followersCount,
        'following': followingCount,
        'profileImage': _profileData!['profile_image_url'] ?? authUser?.profileUrl ?? 'assets/images/profile_picture.jpg',
        'isVerified': true,
        'isCurrentUser': true,
        'level': 'Explorer',
        'joinDate': 'March 2022',
        'achievements': ['Mountain Climber', 'Ocean Explorer', 'City Wanderer'],
        'activities': _profileData!['favourite_activities'] ?? [],
        'tripMoods': _profileData!['preferred_trip_moods'] ?? [],
      };
    } else {
      return {
        'id': _userId,
        'userId': _userId,
        'name': authUser?.username ?? 'Unknown User',
        'username': authUser?.username ?? 'unknown_user',
        'displayName': authUser?.username ?? 'Unknown User',
        'bio': 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ ${_userPosts.length} amazing journeys completed',
        'posts': _userPosts.length,
        'followers': followersCount,
        'following': followingCount,
        'profileImage': authUser?.profileUrl ?? 'assets/images/profile_picture.jpg',
        'isVerified': true,
        'isCurrentUser': true,
        'level': 'Explorer',
        'joinDate': 'March 2022',
        'achievements': ['Mountain Climber', 'Ocean Explorer', 'City Wanderer'],
        'activities': [],
        'tripMoods': [],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
          child: Column(
          children: [
          _buildHeaderSkeleton(),
    Expanded(
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
    ),
      const SizedBox(height: 16),
      const Text(
        'Loading Profile...',
        style: TextStyle(
          color: Color(0xFF636E72),
          fontSize: 16,
        ),
      ),
    ],
    ),
    ),
    ),
          ],
          ),
          ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUserProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                _buildProfileCard(context),
                _buildStatsCard(context),
                _buildActionButtons(),
                _buildContentSection(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userData = _getUserData(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: Color(0xFF0088cc), size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      userData['username'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFF2D3436),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (userData['isVerified'] == true) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF0088cc),
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: isSubscribed
                        ? [const Color(0xFFFFD700), const Color(0xFFFF6B6B)]
                        : [
                      const Color(0xFF0088cc),
                      Color(0xFF0088cc).withOpacity(0.8),
                    ],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: _handleSubscribe,
                  icon: Icon(
                    isSubscribed ? Icons.star : Icons.star_outline,
                    size: 13,
                  ),
                  label: Text(isSubscribed ? 'Premium' : 'Subscribe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    minimumSize: const Size(0, 28),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildHeaderButton(
                Icons.settings_outlined,
                    () => context.push('/profile/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF2D3436)),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final userData = _getUserData(context);

    ImageProvider? _getImageProvider(String? imagePath) {
      if (imagePath == null) return null;

      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return NetworkImage(imagePath);
      } else {
        return AssetImage(imagePath);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: _getImageProvider(userData['profileImage']),
                    backgroundColor: Colors.grey[200],
                    child: userData['profileImage'] == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  if (isSubscribed)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData['name'] ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088cc).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userData['level'] ?? 'Explorer',
                    style: const TextStyle(
                      color: Color(0xFF0088cc),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userData['bio'] ?? 'No bio available',
                  style: const TextStyle(
                    color: Color(0xFF636E72),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final userData = _getUserData(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            _userPosts.length.toString(),
            'Posts',
            Icons.photo_library,
            const Color(0xFF0088cc),
            null,
          ),
          _buildDivider(),
          _buildStatItem(
            _isLoadingStats ? '...' : _formatNumber(userData['followers'] ?? 0),
            'Followers',
            Icons.people,
            const Color(0xFF00B894),
                () => _navigateToFollowersFollowing('followers'),
          ),
          _buildDivider(),
          _buildStatItem(
            _isLoadingStats ? '...' : (userData['following'] ?? 0).toString(),
            'Following',
            Icons.person_add,
            const Color(0xFFE17055),
                () => _navigateToFollowersFollowing('following'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String count,
      String label,
      IconData icon,
      Color color,
      VoidCallback? onTap,
      ) {
    Widget statWidget = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF636E72)),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: statWidget,
      );
    }

    return statWidget;
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[200]);
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2D3436),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _navigateToBucketList,
                icon: const Icon(Icons.bookmark, size: 18),
                label: const Text('Bucket List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            'My Journeys',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
        ),
        _buildPostsGrid(),
      ],
    );
  }

  Widget _buildPostsGrid() {
    // Show all posts if loading is complete, otherwise show empty list
    if (_isLoadingPosts) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading posts...'),
            ],
          ),
        ),
      );
    }

    if (_userPosts.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(32),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No posts yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Start sharing your amazing journeys!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _userPosts.length,
        itemBuilder: (context, index) {
          final post = _userPosts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: _buildPostImage(post['imageUrl']),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['destination'] ?? 'Unknown Location',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post['description'] ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF636E72),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _viewJourney(post),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088cc),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'View Journey',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _editProfile() {
    context.push('/profile/edit');
  }

  void _handleSubscribe() {
    if (isSubscribed) {
      _showSubscriptionManagement();
    } else {
      final userData = _getUserData(context);
      context.push('/profile/payment', extra: userData);
    }
  }

  void _showSubscriptionManagement() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Premium Subscription',
                    style: TextStyle(
                      color: Color(0xFF2D3436),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'You currently have an active premium subscription with access to all premium features.',
                style: TextStyle(color: Color(0xFF636E72), fontSize: 14),
              ),
              const SizedBox(height: 20),
              _buildSubscriptionOption(
                Icons.settings,
                'Manage Subscription',
                const Color(0xFF0088cc),
                    () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Opening subscription management...'),
                      backgroundColor: const Color(0xFF0088cc),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSubscriptionOption(
                Icons.cancel,
                'Cancel Subscription',
                const Color(0xFFE17055),
                    () {
                  Navigator.pop(context);
                  _showCancelSubscriptionDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionOption(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCancelSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Subscription?',
          style: TextStyle(color: Color(0xFF2D3436)),
        ),
        content: const Text(
          'Are you sure you want to cancel your premium subscription? You will lose access to premium features.',
          style: TextStyle(color: Color(0xFF636E72)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Premium'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isSubscribed = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Subscription cancelled'),
                  backgroundColor: const Color(0xFFE17055),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFE17055)),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build post images (supports both asset and network images)
  Widget _buildPostImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }
    
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      );
    }
  }

  void _viewJourney(Map<String, dynamic> post) {
    final postId = post['postId'] ?? post['journeyId'] ?? post['id'];
    if (postId != null && postId.toString().isNotEmpty) {
      context.push('/journey/$postId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journey details not available for ${post['destination']}')),
      );
    }
  }

  void _navigateToBucketList() {
    context.push('/profile/bucketlist');
  }

  // Updated navigation method to pass userData and refresh stats on return
  void _navigateToFollowersFollowing(String tab) {
    final userData = _getUserData(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowersFollowingPage(
          initialTab: tab,
          userData: userData,
        ),
      ),
    ).then((_) {
      // Refresh stats when returning from followers/following page
      _refreshStats();
    });
  }
}