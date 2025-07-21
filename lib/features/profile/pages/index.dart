import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/core/errors/exception.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool isSubscribed = false;
  String selectedTab = 'posts'; // 'posts', 'bucketlist', 'liked'

  // Loading and data states
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String? _userId;

  // Enhanced posts data with Sri Lankan travel destination information
  List<Map<String, dynamic>> userPosts = [
    {
      'imageUrl': 'assets/images/mirissa_beach.jpg',
      'likes': 142,
      'comments': 23,
      'isLiked': false,
      'isSaved': false,
      'caption':
          'Paradise found in Mirissa! Crystal clear waters and golden beaches 🏖️',
      'location': 'Mirissa Beach',
      'destination': 'Mirissa Beach, Southern Province',
      'description':
          'Stunning crescent-shaped beach famous for whale watching and surfing',
      'timestamp': '2 hours ago',
      'isVisited': true,
      'visitDate': '2024-06-15',
    },
    {
      'imageUrl': 'assets/images/ella_viewpoint.jpg',
      'likes': 89,
      'comments': 12,
      'isLiked': true,
      'isSaved': false,
      'caption': 'Lost in the misty mountains of Ella! Nature at its finest 🌲',
      'location': 'Ella',
      'destination': 'Ella, Uva Province',
      'description':
          'Picturesque hill station with tea plantations and stunning viewpoints',
      'timestamp': '5 hours ago',
      'isVisited': true,
      'visitDate': '2024-06-10',
    },
    {
      'imageUrl': 'assets/images/sigiriya_rock.jpg',
      'likes': 256,
      'comments': 45,
      'isLiked': false,
      'isSaved': true,
      'caption':
          'Golden hour magic at Sigiriya! Ancient fortress rising from the jungle ✨',
      'location': 'Sigiriya',
      'destination': 'Sigiriya Rock Fortress, Central Province',
      'description': '5th-century rock fortress and UNESCO World Heritage site',
      'timestamp': '1 day ago',
      'isVisited': true,
      'visitDate': '2024-06-08',
    },
    {
      'imageUrl': 'assets/images/horton_plains.jpg',
      'likes': 78,
      'comments': 8,
      'isLiked': false,
      'isSaved': false,
      'caption':
          'Adventure awaits in Horton Plains! Edge of the world views 🎒',
      'location': 'Horton Plains',
      'destination': 'Horton Plains National Park, Central Province',
      'description':
          'High-altitude plateau with dramatic cliff formations and endemic wildlife',
      'timestamp': '2 days ago',
      'isVisited': true,
      'visitDate': '2024-06-05',
    },
    {
      'imageUrl': 'assets/images/adams_peak.jpg',
      'likes': 167,
      'comments': 31,
      'isLiked': true,
      'isSaved': false,
      'caption': 'Sunrise over Adams Peak! Spiritual journey to the top 🌅',
      'location': 'Adams Peak',
      'destination': 'Sri Pada (Adams Peak), Sabaragamuwa Province',
      'description':
          'Sacred mountain and pilgrimage site with breathtaking sunrise views',
      'timestamp': '3 days ago',
      'isVisited': true,
      'visitDate': '2024-06-01',
    },
    {
      'imageUrl': 'assets/images/yala_national_park.jpg',
      'likes': 134,
      'comments': 19,
      'isLiked': false,
      'isSaved': true,
      'caption': 'Camping under the stars in Yala! Wildlife paradise 🦎',
      'location': 'Yala National Park',
      'destination': 'Yala National Park, Southern Province',
      'description':
          'Premier wildlife destination famous for leopards and diverse ecosystems',
      'timestamp': '4 days ago',
      'isVisited': true,
      'visitDate': '2024-05-28',
    },
    {
      'imageUrl': 'assets/images/galle_fort.jpg',
      'likes': 203,
      'comments': 27,
      'isLiked': false,
      'isSaved': false,
      'caption':
          'Every sunset is magical in Galle! Colonial charm meets ocean views 🌅',
      'location': 'Galle Fort',
      'destination': 'Galle Fort, Southern Province',
      'description':
          'Historic Dutch colonial fort with cobblestone streets and ocean views',
      'timestamp': '5 days ago',
      'isVisited': true,
      'visitDate': '2024-05-25',
    },
    {
      'imageUrl': 'assets/images/kandy_temple.jpeg',
      'likes': 92,
      'comments': 15,
      'isLiked': true,
      'isSaved': false,
      'caption':
          'Exploring the cultural heart of Kandy! Temple of the Tooth 🏛️',
      'location': 'Kandy',
      'destination': 'Kandy, Central Province',
      'description':
          'Ancient royal capital and spiritual center with the sacred Temple of the Tooth',
      'timestamp': '1 week ago',
      'isVisited': true,
      'visitDate': '2024-05-20',
    },
    {
      'imageUrl': 'assets/images/nuwara_eliya.jpeg',
      'likes': 118,
      'comments': 21,
      'isLiked': false,
      'isSaved': true,
      'caption':
          'The journey through tea country is magical! Nuwara Eliya vibes 🚂',
      'location': 'Nuwara Eliya',
      'destination': 'Nuwara Eliya, Central Province',
      'description':
          'Cool climate hill station known as "Little England" with tea plantations',
      'timestamp': '1 week ago',
      'isVisited': true,
      'visitDate': '2024-05-15',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is ready
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

      // Get profile data from repository
      final profileData = await ProfileRepository.getProfile(_userId!);
      print("Profile data loaded: $profileData");

      setState(() {
        _profileData = profileData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        _isLoading = false;
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

  // Get user data combining profile data and auth data
  Map<String, dynamic> _getUserData(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authUser = authProvider.user;

    if (_profileData != null) {
      // Use loaded profile data
      return {
        'name': _profileData!['display_name'] ?? authUser?.username ?? 'Unknown User',
        'username': authUser?.username ?? 'unknown_user',
        'bio': _profileData!['bio'] ?? 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ 8 districts visited',
        'posts': userPosts.length,
        'followers': 5, // This would come from a separate API in a real app
        'following': 4,  // This would come from a separate API in a real app
        'profileImage': _profileData!['profile_image_url'] ?? authUser?.profileUrl ?? 'assets/images/profile_picture.jpg',
        'isVerified': true,
        'level': 'Explorer',
        'joinDate': 'March 2022',
        'achievements': ['Mountain Climber', 'Ocean Explorer', 'City Wanderer'],
        'activities': _profileData!['favourite_activities'] ?? [],
        'tripMoods': _profileData!['preferred_trip_moods'] ?? [],
      };
    } else {
      // Fallback to auth user data
      return {
        'name': authUser?.username ?? 'Unknown User',
        'username': authUser?.username ?? 'unknown_user',
        'bio': 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ 8 districts visited',
        'posts': userPosts.length,
        'followers': 5,
        'following': 4,
        'profileImage': authUser?.profileUrl ?? 'assets/images/profile_picture.jpg',
        'isVerified': true,
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
    // Show loading screen while profile is loading
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
                const SizedBox(height: 100), // Space for bottom navigation
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
          // Left side - Username
          Container(
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
                Text(
                  userData['username'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Color(0xFF2D3436),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
          
          const Spacer(),
          
          // Right side - Subscribe + Settings buttons
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
                    size: 12,
                  ),
                  label: Text(isSubscribed ? 'Premium' : 'Subscribe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
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
              const SizedBox(width: 12), // Proper gap between buttons
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
        iconSize: 22,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final userData = _getUserData(context);

    // Helper function to determine image provider
    ImageProvider? _getImageProvider(String? imagePath) {
      if (imagePath == null) return null;

      // Check if it's a URL (starts with http or https)
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return NetworkImage(imagePath);
      } else {
        // Treat as asset path
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
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
            userPosts.length.toString(),
            'Posts',
            Icons.photo_library,
            const Color(0xFF0088cc),
          ),
          _buildDivider(),
          GestureDetector(
            onTap: () => _navigateToFollowersFollowing('followers'),
            child: _buildStatItem(
              _formatNumber(userData['followers'] ?? 0),
              'Followers',
              Icons.people,
              const Color(0xFF00B894),
            ),
          ),
          _buildDivider(),
          GestureDetector(
            onTap: () => _navigateToFollowersFollowing('following'),
            child: _buildStatItem(
              (userData['following'] ?? 0).toString(),
              'Following',
              Icons.person_add,
              const Color(0xFFE17055),
            ),
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
  ) {
    return Column(
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

  Widget _buildTabSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(children: [_buildTabItem('posts', 'Posts', Icons.grid_view)]),
    );
  }

  Widget _buildTabItem(String tabId, String label, IconData icon) {
    final isSelected = selectedTab == tabId;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectTab(tabId),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0088cc) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF636E72),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF636E72),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "My Posts" title
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            'My Posts',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          final post = userPosts[index];
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
                // Image without likes and visited label
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(post['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Content
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
                      // Only View Journey button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _viewPost(index),
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

  Widget _buildBucketListView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
            child: const Column(
              children: [
                Icon(Icons.bookmark_border, size: 48, color: Color(0xFF636E72)),
                SizedBox(height: 16),
                Text(
                  'Bucket List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your travel bucket list is empty.\nStart adding places you want to visit!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF636E72), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedPostsGrid() {
    final likedPosts = userPosts
        .where((post) => post['isLiked'] == true)
        .toList();

    if (likedPosts.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
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
          child: const Column(
            children: [
              Icon(Icons.favorite_border, size: 48, color: Color(0xFF636E72)),
              SizedBox(height: 16),
              Text(
                'No Liked Posts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Posts you like will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF636E72), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: likedPosts.length,
        itemBuilder: (context, index) {
          final post = likedPosts[index];
          final originalIndex = userPosts.indexOf(post);
          return GestureDetector(
            onTap: () => _viewPost(originalIndex),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(post['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.favorite, color: Colors.red, size: 20),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post['location'] != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    post['location'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          Text(
                            post['timestamp'] ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  void _selectTab(String tabId) {
    setState(() {
      selectedTab = tabId;
    });
  }

  void _showPostOptions() {
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
              const Text(
                'Add New Post',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 20),
              _buildPostOption(
                Icons.camera_alt,
                'Camera',
                'Take a new photo',
                const Color(0xFF0088cc),
                () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _buildPostOption(
                Icons.photo_library,
                'Gallery',
                'Choose from gallery',
                const Color(0xFF00B894),
                () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostOption(
    IconData icon,
    String title,
    String subtitle,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        userPosts.insert(0, {
          'imageUrl': image.path,
          'likes': 0,
          'comments': 0,
          'isLiked': false,
          'isSaved': false,
          'caption': 'New adventure captured!',
          'location': 'Unknown',
          'destination': 'New Destination',
          'description': 'A new place to explore',
          'timestamp': 'now',
          'isVisited': true,
          'visitDate': DateTime.now().toString().substring(0, 10),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New post added!'),
          backgroundColor: const Color(0xFF00B894),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _changeProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Note: In a real app, you would update this in the AuthProvider
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile picture updated!'),
          backgroundColor: const Color(0xFF0088cc),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Navigation Methods
  void _editProfile() {
    final userData = _getUserData(context);
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

  void _viewPost(int index) {
    final userData = _getUserData(context);
    context.push(
      '/profile/post/$index',
      extra: {
        'postData': userPosts[index],
        'userData': userData,
        'postIndex': index,
      },
    );
  }

  void _navigateToBucketList() {
    context.push('/profile/bucketlist');
  }

  void _navigateToFollowersFollowing(String tab) {
    final userData = _getUserData(context);
    context.push(
      '/profile/followers-following',
      extra: {'initialTab': tab, 'userData': userData},
    );
  }
}