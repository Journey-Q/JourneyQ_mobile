import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock activity data
  final List<Map<String, dynamic>> activities = [
    {
      'type': 'like',
      'user': 'john_traveler',
      'userImage': null,
      'action': 'liked your photo',
      'time': '2h',
      'postImage': null,
      'isFollowing': false,
    },
    {
      'type': 'follow',
      'user': 'sarah_adventures',
      'userImage': null,
      'action': 'started following you',
      'time': '4h',
      'postImage': null,
      'isFollowing': false,
    },
    {
      'type': 'comment',
      'user': 'mike_explorer',
      'userImage': null,
      'action': 'commented: "Amazing view! 😍"',
      'time': '6h',
      'postImage': null,
      'isFollowing': true,
    },
    {
      'type': 'like',
      'user': 'travel_enthusiast',
      'userImage': null,
      'action': 'liked your photo',
      'time': '1d',
      'postImage': null,
      'isFollowing': false,
    },
  ];

  final List<Map<String, dynamic>> followRequests = [
    {
      'user': 'new_traveler123',
      'userImage': null,
      'mutualFriends': 3,
      'isPending': true,
    },
    {
      'user': 'adventure_seeker',
      'userImage': null,
      'mutualFriends': 1,
      'isPending': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text(
          'Activity',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Follow requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllActivityTab(),
          _buildFollowRequestsTab(),
        ],
      ),
    );
  }

  Widget _buildAllActivityTab() {
    if (activities.isEmpty) {
      return _buildEmptyState(
        'No activity yet',
        'When someone likes or comments on your posts, you\'ll see it here.',
      );
    }

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityItem(activity);
      },
    );
  }

  Widget _buildFollowRequestsTab() {
    if (followRequests.isEmpty) {
      return _buildEmptyState(
        'No follow requests',
        'When someone requests to follow you, you\'ll see it here.',
      );
    }

    return Column(
      children: [
        if (followRequests.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${followRequests.length} requests',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllRequests,
                  child: const Text(
                    'Clear all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: followRequests.length,
            itemBuilder: (context, index) {
              final request = followRequests[index];
              return _buildFollowRequestItem(request, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // User profile picture
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: activity['userImage'] != null
                ? AssetImage(activity['userImage'])
                : null,
            child: activity['userImage'] == null
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          const SizedBox(width: 12),

          // Activity text
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: activity['user'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${activity['action']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${activity['time']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action button or post image
          if (activity['type'] == 'follow' && !activity['isFollowing'])
            ElevatedButton(
              onPressed: () => _followUser(activity['user']),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Follow', style: TextStyle(fontSize: 12)),
            )
          else if (activity['postImage'] != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[300],
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestItem(Map<String, dynamic> request, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // User profile picture
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: request['userImage'] != null
                ? AssetImage(request['userImage'])
                : null,
            child: request['userImage'] == null
                ? const Icon(Icons.person, color: Colors.grey, size: 25)
                : null,
          ),
          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['user'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (request['mutualFriends'] > 0)
                  Text(
                    '${request['mutualFriends']} mutual friends',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // Action buttons
          if (request['isPending']) ...[
            ElevatedButton(
              onPressed: () => _acceptRequest(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Accept', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _declineRequest(index),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Decline', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 40,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _followUser(String username) {
    setState(() {
      // Find and update the activity
      final activityIndex = activities.indexWhere((activity) =>
      activity['user'] == username && activity['type'] == 'follow');
      if (activityIndex != -1) {
        activities[activityIndex]['isFollowing'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You are now following $username')),
    );
  }

  void _acceptRequest(int index) {
    setState(() {
      followRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow request accepted')),
    );
  }

  void _declineRequest(int index) {
    setState(() {
      followRequests.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow request declined')),
    );
  }

  void _clearAllRequests() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Clear all requests?',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'This will remove all pending follow requests.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                followRequests.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All requests cleared')),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}