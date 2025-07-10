import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  // Mock followers data
  final List<Map<String, dynamic>> followers = [
    {
      'username': 'sarah_wanderlust',
      'name': 'Sarah Wilson',
      'profileImage': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
      'isFollowing': true,
      'isVerified': false,
      'bio': 'Adventure seeker | Mountain lover',
    },
    {
      'username': 'mike_explorer',
      'name': 'Mike Chen',
      'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'isFollowing': false,
      'isVerified': true,
      'bio': 'Travel photographer',
    },
    {
      'username': 'travel_jenny',
      'name': 'Jennifer Martinez',
      'profileImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      'isFollowing': true,
      'isVerified': false,
      'bio': 'Solo traveler | 32 countries',
    },
    {
      'username': 'outdoor_tom',
      'name': 'Tom Anderson',
      'profileImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'isFollowing': false,
      'isVerified': false,
      'bio': 'Hiking enthusiast',
    },
    {
      'username': 'wandering_anna',
      'name': 'Anna Rodriguez',
      'profileImage': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
      'isFollowing': true,
      'isVerified': true,
      'bio': 'Digital nomad | Food lover',
    },
  ];

  // Mock following data
  final List<Map<String, dynamic>> following = [
    {
      'username': 'natgeo',
      'name': 'National Geographic',
      'profileImage': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'isFollowing': true,
      'isVerified': true,
      'bio': 'Inspiring photos and stories',
    },
    {
      'username': 'lonely_planet',
      'name': 'Lonely Planet',
      'profileImage': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
      'isFollowing': true,
      'isVerified': true,
      'bio': 'Travel guides and inspiration',
    },
    {
      'username': 'backpacker_life',
      'name': 'Backpacker Magazine',
      'profileImage': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
      'isFollowing': true,
      'isVerified': false,
      'bio': 'Outdoor adventures',
    },
    {
      'username': 'mountain_guide',
      'name': 'Alex Mountain Guide',
      'profileImage': 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400',
      'isFollowing': true,
      'isVerified': false,
      'bio': 'Professional mountain guide',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == 'following' ? 1 : 0,
    );
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userData['username'],
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
            Tab(text: '${followers.length} Followers'),
            Tab(text: '${following.length} Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(followers),
          _buildUserList(following),
        ],
      ),
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserItem(user);
      },
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(user['profileImage']),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['username'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user['isVerified'])
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                Text(
                  user['name'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                if (user['bio'] != null)
                  Text(
                    user['bio'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Follow/Following Button
          _buildFollowButton(user),
        ],
      ),
    );
  }

  Widget _buildFollowButton(Map<String, dynamic> user) {
    return SizedBox(
      width: 100,
      height: 32,
      child: ElevatedButton(
        onPressed: () => _toggleFollow(user),
        style: ElevatedButton.styleFrom(
          backgroundColor: user['isFollowing'] ? Colors.grey[200] : Colors.blue,
          foregroundColor: user['isFollowing'] ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          user['isFollowing'] ? 'Following' : 'Follow',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _toggleFollow(Map<String, dynamic> user) {
    setState(() {
      user['isFollowing'] = !user['isFollowing'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user['isFollowing'] 
            ? 'Started following ${user['username']}' 
            : 'Unfollowed ${user['username']}',
        ),
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 1),
      ),
    );
  }
}