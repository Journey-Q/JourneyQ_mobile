import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BucketListPage extends StatefulWidget {
  const BucketListPage({super.key});

  @override
  State<BucketListPage> createState() => _BucketListPageState();
}

class _BucketListPageState extends State<BucketListPage> {
  // Updated bucket list data with journey IDs for routing
  final List<Map<String, dynamic>> bucketListItems = [
    {
      'destination': 'Mirissa Beach',
      'image': 'assets/images/mirissa_beach.jpg',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Whale watching and pristine golden beaches',
      'journeyId': '7' // Links to 'Mirissa Beach Paradise'
    },
    {
      'destination': 'Adams Peak (Sri Pada)',
      'image': 'assets/images/adams_peak.jpg',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Sacred mountain pilgrimage and sunrise hike',
      'journeyId': '8' // Links to 'Sacred Adams Peak Pilgrimage'
    },
    {
      'destination': 'Anuradhapura Ancient City',
      'image': 'assets/images/anuradhapura.jpeg',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'Ancient capital with sacred Buddhist sites',
      'journeyId': '9' // Links to 'Ancient Anuradhapura Heritage'
    },
    {
      'destination': 'Arugam Bay',
      'image': 'assets/images/arugam_bay.jpg',
      'isCompleted': false,
      'visitedDate': null,
      'description': 'World-class surfing destination on the east coast',
      'journeyId': '10' // Links to 'Arugam Bay Surf Paradise'
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
            surfaceTintColor: Colors.transparent,
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
                      const Icon(Icons.directions_bus, color: Colors.white, size: 28),
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
                    image: AssetImage(item['image']),
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
                      child: ElevatedButton(
                        onPressed: () => _viewJourney(item),
                        child: const Text('View journey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
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

  void _viewJourney(Map<String, dynamic> item) {
    // Navigate to journey details page using the journey ID
    final journeyId = item['journeyId'];
    if (journeyId != null) {
      context.push('/journey/$journeyId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journey details not available for ${item['destination']}')),
      );
    }
  }
}