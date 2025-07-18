import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/home/pages/travel_post_widget.dart';
import 'package:journeyq/features/home/data.dart';

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

  // Mock user data - in a real app, this would come from an API
  late Map<String, dynamic> _userProfile;
  late List<Map<String, dynamic>> _userPosts;

  @override
  void initState() {
    super.initState();
    print('UserProfilePage: Loading profile for ${widget.userName} (ID: ${widget.userId})');
    _loadUserProfile();
    _loadUserPosts();
    print('UserProfilePage: Profile image URL: ${_userProfile['profileImage']}');
  }

  void _loadUserProfile() {
    // Get the actual user data from post_data based on userName
    Map<String, dynamic>? userData;

    // Find the user's post data to get their profile image
    for (var post in post_data) {
      if (post['userName'] == widget.userName) {
        userData = post;
        break;
      }
    }

    // Mock profile data - replace with actual API call
    _userProfile = {
      'id': widget.userId,
      'name': widget.userName,
      'username': '@${widget.userName.toLowerCase().replaceAll(' ', '')}',
      'bio': 'Travel enthusiast exploring hidden gems 🌍 | Food lover | Adventure seeker',
      'location': userData?['location']?.toString().split(' • ')[0] ?? 'Location',
      'profileImage': userData?['userImage'] ?? 'https://i.pravatar.cc/150?img=25',
      'coverImage': userData?['postImages']?[0] ?? 'assets/images/img1.jpg',
      'followers': 1247,
      'following': 892,
      'posts': 156,
      'journeys': 23,
      'countries': 12,
      'cities': 45,
      'isVerified': true,
      'badges': ['Explorer', 'Trip Fluencer'],
    };
  }

  void _loadUserPosts() {
    // For now, always use mock posts to ensure we have 4 posts
    _userPosts = [
      {
        'id': '1',
        'location': 'Mirissa Beach, Southern Province',
        'journeyTitle': 'Stunning crescent-shaped beach famous for whale watching and surfing',
        'postImages': ['assets/images/mirissa_beach.jpg'],
      },
      {
        'id': '2',
        'location': 'Ella, Uva Province',
        'journeyTitle': 'Picturesque hill station with tea plantations and stunning viewpoints',
        'postImages': ['assets/images/ella_viewpoint.jpg'],
      },
      {
        'id': '3',
        'location': 'Kandy, Central Province',
        'journeyTitle': 'Cultural capital with the sacred Temple of the Tooth and beautiful lake',
        'postImages': ['assets/images/kandy_temple.jpeg'],
      },
      {
        'id': '4',
        'location': 'Galle Fort, Southern Province',
        'journeyTitle': 'Historic Dutch colonial fortress with charming cobblestone streets',
        'postImages': ['assets/images/galle_fort.jpg'],
      },
    ];

    // Update profile stats based on posts
    _userProfile['posts'] = _userPosts.length;

    // Calculate total likes and comments from user's posts
    int totalLikes = 0;
    int totalComments = 0;

    for (var post in _userPosts) {
      totalLikes += (post['likesCount'] as int?) ?? 0;
      totalComments += (post['commentsCount'] as int?) ?? 0;
    }

    // You can use these stats in the UI if needed
    _userProfile['totalLikes'] = totalLikes;
    _userProfile['totalComments'] = totalComments;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: CircleAvatar(
                radius: 45,
                backgroundImage: (_userProfile['profileImage'] != null &&
                    _userProfile['profileImage'].toString().isNotEmpty)
                    ? NetworkImage(_userProfile['profileImage'])
                    : null,
                backgroundColor: Colors.grey[300],
                onBackgroundImageError: (error, stackTrace) {
                  print('Error loading profile image: $error');
                },
                child: (_userProfile['profileImage'] == null ||
                    _userProfile['profileImage'].toString().isEmpty)
                    ? Icon(Icons.person, size: 45, color: Colors.grey[600])
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // Name and Username
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _userProfile['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (_userProfile['isVerified'] == true) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 18,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            Text(
              _userProfile['username'],
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 16),

            // Bio
            if (_userProfile['bio'] != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _userProfile['bio'],
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

            // Badges
            if (_userProfile['badges'] != null)
              _buildBadges(),
          ],
        ),
      ),
    );
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

  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Badges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (_userProfile['badges'] as List<String>).map((badge) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getBadgeIcon(badge),
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    badge,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            _userProfile['posts'].toString(),
            'Posts',
            Icons.photo_library,
            const Color(0xFF0088cc),
          ),
          _buildDivider(),
          GestureDetector(
            onTap: () => _navigateToFollowersFollowing('followers'),
            child: _buildStatItem(
              _formatNumber(_userProfile['followers']),
              'Followers',
              Icons.people,
              const Color(0xFF00B894),
            ),
          ),
          _buildDivider(),
          GestureDetector(
            onTap: () => _navigateToFollowersFollowing('following'),
            child: _buildStatItem(
              _userProfile['following'].toString(),
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
    if (_userPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: (post['postImages'] != null && (post['postImages'] as List).isNotEmpty)
                      ? Image.asset(
                    (post['postImages'] as List)[0],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
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
                      post['location']?.toString() ?? 'Unknown Location',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      post['journeyTitle']?.toString() ?? 'Explore this amazing destination',
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
                        onPressed: () {
                          // Handle view journey action
                          print('View journey for post: ${post['id']}');
                        },
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
        _userProfile['followers']++;
      } else {
        _userProfile['followers']--;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFollowing
              ? 'Now following ${widget.userName}'
              : 'Unfollowed ${widget.userName}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage() {
    // Navigate to chat or show message composer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${widget.userName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLike(Map<String, dynamic> post) {
    // Handle post like
    print('Liked post: ${post['id']}');
  }

  void _handleComment(Map<String, dynamic> post) {
    // Handle post comment
    print('Comment on post: ${post['id']}');
  }

  void _showPostOptions(Map<String, dynamic> post) {
    // Show post options
    print('More options for post: ${post['id']}');
  }

  void _showMoreOptions() {
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
              leading: const Icon(Icons.share),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report User'),
              onTap: () {
                Navigator.pop(context);
                _reportUser();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _blockUser();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User reported'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _blockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User blocked'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Helper Methods
  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
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