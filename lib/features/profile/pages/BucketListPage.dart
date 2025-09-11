import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/bucket_list_repository/bucket_list_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BucketListPage extends StatefulWidget {
  const BucketListPage({super.key});

  @override
  State<BucketListPage> createState() => _BucketListPageState();
}

class _BucketListPageState extends State<BucketListPage> {
  List<Map<String, dynamic>> bucketListItems = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBucketList();
  }

  Future<void> _loadBucketList() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      
      final bucketListData = await BucketListRepository.getBucketList();
      
      if (bucketListData['bucketListItems'] != null && bucketListData['bucketListItems'] is List) {
        final bucketItems = bucketListData['bucketListItems'] as List;
        final List<Map<String, dynamic>> items = [];
        
        for (var item in bucketItems) {
          if (item is Map) {
            final itemData = Map<String, dynamic>.from(item);
            items.add({
              'id': itemData['journeyId']?.toString() ?? '',
              'destination': itemData['destination']?.toString() ?? 'Unknown Location',
              'image': itemData['image']?.toString() ?? 'assets/images/default_journey.jpg',
              'isCompleted': itemData['completed'] == true,
              'visitedDate': itemData['visitedDate']?.toString(),
              'description': itemData['description']?.toString() ?? '',
              'journeyId': itemData['journeyId']?.toString() ?? '',
            });
          }
        }
        
        setState(() {
          bucketListItems = items;
          _isLoading = false;
        });
      } else {
        setState(() {
          bucketListItems = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading bucket list: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load bucket list';
        _isLoading = false;
      });
    }
  }
  
  String _getImageUrl(Map<String, dynamic> postData) {
    if (postData['postImages'] != null && postData['postImages'] is List) {
      final images = postData['postImages'] as List;
      if (images.isNotEmpty) {
        final imageUrl = images[0].toString();
        if (imageUrl.startsWith('http')) {
          return imageUrl;
        }
      }
    }
    return 'assets/images/default_journey.jpg';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF33a3dd)),
          ),
        ),
      );
    }
    
    if (_hasError) {
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
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadBucketList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33a3dd),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    final completedItems = bucketListItems.where((item) => item['isCompleted']).length;
    final totalItems = bucketListItems.length;
    
    // Prevent division by zero
    final double progressValue = totalItems > 0 ? completedItems / totalItems : 0.0;
    final int progressPercentage = totalItems > 0 ? ((completedItems / totalItems) * 100).toInt() : 0;

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
                    value: progressValue,
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${progressPercentage}% Complete',
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
              child: bucketListItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items in your bucket list',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start exploring and add places you want to visit!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadBucketList,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: bucketListItems.length,
                        itemBuilder: (context, index) {
                          final item = bucketListItems[index];
                          return _buildBucketListItem(item, index);
                        },
                      ),
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: item['image'].toString().startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: item['image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF33a3dd)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                        )
                      : Image.asset(
                          item['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
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
                  onTap: () => _toggleCompleted(item, index),
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

  Future<void> _toggleCompleted(Map<String, dynamic> item, int index) async {
    try {
      final postId = item['id']?.toString();
      if (postId == null || postId.isEmpty) return;
      
      final newVisitedStatus = !item['isCompleted'];
      
      // Optimistic UI update
      setState(() {
        bucketListItems[index]['isCompleted'] = newVisitedStatus;
        if (newVisitedStatus) {
          bucketListItems[index]['visitedDate'] = DateTime.now().toString().split(' ')[0];
        } else {
          bucketListItems[index]['visitedDate'] = null;
        }
      });
      
      // Update backend
      await BucketListRepository.updateVisitedStatus(postId, newVisitedStatus);
    } catch (e) {
      print('Error updating visited status: $e');
      // Revert optimistic update on error
      setState(() {
        bucketListItems[index]['isCompleted'] = !bucketListItems[index]['isCompleted'];
        if (!bucketListItems[index]['isCompleted']) {
          bucketListItems[index]['visitedDate'] = null;
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update visited status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewJourney(Map<String, dynamic> item) {
    final postId = item['id']?.toString();
    if (postId != null && postId.isNotEmpty) {
      context.push('/journey/$postId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journey details not available for ${item['destination']}')),
      );
    }
  }
}