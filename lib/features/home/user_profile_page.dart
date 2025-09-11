import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/data/repositories/post_repository/post_repository.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfilePage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isFollowing = false;
  bool _isOwnProfile = false;
  bool _isLoadingProfile = true;
  bool _isLoadingPosts = true;
  bool _isLoadingStats = true;

  Map<String, dynamic> _userProfile = {};
  List<Map<String, dynamic>> _userPosts = [];
  Map<String, dynamic> _userStats = {};

  @override
  void initState() {
    super.initState();
    // Add null safety checks for widget parameters
    final safeUserId = widget.userId.isNotEmpty ? widget.userId : 'unknown';
    final safeUserName = widget.userName.isNotEmpty ? widget.userName : 'Unknown User';
    print('UserProfilePage: Loading profile for $safeUserName (ID: $safeUserId)');
    _loadDataSequentially();
  }

  // Sequential data loading to avoid pool collapse
  Future<void> _loadDataSequentially() async {
    // Load profile first
    await _loadUserProfile();
    // Then load posts
    await _loadUserPosts();
    // Finally load stats
    await _loadUserStats();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoadingProfile = true;
      });

      // Add null safety checks for widget parameters
      final safeUserId = widget.userId.isNotEmpty ? widget.userId : '';
      final safeUserName = widget.userName.isNotEmpty ? widget.userName : '';

      // Get profile data from backend using ProfileRepository
      final profileData = await ProfileRepository.getProfile(safeUserId);

      setState(() {
        _userProfile = {
          'id': profileData['id'] ?? safeUserId,
          'name': profileData['display_name'] ?? profileData['displayName'] ?? safeUserName,
          'username': '@${(profileData['display_name'] ?? profileData['displayName'] ?? safeUserName).toLowerCase().replaceAll(' ', '')}',
          'bio': profileData['bio'] ?? 'Travel enthusiast exploring hidden gems 🌍',
          'location': profileData['location'] ?? 'Location',
          'profileImage': profileData['profile_image_url'] ?? profileData['profileImageUrl'] ?? 'https://i.pravatar.cc/150?img=25',
          'coverImage': profileData['cover_image_url'] ?? profileData['coverImageUrl'] ?? 'assets/images/img1.jpg',
          'isVerified': profileData['is_verified'] ?? profileData['isVerified'] ?? false,
          'isPremium': profileData['isPremium'] ?? profileData['is_premium'] ?? false,
          'isTripFluencer': profileData['isTripFluence'] ?? profileData['is_trip_fluence'] ?? false,
        };
        _isLoadingProfile = false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoadingProfile = false;
        // Use minimal fallback data only for essential fields
        final safeUserId = widget.userId.isNotEmpty ? widget.userId : '';
        final safeUserName = widget.userName.isNotEmpty ? widget.userName : '';
        _userProfile = {
          'id': safeUserId,
          'name': safeUserName,
          'username': '@${safeUserName.toLowerCase().replaceAll(' ', '')}',
          'bio': 'Travel enthusiast exploring hidden gems 🌍',
          'location': 'Location',
          'profileImage': 'https://i.pravatar.cc/150?img=25',
          'coverImage': 'assets/images/img1.jpg',
          'isVerified': false,
          'isPremium': false,
          'isTripFluencer': false,
        };
      });
    }
  }

  Future<void> _loadUserPosts() async {
    try {
      setState(() {
        _isLoadingPosts = true;
      });

      final safeUserId = widget.userId.isNotEmpty ? widget.userId : 'unknown';
      final posts = await PostRepository.getUserPosts(safeUserId);
      
      print('Loaded ${posts.length} posts for user $safeUserId');
      for (int i = 0; i < posts.length; i++) {
        print('Post $i: ${posts[i]}');
      }
      
      setState(() {
        _userPosts = posts;
        _isLoadingPosts = false;
      });
    } catch (e) {
      print('Error loading user posts: $e');
      setState(() {
        _isLoadingPosts = false;
        // No fallback posts - show empty state
        _userPosts = [];
      });
    }
  }

  Future<void> _loadUserStats() async {
    try {
      setState(() {
        _isLoadingStats = true;
      });

      final safeUserId = widget.userId.isNotEmpty ? widget.userId : 'unknown';
      final stats = await ProfileRepository.getUserStats(safeUserId);
      
      setState(() {
        _userStats = stats;
        _isLoadingStats = false;
      });
    } catch (e) {
      print('Error loading user stats: $e');
      setState(() {
        _isLoadingStats = false;
        // Use minimal fallback stats
        _userStats = {
          'followersCount': 0,
          'followingCount': 0,
          'postsCount': 0,
        };
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Navigation method to journey detail page
  void _navigateToJourneyDetail(Map<String, dynamic> post) {
    final postId = post['id']?.toString();
    if (postId != null && postId.isNotEmpty) {
      // Navigate to journey detail page using the app router
      context.push('/journey/$postId');
    } else {
      // Show error if post ID is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open journey - missing post ID'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            _buildProfileInfo(),
            _buildStatsRow(),
            _buildMyPostsSection(),
          ],
        ),
      );
    } catch (e) {
      print('Error building UserProfilePage: $e');
      // Return a safe fallback UI instead of red error screen
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Profile', style: TextStyle(color: Colors.black)),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Unable to load profile',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Please try again later',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    try {
      return SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            children: [
              // Profile Picture
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildProfileAvatar(),
              ),

              const SizedBox(height: 16),

              // Name and Username
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (_userProfile['name']?.toString() ?? ''),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  // Status icons row
                  Row(
                    children: [
                      if (_userProfile['isVerified'] == true) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                      if (_userProfile['isPremium'] == true) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.workspace_premium,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                      if (_userProfile['isTripFluencer'] == true) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                (_userProfile['username']?.toString() ?? ''),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Trip Fluencer name tag
              if (_userProfile['isTripFluencer'] == true) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Trip Fluencer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Bio
              if (_userProfile['bio'] != null && _userProfile['bio'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    (_userProfile['bio']?.toString() ?? ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error building profile info: $e');
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text(
              'Unable to load profile information',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Follow/Following Button
        Expanded(
          child: GestureDetector(
            onTap: _toggleFollow,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _isFollowing ? Colors.grey[200] : Colors.blue,
                borderRadius: BorderRadius.circular(25),
                border: _isFollowing
                    ? Border.all(color: Colors.grey[300]!)
                    : null,
              ),
              child: Text(
                _isFollowing ? 'Following' : 'Follow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isFollowing ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Message Button
        Expanded(
          child: GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                'Message',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  
  Widget _buildStatsRow() {
    return SliverToBoxAdapter(
      child: _buildStatsCard(),
    );
  }

  Widget _buildStatsCard() {
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
      child: _isLoadingStats
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  ((_userStats['postsCount'] ?? _userPosts.length) ?? 0).toString(),
                  'Posts',
                  Icons.photo_library,
                  const Color(0xFF0088cc),
                ),
                _buildDivider(),
                GestureDetector(
                  onTap: () => _navigateToFollowersFollowing('followers'),
                  child: _buildStatItem(
                    _formatNumber(_userStats['followersCount'] as int?),
                    'Followers',
                    Icons.people,
                    const Color(0xFF00B894),
                  ),
                ),
                _buildDivider(),
                GestureDetector(
                  onTap: () => _navigateToFollowersFollowing('following'),
                  child: _buildStatItem(
                    ((_userStats['followingCount'] ?? 0) ?? 0).toString(),
                    'Following',
                    Icons.person_add,
                    const Color(0xFFE17055),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 22,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  void _navigateToFollowersFollowing(String type) {
    // Handle navigation to followers/following page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $type list'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMyPostsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'My Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildPostsList(),
        ],
      ),
    );
  }

  Widget _buildPostsList() {
    if (_isLoadingPosts) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(32, 32, 32, 112),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_userPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(32, 32, 32, 112),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'When they share travel posts, they\'ll appear here',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
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
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: (post['postImages'] != null && (post['postImages'] as List).isNotEmpty && (post['postImages'] as List)[0] != null)
                      ? GestureDetector(
                          onTap: () => _navigateToJourneyDetail(post),
                          child: _buildPostImage((post['postImages'] as List)[0]),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                ),
              ),

              // Post Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Title
                    Text(
                      (post['journeyTitle'] != null ? post['journeyTitle'].toString() : 'Unknown Location'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      (post['location'] != null ? post['location'].toString() : 'Explore this amazing destination'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // View Journey Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToJourneyDetail(post),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Journey',
                          style: TextStyle(
                            fontSize: 16,
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
    );
  }

  // Event Handlers
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _userStats['followersCount'] = (_userStats['followersCount'] ?? 0) + 1;
      } else {
        _userStats['followersCount'] = (_userStats['followersCount'] ?? 0) - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'Now following ${widget.userName.isNotEmpty ? widget.userName : 'User'}'
              : 'Unfollowed ${widget.userName.isNotEmpty ? widget.userName : 'User'}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage() {
    // Navigate to chat or show message composer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${widget.userName.isNotEmpty ? widget.userName : 'User'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

 

  
  // Helper method to build profile avatar
  Widget _buildProfileAvatar() {
    final profileImageUrl = _userProfile['profileImage']?.toString() ?? '';
    
    if (profileImageUrl.isEmpty) {
      return CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 45, color: Colors.grey[600]),
      );
    }
    
    print('Building profile avatar for: $profileImageUrl');
    
    // Handle different image types for profile
    if (profileImageUrl.startsWith('assets/')) {
      return CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: Image.asset(
            profileImageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile asset: $profileImageUrl - $error');
              return Icon(Icons.person, size: 45, color: Colors.grey[600]);
            },
          ),
        ),
      );
    } else if (profileImageUrl.startsWith('http://') || profileImageUrl.startsWith('https://')) {
      return CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: Image.network(
            profileImageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 90,
                height: 90,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile network image: $profileImageUrl - $error');
              return Icon(Icons.person, size: 45, color: Colors.grey[600]);
            },
          ),
        ),
      );
    } else {
      // Fallback for unknown image format
      return CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: 45, color: Colors.grey[600]),
      );
    }
  }

  // Helper method to build post images
  Widget _buildPostImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }
    
    print('Building image for path: $imagePath');
    
    // Handle different image types
    if (imagePath.startsWith('assets/')) {
      // Asset images from the app bundle
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading asset image: $imagePath - $error');
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      );
    } else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Network images
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $imagePath - $error');
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      );
    } else {
      // For any other format, just show placeholder
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }
  }

  // Helper method to build error image widget
  

  // Helper Methods
  String _formatNumber(int? number) {
    try {
      final safeNumber = number ?? 0;
      if (safeNumber >= 1000) {
        return '${(safeNumber / 1000).toStringAsFixed(1)}K';
      }
      return safeNumber.toString();
    } catch (e) {
      return '0';
    }
  }

  IconData _getBadgeIcon(String badge) {
    switch (badge.toLowerCase()) {
      case 'explorer':
        return Icons.explore;
      case 'trip fluencer':
        return Icons.trending_up;
      default:
        return Icons.emoji_events;
    }
  }
}