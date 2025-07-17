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

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  bool _isOwnProfile = false;

  // Mock user data - in a real app, this would come from an API
  late Map<String, dynamic> _userProfile;
  late List<Map<String, dynamic>> _userPosts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      'bio': 'Travel enthusiast exploring Sri Lanka\'s hidden gems 🇱🇰 | Food lover | Adventure seeker',
      'location': userData?['location']?.toString().split(' • ')[0] ?? 'Colombo, Sri Lanka',
      'profileImage': userData?['userImage'] ?? 'https://i.pravatar.cc/150?img=25',
      'coverImage': userData?['postImages']?[0] ?? 'assets/images/img1.jpg',
      'followers': 1247,
      'following': 892,
      'posts': 156,
      'journeys': 23,
      'countries': 12,
      'cities': 45,
      'joinedDate': 'January 2023',
      'isVerified': true,
      'badges': ['Explorer', 'Local Guide', 'Photographer'],
    };
  }

  void _loadUserPosts() {
    // Filter posts by user - in a real app, this would be an API call
    _userPosts = post_data
        .where((post) => post['userName']?.toString() == widget.userName)
        .toList();

    // Update profile stats based on actual posts
    if (_userPosts.isNotEmpty) {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          _buildTabBar(),
          _buildTabContent(),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: _showMoreOptions,
        ),
      ],
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
                    Icons.verified,
                    color: Colors.blue,
                    size: 20,
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

            const SizedBox(height: 16),

            // Location and Join Date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _userProfile['location'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Joined ${_userProfile['joinedDate']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
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
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('Posts', _userProfile['posts'].toString()),
            _buildStatItem('Followers', _formatNumber(_userProfile['followers'])),
            _buildStatItem('Following', _formatNumber(_userProfile['following'])),
            _buildStatItem('Journeys', _userProfile['journeys'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  icon: Icon(Icons.grid_on, size: 20),
                  text: 'Posts',
                ),
                Tab(
                  icon: Icon(Icons.map, size: 20),
                  text: 'Journeys',
                ),
                Tab(
                  icon: Icon(Icons.info_outline, size: 20),
                  text: 'About',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(),
          _buildJourneysTab(),
          _buildAboutTab(),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_userPosts.isEmpty) {
      return const Center(
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
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userPosts.length,
      itemBuilder: (context, index) {
        final post = _userPosts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TravelPostWidget(
            postId: post['id']?.toString() ?? '',
            userName: post['userName']?.toString() ?? '',
            location: post['location']?.toString() ?? '',
            userImage: post['userImage']?.toString() ?? '',
            journeyTitle: post['journeyTitle']?.toString() ?? '',
            placesVisited: List<String>.from(post['placesVisited'] ?? []),
            postImages: List<String>.from(post['postImages'] ?? []),
            likesCount: post['likesCount'] ?? 0,
            commentsCount: post['commentsCount'] ?? 0,
            isLiked: post['isLiked'] ?? false,
            isFollowed: _isFollowing,
            isBookmarked: false,
            onLike: () => _handleLike(post),
            onComment: () => _handleComment(post),
            onMoreOptions: () => _showPostOptions(post),
          ),
        );
      },
    );
  }

  Widget _buildJourneysTab() {
    // Mock journeys data
    final journeys = [
      {
        'title': 'Cultural Triangle Adventure',
        'duration': '5 days',
        'places': 8,
        'image': 'assets/images/img1.jpg',
        'date': '2024-01-15',
      },
      {
        'title': 'Southern Coast Explorer',
        'duration': '3 days',
        'places': 5,
        'image': 'assets/images/img12.jpg',
        'date': '2024-02-20',
      },
      {
        'title': 'Hill Country Tea Trail',
        'duration': '4 days',
        'places': 6,
        'image': 'assets/images/img14.jpg',
        'date': '2024-03-10',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        final journey = journeys[index];
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
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  journey['image']?.toString() ?? 'assets/images/img1.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journey['title']?.toString() ?? 'Unknown Journey',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          journey['duration']?.toString() ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${journey['places']?.toString() ?? '0'} places',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      journey['date']?.toString() ?? 'Unknown date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
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

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection('Travel Stats', [
            _buildAboutItem(Icons.public, 'Countries Visited', '${_userProfile['countries']}'),
            _buildAboutItem(Icons.location_city, 'Cities Explored', '${_userProfile['cities']}'),
            _buildAboutItem(Icons.route, 'Journeys Completed', '${_userProfile['journeys']}'),
          ]),

          const SizedBox(height: 24),

          _buildAboutSection('Favorite Destinations', [
            _buildDestinationItem('Sigiriya Rock Fortress', '5 visits'),
            _buildDestinationItem('Ella', '3 visits'),
            _buildDestinationItem('Galle Fort', '4 visits'),
          ]),

          const SizedBox(height: 24),

          _buildAboutSection('Travel Preferences', [
            _buildAboutItem(Icons.camera_alt, 'Photography', 'Enthusiast'),
            _buildAboutItem(Icons.hiking, 'Adventure Level', 'Moderate'),
            _buildAboutItem(Icons.restaurant, 'Food Explorer', 'Local Cuisine'),
          ]),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildAboutItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationItem(String destination, String visits) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.place, size: 20, color: Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              destination,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            visits,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
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
      case 'local guide':
        return Icons.location_on;
      case 'photographer':
        return Icons.camera_alt;
      default:
        return Icons.emoji_events;
    }
  }
}