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

  // Dummy posts data
  List<String> userPosts = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
    'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400',
    'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
    'https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=400',
  ];

  // Mock user data with dummy content
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
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, color: Colors.black),
                  onPressed: _showPostOptions,
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () => _showSettingsMenu(context),
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
                    _buildStatColumn(userData['posts'].toString(), 'Posts'),
                    _buildStatColumn(userData['followers'].toString(), 'Followers'),
                    _buildStatColumn(userData['following'].toString(), 'Following'),
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
      child: SizedBox(
        width: double.infinity,
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
            return GestureDetector(
              onTap: () => _viewPost(index),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(userPosts[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: userPosts.length,
        ),
      ),
    );
  }

  // User Interaction Methods
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
        userPosts.add(image.path);
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

  void _showSettingsMenu(BuildContext context) {
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
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text('Settings and activity', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/profile/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.black),
                title: const Text('Your activity', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/profile/activity');
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code, color: Colors.black),
                title: const Text('QR code', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR code functionality')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.black),
                title: const Text('Archive', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Archive functionality')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigation Methods
  void _editProfile() {
    context.push('/profile/edit', extra: userData);
  }

  void _viewPost(int index) {
    context.push('/profile/post/$index', extra: {
      'imagePath': userPosts[index],
      'userData': userData,
    });
  }

  void _navigateToBucketList() {
    context.push('/profile/bucketlist');
  }
}