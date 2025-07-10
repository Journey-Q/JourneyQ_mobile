import 'package:flutter/material.dart';
import 'package:journeyq/shared/components/bottom_naviagtion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool isSubscribed = false; // Track subscription status

  // Enhanced posts data with individual post information
  List<Map<String, dynamic>> userPosts = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'likes': 142,
      'comments': 23,
      'isLiked': false,
      'isSaved': false,
      'caption': 'Breathtaking mountain views at sunrise! Nature never fails to amaze me 🏔️',
      'location': 'Swiss Alps',
      'timestamp': '2 hours ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
      'likes': 89,
      'comments': 12,
      'isLiked': true,
      'isSaved': false,
      'caption': 'Lost in the beauty of this forest trail 🌲',
      'location': 'Black Forest, Germany',
      'timestamp': '5 hours ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
      'likes': 256,
      'comments': 45,
      'isLiked': false,
      'isSaved': true,
      'caption': 'Golden hour magic ✨ The perfect end to an incredible day',
      'location': 'Yosemite National Park',
      'timestamp': '1 day ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400',
      'likes': 78,
      'comments': 8,
      'isLiked': false,
      'isSaved': false,
      'caption': 'Adventure awaits in every corner 🎒',
      'location': 'Banff National Park',
      'timestamp': '2 days ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400',
      'likes': 167,
      'comments': 31,
      'isLiked': true,
      'isSaved': false,
      'caption': 'Ocean waves and endless horizons 🌊',
      'location': 'Maldives',
      'timestamp': '3 days ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
      'likes': 134,
      'comments': 19,
      'isLiked': false,
      'isSaved': true,
      'caption': 'Camping under the stars never gets old ⭐',
      'location': 'Joshua Tree National Park',
      'timestamp': '4 days ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
      'likes': 203,
      'comments': 27,
      'isLiked': false,
      'isSaved': false,
      'caption': 'Every sunset is a promise of a new dawn 🌅',
      'location': 'Santorini, Greece',
      'timestamp': '5 days ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
      'likes': 92,
      'comments': 15,
      'isLiked': true,
      'isSaved': false,
      'caption': 'Exploring hidden gems off the beaten path 🗺️',
      'location': 'Iceland',
      'timestamp': '1 week ago',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=400',
      'likes': 118,
      'comments': 21,
      'isLiked': false,
      'isSaved': true,
      'caption': 'The journey is the destination 🚗',
      'location': 'Route 66, USA',
      'timestamp': '1 week ago',
    },
  ];

  // Mock user data with updated post count
  final Map<String, dynamic> userData = {
    'name': 'Alex Johnson',
    'username': 'alexadventures',
    'bio': 'Travel enthusiast | Exploring the world 🌍\n✈️ 47 countries visited\n📸 Capturing moments',
    'posts': 9,
    'followers': 2847,
    'following': 312,
    'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'isVerified': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              pinned: false,
              title: Row(
                children: [
                  const Icon(Icons.lock_outline, color: Colors.black, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    userData['username'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (userData['isVerified'])
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    ),
                  if (isSubscribed)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, color: Colors.black),
                  onPressed: _showPostOptions,
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => context.push('/profile/settings'),
                ),
              ],
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildActionButtons(),
                  _buildPostsTabBar(),
                ],
              ),
            ),

            // Posts Grid
            _buildSliverPostsGrid(),
          ],
        ),
      ),
    );
  }

  // Profile Header Section
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Picture
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: userData['profileImage'] != null
                        ? NetworkImage(userData['profileImage'])
                        : null,
                    child: userData['profileImage'] == null
                        ? const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    )
                        : null,
                  ),
                  if (true) // Always show profile picture edit for own profile
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfilePicture,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),

              // Stats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(userPosts.length.toString(), 'Posts'),
                    GestureDetector(
                      onTap: () => _navigateToFollowersFollowing('followers'),
                      child: _buildStatColumn(userData['followers'].toString(), 'Followers'),
                    ),
                    GestureDetector(
                      onTap: () => _navigateToFollowersFollowing('following'),
                      child: _buildStatColumn(userData['following'].toString(), 'Following'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name and Bio
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData['bio'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          // Edit Profile Button
          Expanded(
            child: ElevatedButton(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Subscribe Button
          Expanded(
            child: ElevatedButton(
              onPressed: _handleSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubscribed ? Colors.amber : Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSubscribed ? Icons.star : Icons.star_outline,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isSubscribed ? 'Premium' : 'Subscribe',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Posts Grid Section
  Widget _buildPostsTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Posts grid is already shown by default
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Icon(Icons.grid_on, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _navigateToBucketList,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Icon(Icons.person_pin_outlined, color: Colors.grey),
              ),
            ),
          ),
          // Add like toggle button
          Expanded(
            child: GestureDetector(
              onTap: _showLikedPosts,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Icon(Icons.favorite_outline, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverPostsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final post = userPosts[index];
            return GestureDetector(
              onTap: () => _viewPost(index),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          childCount: userPosts.length,
        ),
      ),
    );
  }

  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.black),
                title: const Text('Camera', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.black),
                title: const Text('Gallery', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        userPosts.add({
          'imageUrl': image.path,
          'likes': 0,
          'comments': 0,
          'isLiked': false,
          'isSaved': false,
          'caption': 'New adventure captured!',
          'location': 'Unknown',
          'timestamp': 'now',
        });
        userData['posts'] = userPosts.length;
      });
    }
  }

  void _changeProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userData['profileImage'] = image.path;
      });
    }
  }

  // Navigation Methods
  void _editProfile() {
    context.push('/profile/edit', extra: userData);
  }

  void _handleSubscribe() {
    if (isSubscribed) {
      // Show subscription management
      _showSubscriptionManagement();
    } else {
      // Navigate to payment page
      context.push('/profile/payment', extra: userData);
    }
  }

  void _showSubscriptionManagement() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Premium Subscription',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'You currently have an active premium subscription with access to all premium features.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text('Manage Subscription', style: TextStyle(color: Colors.black)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening subscription management...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel Subscription', style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onTap: () {
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

  void _showCancelSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Cancel Subscription?',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to cancel your premium subscription? You will lose access to premium features.',
          style: TextStyle(color: Colors.black),
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
                const SnackBar(
                  content: Text('Subscription cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _viewPost(int index) {
    context.push('/profile/post/$index', extra: {
      'postData': userPosts[index],
      'userData': userData,
      'postIndex': index,
    });
  }

  void _navigateToBucketList() {
    context.push('/profile/bucketlist');
  }

  void _navigateToFollowersFollowing(String tab) {
    context.push('/profile/followers-following', extra: {
      'initialTab': tab,
      'userData': userData,
    });
  }

  void _showLikedPosts() {
    // Filter liked posts
    final likedPosts = userPosts.where((post) => post['isLiked'] == true).toList();
    
    if (likedPosts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No liked posts yet'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Liked Posts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: likedPosts.length,
                  itemBuilder: (context, index) {
                    final post = likedPosts[index];
                    final originalIndex = userPosts.indexOf(post);
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _viewPost(originalIndex);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(post['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}