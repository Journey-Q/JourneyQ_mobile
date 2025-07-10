import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BucketListPage extends StatefulWidget {
  const BucketListPage({super.key});

  @override
  State<BucketListPage> createState() => _BucketListPageState();
}

class _BucketListPageState extends State<BucketListPage> {
  // Sample bucket list data with Sri Lankan destinations
  final List<Map<String, dynamic>> bucketListItems = [
    {
      'destination': 'Sigiriya Rock Fortress',
      'image': 'https://images.unsplash.com/photo-1568632234157-ce7aecd03d0d?w=400',
      'isCompleted': true,
      'visitedDate': '2023-08-15',
      'description': 'Ancient rock fortress and UNESCO World Heritage site'
    },
    {
      'destination': 'Nine Arch Bridge, Ella',
      'image': 'https://images.unsplash.com/photo-1566552881560-0be862a7c445?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Iconic railway bridge surrounded by tea plantations'
    },
    {
      'destination': 'Temple of the Tooth, Kandy',
      'image': 'https://images.unsplash.com/photo-1605649487212-47bdab064bf4?w=400',
      'isCompleted': true,
      'visitedDate': '2023-12-20',
      'description': 'Sacred Buddhist temple housing the tooth relic of Buddha'
    },
    {
      'destination': 'Galle Fort',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Historic Dutch colonial fort by the ocean'
    },
    {
      'destination': 'Yala National Park',
      'image': 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Wildlife safari to spot leopards and elephants'
    },
    {
      'destination': 'Nuwara Eliya Tea Country',
      'image': 'https://images.unsplash.com/photo-1605649487108-8e1e9eab5a0e?w=400',
      'isCompleted': true,
      'visitedDate': '2023-07-10',
      'description': 'Rolling tea plantations in the hill country'
    },
    {
      'destination': 'Mirissa Beach',
      'image': 'https://images.unsplash.com/photo-1540979388789-6cee28a1cdc9?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Whale watching and pristine golden beaches'
    },
    {
      'destination': 'Adams Peak (Sri Pada)',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Sacred mountain pilgrimage and sunrise hike'
    },
    {
      'destination': 'Anuradhapura Ancient City',
      'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Ancient capital with sacred Buddhist sites'
    },
    {
      'destination': 'Arugam Bay',
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'World-class surfing destination on the east coast'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final completedItems = bucketListItems.where((item) => item['isCompleted']).length;
    final totalItems = bucketListItems.length;

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
          'Travel Bucket List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        )
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trip Planning Progress',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$completedItems of $totalItems destinations visited',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: completedItems / totalItems,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((completedItems / totalItems) * 100).toInt()}% Complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Bucket List Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: bucketListItems.length,
              itemBuilder: (context, index) {
                final item = bucketListItems[index];
                return _buildBucketListItem(item, index);
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _buildBucketListItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and status
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(item['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (item['isCompleted'])
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '✓ Visited',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                left: 12,
                child: GestureDetector(
                  onTap: () => _toggleCompleted(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['isCompleted'] ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: item['isCompleted'] ? Colors.green : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['destination'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (item['isCompleted'] && item['visitedDate'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Visited: ${item['visitedDate']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _planRoute(item),
                        label: const Text('View journey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _shareDestination(item),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                      
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompleted(int index) {
    setState(() {
      bucketListItems[index]['isCompleted'] = !bucketListItems[index]['isCompleted'];
      if (bucketListItems[index]['isCompleted']) {
        bucketListItems[index]['visitedDate'] = DateTime.now().toString().split(' ')[0];
      } else {
        bucketListItems[index]['visitedDate'] = null;
      }
    });
  }

  

  

  void _planRoute(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Planning route to ${item['destination']}')),
    );
  }

  void _shareDestination(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${item['destination']}')),
    );
  }
}