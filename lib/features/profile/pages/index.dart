import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/features/journey_view/data.dart'; // Import journey data

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

  // Transform journey data to user posts format
  List<Map<String, dynamic>> get userPosts {
    return journeyDetailsData.map((journey) {
      // Get the first place and its first image for the post
      final places = journey['places'] as List;
      final firstPlace = places.isNotEmpty ? places.first : null;
      final images = firstPlace?['images'] as List<String>? ?? [];
      final firstImage = images.isNotEmpty ? images.first : 'assets/images/placeholder.jpg';
      
      // Generate consistent engagement numbers based on journey ID
      final likes = 50 + (journey['id'].hashCode % 200);
      final comments = 5 + (journey['id'].hashCode % 30);
      
      return {
        'imageUrl': firstImage,
        'likes': likes,
        'comments': comments,
        'isLiked': (journey['id'].hashCode % 3) == 0, // Consistent liked status
        'isSaved': (journey['id'].hashCode % 4) == 0, // Consistent saved status
        'caption': journey['tripTitle'],
        'location': firstPlace?['name'] ?? 'Unknown Location',
        'destination': journey['tripTitle'],
        'description': firstPlace != null 
            ? 'Explore ${firstPlace['name']} - ${journey['totalDays']} days journey'
            : 'Amazing ${journey['totalDays']}-day journey',
        'timestamp': _getRandomTimestamp(journey['id']),
        'isVisited': true,
        'visitDate': _getRandomVisitDate(journey['id']),
        'journeyId': journey['id'], // Add journey ID for routing
      };
    }).toList();
  }

  // Helper method to generate consistent timestamps
  String _getRandomTimestamp(String journeyId) {
    final timestamps = ['2 hours ago', '5 hours ago', '1 day ago', '2 days ago', '3 days ago', '4 days ago', '5 days ago', '1 week ago'];
    return timestamps[journeyId.hashCode % timestamps.length];
  }

  // Helper method to generate consistent visit dates
  String _getRandomVisitDate(String journeyId) {
    final dates = ['2024-06-15', '2024-06-10', '2024-06-08', '2024-06-05', '2024-06-01', '2024-05-28', '2024-05-25', '2024-05-20', '2024-05-15'];
    return dates[journeyId.hashCode % dates.length];
  }

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
        'bio': _profileData!['bio'] ?? 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ ${journeyDetailsData.length} amazing journeys completed',
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
        'bio': 'Travel enthusiast | Exploring Sri Lanka 🇱🇰\n✈️ ${journeyDetailsData.length} amazing journeys completed',
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
                const SizedBox(height: 10), // Space for bottom navigation
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
                    fontSize: 14,
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

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "My Journeys" title
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
  // Calculate posts starting from index 7
  final postsFromIndex7 = userPosts.length > 7 
      ? userPosts.sublist(7) 
      : <Map<String, dynamic>>[];
  
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: postsFromIndex7.length,
      itemBuilder: (context, index) {
        final post = postsFromIndex7[index];
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
              // Image
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
                    // View Journey button with ID-based routing
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

  // Updated navigation method for ID-based routing
  void _viewJourney(Map<String, dynamic> post) {
    final journeyId = post['journeyId'];
    if (journeyId != null) {
      context.push('/journey/$journeyId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journey details not available for ${post['destination']}')),
      );
    }
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