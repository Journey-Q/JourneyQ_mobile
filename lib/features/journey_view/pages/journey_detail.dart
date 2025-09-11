import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/data/repositories/post_repository/post_repository.dart';
import 'package:journeyq/data/repositories/bucket_list_repository/bucket_list_repository.dart';
// Update this import to use the enhanced map widget
// import 'package:journeyq/features/journey_view/pages/Journeyroute.dart';
import 'package:journeyq/features/journey_view/pages/journeyroute.dart'; 

class JourneyDetailsPage extends StatefulWidget {
  final String postId; // Changed from journeyId to postId for clarity
  final String? googleMapsApiKey; // Add API key parameter

  const JourneyDetailsPage({
    super.key, 
    required this.postId,
    this.googleMapsApiKey,
  });

  @override
  State<JourneyDetailsPage> createState() => _JourneyDetailsPageState();
}

class _JourneyDetailsPageState extends State<JourneyDetailsPage> {
  Map<String, dynamic>? journeyData;
  Map<String, int> _currentImageIndexes = {};
  Map<String, PageController> _pageControllers = {};

  // Add controllers for places pagination
  final PageController _placesPageController = PageController();
  int _currentPlaceIndex = 0;

  // Interaction state variables
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likesCount = 0;
  int _commentsCount = 0;
  List<Map<String, dynamic>> _comments = [];
  
  // Bucket list state
  bool _isInBucketList = false;
  
  // Loading states
  bool _isLoadingPost = true;
  bool _isLoadingLikes = true;
  bool _isLoadingComments = true;
  bool _postNotFound = false;
  
  // Timer for auto-refreshing comments
  Timer? _commentsTimer;
  
  // ValueNotifier to communicate with comments bottom sheet
  ValueNotifier<List<Map<String, dynamic>>>? _commentsNotifier;
  
  // Direct access to postId
  String get postId => widget.postId;

  // Default API key - replace with your actual API key
  static const String _defaultApiKey = "AIzaSyCFbprhDc_fKXUHl-oYEVGXKD1HciiAsz0";

  @override
  void initState() {
    super.initState();
    _loadJourneyData();
    _loadLikeStatus();
    _loadComments();
    _loadBucketListStatus();
    _startCommentsPolling();
  }

  @override
  void dispose() {
    _pageControllers.values.forEach((controller) => controller.dispose());
    _placesPageController.dispose();
    _commentsTimer?.cancel();
    _commentsNotifier?.dispose();
    super.dispose();
  }

  Future<void> _loadJourneyData() async {
    try {
      setState(() {
        _isLoadingPost = true;
        _postNotFound = false;
      });

      final postData = await PostRepository.getPostDetails(postId);
      
      setState(() {
        journeyData = _mapPostDataToJourneyData(postData);
        _isLoadingPost = false;
        _postNotFound = false;
      });
    } catch (e) {
      print('Error loading journey data: $e');
      setState(() {
        _isLoadingPost = false;
        _postNotFound = true;
      });
    }
  }

  Future<void> _loadLikeStatus() async {
    try {
      setState(() {
        _isLoadingLikes = true;
      });

      final likeData = await PostRepository.getLikeStatus(postId);
      
      setState(() {
        _isLiked = likeData['isLiked'] ?? false;
        _likesCount = likeData['likesCount'] ?? 0;
        _isLoadingLikes = false;
      });
    } catch (e) {
      print('Error loading like status: $e');
      setState(() {
        _isLoadingLikes = false;
      });
    }
  }

  void _startCommentsPolling() {
    _commentsTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _loadComments();
      }
    });
  }

  Future<void> _loadComments() async {
    try {
      setState(() {
        _isLoadingComments = true;
      });

      final commentsResponse = await PostRepository.getComments(postId);
      final commentsCount = await PostRepository.getCommentsCount(postId);
      
      // Map the backend response to UI format
      final mappedComments = commentsResponse.map<Map<String, dynamic>>((commentItem) {
        final comment = commentItem is Map ? Map<String, dynamic>.from(commentItem) : <String, dynamic>{};
        final repliesList = comment['replies'] as List? ?? [];
        
        return {
          'id': comment['commentId']?.toString() ?? '',
          'userName': comment['username']?.toString() ?? 'Unknown User',
          'userImage': comment['userProfileUrl']?.toString() ?? '',
          'comment': comment['commentText']?.toString() ?? '',
          'timeAgo': _formatTimeAgo(comment['commentedAt']?.toString()),
          'likesCount': 0, // Backend doesn't provide this yet
          'isLiked': false, // Backend doesn't provide this yet
          'replies': repliesList.map<Map<String, dynamic>>((replyItem) {
            final reply = replyItem is Map ? Map<String, dynamic>.from(replyItem) : <String, dynamic>{};
            return {
              'id': reply['commentId']?.toString() ?? '',
              'userName': reply['username']?.toString() ?? 'Unknown User',
              'userImage': reply['userProfileUrl']?.toString() ?? '',
              'comment': reply['commentText']?.toString() ?? '',
              'timeAgo': _formatTimeAgo(reply['commentedAt']?.toString()),
              'likesCount': 0,
              'isLiked': false,
            };
          }).toList(),
        };
      }).toList();
      
      setState(() {
        _comments = mappedComments;
        _commentsCount = commentsCount;
        _isLoadingComments = false;
      });
      
      // Notify the comments bottom sheet to update if it's open
      _commentsNotifier?.value = _comments;
    } catch (e) {
      print('Error loading comments: $e');
      setState(() {
        _isLoadingComments = false;
      });
    }
  }

  Map<String, dynamic> _mapPostDataToJourneyData(Map<String, dynamic> postData) {
    // Map the backend post data to the format expected by the UI
    final placeWiseContent = postData['placeWiseContent'] as List? ?? [];
    final budgetInfo = postData['budgetInfo'] is Map 
        ? Map<String, dynamic>.from(postData['budgetInfo'] as Map) 
        : <String, dynamic>{};
    
    return {
      'id': postData['postId']?.toString() ?? postId,
      'tripTitle': postData['journeyTitle']?.toString() ?? 'Unknown Journey',
      'authorName': postData['creatorUsername']?.toString() ?? 'Unknown Author',
      'authorImage': postData['creatorProfileUrl']?.toString() ?? '',
      'totalDays': postData['numberOfDays'] ?? 1,
      'totalBudget': budgetInfo['totalBudget'] ?? 0,
      'places': placeWiseContent.map((place) {
        final placeMap = place is Map ? Map<String, dynamic>.from(place) : <String, dynamic>{};
        final activities = placeMap['activities'] as List? ?? [];
        final experiences = placeMap['experiences'] as List? ?? [];
        final images = placeMap['imageUrls'] as List? ?? [];
        
        return {
          'name': placeMap['placeName']?.toString() ?? '',
          'trip_mood': placeMap['tripMood']?.toString() ?? '',
          'activities': activities.map((activity) => activity.toString()).toList(),
          'experiences': experiences.map((exp) => {
            'description': exp.toString(),
          }).toList(),
          'images': images.map((img) => img.toString()).toList(),
          'location': {
            'latitude': placeMap['latitude'],
            'longitude': placeMap['longitude'],
            'address': placeMap['address']?.toString() ?? '',
          },
          'latitude': placeMap['latitude'], // Keep for backward compatibility
          'longitude': placeMap['longitude'], // Keep for backward compatibility
          'address': placeMap['address']?.toString() ?? '',
        };
      }).toList(),
      'overallRecommendations': {
        'hotels': (postData['hotelRecommendations'] as List? ?? []).map((hotel) =>
          hotel is Map ? Map<String, dynamic>.from(hotel) : <String, dynamic>{}
        ).toList(),
        'restaurants': (postData['restaurantRecommendations'] as List? ?? []).map((restaurant) =>
          restaurant is Map ? Map<String, dynamic>.from(restaurant) : <String, dynamic>{}
        ).toList(),
      },
      'tips': (postData['travelTips'] as List? ?? []).map((tip) => tip.toString()).toList(),
      'budgetBreakdown': budgetInfo['breakdown'] is Map 
          ? Map<String, dynamic>.from(budgetInfo['breakdown'] as Map)
          : <String, dynamic>{},
    };
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoadingPost) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading journey details...'),
            ],
          ),
        ),
      );
    }

    // Show post not found UI
    if (_postNotFound || journeyData == null) {
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
            'Journey Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_off,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'Post Not Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'The journey you\'re looking for might have been removed or doesn\'t exist.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Retry loading the post
                    _loadJourneyData();
                    _loadLikeStatus();
                    _loadComments();
                  },
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripStats(),
                  _buildEnhancedMapSection(), // Updated map section
                  _buildAllPlacesSection(),
                  _buildRecommendationsSection(),
                  _buildTipsSection(),
                  _buildBudgetBreakdown(),
                  _buildInteractionSection(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New enhanced map section
  Widget _buildEnhancedMapSection() {
    final apiKey = widget.googleMapsApiKey ?? _defaultApiKey;
    
    if (apiKey == "YOUR_GOOGLE_MAPS_API_KEY_HERE") {
      // Show warning if API key is not set
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'Google Maps API Key Required',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'To display the interactive route map with real directions, please add your Google Maps API key.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showApiKeyInstructions(),
              icon: const Icon(Icons.info_outline),
              label: const Text('Setup Instructions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Return the enhanced map widget with API key
    return JourneyRouteMapWidget(
      journeyData: journeyData!,
      googleMapsApiKey: apiKey,
    );
  }

  void _showApiKeyInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Google Maps API Setup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSetupStep(
                      '1',
                      'Get Google Maps API Key',
                      'Visit Google Cloud Console and create a new project or select an existing one.',
                    ),
                    _buildSetupStep(
                      '2',
                      'Enable Required APIs',
                      'Enable Maps SDK for Android, Maps SDK for iOS, and Directions API.',
                    ),
                    _buildSetupStep(
                      '3',
                      'Create Credentials',
                      'Create an API key and restrict it to your app package name for security.',
                    ),
                    _buildSetupStep(
                      '4',
                      'Add to Your App',
                      'Update the JourneyDetailsPage constructor to include your API key.',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Example Usage:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'JourneyDetailsPage(\n  journeyId: "journey_1",\n  googleMapsApiKey: "YOUR_API_KEY_HERE",\n)',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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

  Widget _buildSetupStep(String number, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
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

  Widget _buildSliverAppBar() {
    final placesList = journeyData!['places'] as List?;
    final places = placesList ?? [];
    if (places.isEmpty) {
      return SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text('No places available'),
            ),
          ),
        ),
      );
    }
    final firstPlace = places.first;
    final imagesList = firstPlace['images'] as List?;
    final images = imagesList?.cast<String>() ?? <String>[];

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return _buildImage(images[index]);
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journeyData!['tripTitle'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            journeyData!['authorImage'].startsWith('assets/')
                            ? AssetImage(journeyData!['authorImage'])
                                  as ImageProvider
                            : NetworkImage(journeyData!['authorImage']),
                        onBackgroundImageError: (_, __) {},
                        backgroundColor: Colors.grey[300],
                        child: journeyData!['authorImage'].isEmpty
                            ? Icon(Icons.person, color: Colors.grey[600])
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        journeyData!['authorName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, color: Colors.grey, size: 50),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        'assets/images/$imagePath',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildTripStats() {
    final placesList = journeyData!['places'] as List?;
    final places = placesList ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.mapPin,
              label: 'Places',
              value: '${places.length}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.calendar,
              label: 'Duration',
              value: '${journeyData!['totalDays']} Days',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.dollarSign,
              label: 'Budget',
              value: 'LKR ${journeyData!['totalBudget']}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[600], size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAllPlacesSection() {
    final placesList = journeyData!['places'] as List?;
    final places = placesList ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 560,
          child: PageView.builder(
            controller: _placesPageController,
            onPageChanged: (index) {
              setState(() {
                _currentPlaceIndex = index;
              });
            },
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildPlaceCard(places[index]),
              );
            },
          ),
        ),
        if (places.length > 1) ...[
          const SizedBox(height: 8),
          _buildPlacesDotsIndicator(places.length),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildPlacesDotsIndicator(int placeCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        placeCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPlaceIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPlaceIndex == index
                ? Colors.blue[600]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    final imagesList = place['images'] as List?;
    final images = imagesList?.cast<String>() ?? <String>[];
    final activitiesList = place['activities'] as List?;
    final activities = activitiesList?.cast<String>() ?? <String>[];
    final experiencesList = place['experiences'] as List?;
    final experiences = experiencesList?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
    final placeName = place['name'];
    final tripMood = place['trip_mood'] ?? '';

    if (!_pageControllers.containsKey(placeName)) {
      _pageControllers[placeName] = PageController();
      _currentImageIndexes[placeName] = 0;
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    place['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (tripMood.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tripMood,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageCarousel(images, placeName),
            _buildDotsIndicator(images, placeName),
            // Add consistent spacing before the first content section
            if (activities.isNotEmpty || experiences.isNotEmpty)
              const SizedBox(height: 12),
            if (activities.isNotEmpty) ...[
              const Text(
                'Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      ...activities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final activity = entry.value;
                        return Row(
                          children: [
                            if (index > 0) const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                activity,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ],
            if (experiences.isNotEmpty) ...[
              // Add spacing between activities and experiences if activities exist
              if (activities.isNotEmpty) const SizedBox(height: 12),
              const Text(
                'Experiences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 150,
                  minHeight: 50,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: experiences.map((experience) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          experience['description'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            height: 1.3,
                          ),
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final recommendations =
        journeyData!['overallRecommendations'] as Map<String, dynamic>;
    
    final hotels = (recommendations['hotels'] as List?) ?? [];
    final restaurants = (recommendations['restaurants'] as List?) ?? [];
    
    // Hide the entire section if both hotels and restaurants are empty
    if (hotels.isEmpty && restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (hotels.isNotEmpty)
            _buildRecommendationCategory(
              'Hotels',
              LucideIcons.building,
              hotels,
            ),
          if (restaurants.isNotEmpty)
            _buildRecommendationCategory(
              'Restaurants',
              LucideIcons.utensils,
              restaurants,
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCategory(String title, IconData icon, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${item['rating']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTipsSection() {
    final tipsList = journeyData!['tips'] as List?;
    final tips = tipsList?.cast<String>() ?? <String>[];
    
    // Hide the section if no tips are available
    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Travel Tips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...tips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;
            final isLast = index == tips.length - 1;

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBudgetBreakdown() {
    final breakdown = journeyData!['budgetBreakdown'] as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Breakdown',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...breakdown.entries.map((entry) {
            return _buildBudgetBar(
              label: _capitalize(entry.key),
              percentage: entry.value.toDouble(),
              color: _getBudgetColor(entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBudgetBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(
                icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                count: _likesCount,
                isActive: _isLiked,
                activeColor: Colors.red,
                onTap: _handleLike,
              ),
              _buildIconButton(
                icon: LucideIcons.messageCircle,
                count: _commentsCount,
                isActive: false,
                activeColor: Colors.blue[600]!,
                onTap: _handleComment,
              ),
              _buildIconButton(
                icon: _isInBucketList ? Icons.bookmark : Icons.bookmark_border,
                count: null,
                isActive: _isInBucketList,
                activeColor: Colors.amber[700]!,
                onTap: _handleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required int? count,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? activeColor : Colors.grey[600],
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isActive ? activeColor : Colors.grey[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleLike() async {
    // Optimistically update UI
    final previousLiked = _isLiked;
    final previousCount = _likesCount;
    try {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _likesCount++;
        } else {
          _likesCount--;
        }
      });

      // Make API call
      await PostRepository.toggleLike(postId);
      
      // Reload like status to ensure consistency
      _loadLikeStatus();
    } catch (e) {
      print('Error toggling like: $e');
      
      // Revert optimistic update on error
      setState(() {
        _isLiked = previousLiked;
        _likesCount = previousCount;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update like status'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _handleComment() {
    // Create a new notifier for this bottom sheet session
    _commentsNotifier = ValueNotifier(_comments);
    
    _showCommentsBottomSheet(
      context,
      postId: postId,
      commentsNotifier: _commentsNotifier!,
      postOwnerName: journeyData!['creatorUsername'] ?? 'user',
      onCommentsUpdated: () async {
        // Only reload comments when explicitly requested (after posting a comment)
        await _loadComments();
      },
      onClosed: () {
        // Clean up the notifier when bottom sheet is closed
        _commentsNotifier?.dispose();
        _commentsNotifier = null;
      },
    );
  }

  Future<void> _loadBucketListStatus() async {
    try {
      final bucketListData = await BucketListRepository.getBucketList();
      
      if (bucketListData['posts'] != null && bucketListData['posts'] is List) {
        final posts = bucketListData['posts'] as List;
        final isInBucketList = posts.any((post) {
          if (post is Map) {
            return post['id']?.toString() == postId;
          }
          return false;
        });
        
        setState(() {
          _isInBucketList = isInBucketList;
        });
      }
    } catch (e) {
      print('Error loading bucket list status: $e');
    }
  }

  Future<void> _handleSave() async {
    try {
      if (_isInBucketList) {
        // Remove from bucket list
        await BucketListRepository.removeFromBucketList(postId);
        setState(() {
          _isInBucketList = false;
          _isBookmarked = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from bucket list'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Add to bucket list
        await BucketListRepository.addToBucketList(postId);
        setState(() {
          _isInBucketList = true;
          _isBookmarked = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to bucket list'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error updating bucket list: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update bucket list'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTimeAgo(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'now';
    
    try {
      final DateTime commentTime = DateTime.parse(timestamp);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(commentTime);

      if (difference.inMinutes < 1) {
        return 'now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d';
      } else {
        return '${(difference.inDays / 7).floor()}w';
      }
    } catch (e) {
      print('Error parsing timestamp: $e');
      return 'now';
    }
  }

  Color _getBudgetColor(String category) {
    switch (category) {
      case 'accommodation':
        return Colors.blue[600]!;
      case 'food':
        return Colors.green[600]!;
      case 'transport':
        return Colors.orange[600]!;
      case 'activities':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildImageCarousel(List<String> images, String placeName) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageControllers[placeName]!,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndexes[placeName] = index;
          });
        },
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(images[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDotsIndicator(List<String> images, String placeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          images.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: (_currentImageIndexes[placeName] ?? 0) == index ? 24 : 8,
            decoration: BoxDecoration(
              color: (_currentImageIndexes[placeName] ?? 0) == index
                  ? Colors.blue
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(
    BuildContext context, {
    required String postId,
    required ValueNotifier<List<Map<String, dynamic>>> commentsNotifier,
    required String postOwnerName,
    VoidCallback? onCommentsUpdated,
    VoidCallback? onClosed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsBottomSheet(
        postId: postId,
        commentsNotifier: commentsNotifier,
        postOwnerName: postOwnerName,
        onCommentsUpdated: onCommentsUpdated,
      ),
    ).whenComplete(() {
      onClosed?.call();
    });
  }
}

// Comments Bottom Sheet Widget
class _CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final ValueNotifier<List<Map<String, dynamic>>> commentsNotifier;
  final String postOwnerName;
  final VoidCallback? onCommentsUpdated;

  const _CommentsBottomSheet({
    required this.postId,
    required this.commentsNotifier,
    required this.postOwnerName,
    this.onCommentsUpdated,
  });

  @override
  State<_CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _replyingTo;
  String? _replyingToCommentId;
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.commentsNotifier.value);
    // Listen to changes in comments from parent
    widget.commentsNotifier.addListener(_updateComments);
  }

  void _updateComments() {
    if (mounted) {
      setState(() {
        _comments = List.from(widget.commentsNotifier.value);
      });
    }
  }

  @override
  void dispose() {
    widget.commentsNotifier.removeListener(_updateComments);
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildCommentsList()),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (_comments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Be the first to comment!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _buildCommentItem(comment, false);
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, bool isReply) {
    return Container(
      margin: EdgeInsets.only(left: isReply ? 40 : 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isReply ? 14 : 16,
                backgroundImage:
                    comment['userImage'] != null &&
                        comment['userImage'].toString().isNotEmpty
                    ? NetworkImage(comment['userImage'].toString())
                    : null,
                backgroundColor: Colors.grey[300],
                child:
                    comment['userImage'] == null || comment['userImage'].toString().isEmpty
                    ? Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: isReply ? 16 : 20,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: comment['userName']?.toString() ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: comment['comment']?.toString() ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          comment['timeAgo']?.toString() ?? 'now',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if ((comment['likesCount'] ?? 0) > 0) ...[
                          Text(
                            '${comment['likesCount'] ?? 0} likes',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (!isReply) ...[
                          GestureDetector(
                            onTap: () =>
                                _startReply(comment['userName']?.toString() ?? 'Anonymous', comment['id']?.toString() ?? ''),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _toggleCommentLike(comment),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    (comment['isLiked'] ?? false) ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: (comment['isLiked'] ?? false) ? Colors.red : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          if (!isReply &&
              comment['replies'] != null &&
              (comment['replies'] as List).isNotEmpty) ...[
            const SizedBox(height: 8),
            ...(comment['replies'] as List? ?? [])
                .map<Widget>((reply) => _buildCommentItem(reply as Map<String, dynamic>, true))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 
               MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_replyingTo != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingTo',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  decoration: InputDecoration(
                    hintText: _replyingTo != null
                        ? 'Reply...'
                        : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    suffixIcon: _commentController.text.isNotEmpty
                        ? IconButton(
                            onPressed: _postComment,
                            icon: const Icon(Icons.send, color: Colors.blue),
                          )
                        : null,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _postComment();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startReply(String userName, String commentId) {
    setState(() {
      _replyingTo = userName;
      _replyingToCommentId = commentId;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _replyingToCommentId = null;
    });
  }

  Future<void> _postComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      // Show loading state
      setState(() {
        _commentController.clear();
      });

      if (_replyingTo != null && _replyingToCommentId != null) {
        // Reply to comment
        await PostRepository.replyToComment(
          widget.postId,
          _replyingToCommentId!,
          commentText,
        );
      } else {
        // Add new comment
        await PostRepository.addComment(widget.postId, commentText);
      }

      // Reload comments after successful post
      // This will be handled by the callback from parent
      
      setState(() {
        _cancelReply();
      });

      _commentFocusNode.unfocus();
      widget.onCommentsUpdated?.call();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment posted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error posting comment: $e');
      
      // Restore text on error
      setState(() {
        _commentController.text = commentText;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to post comment'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _toggleCommentLike(Map<String, dynamic> comment) {
    setState(() {
      final currentLiked = comment['isLiked'] ?? false;
      comment['isLiked'] = !currentLiked;
      
      final currentCount = comment['likesCount'] ?? 0;
      if (comment['isLiked']) {
        comment['likesCount'] = currentCount + 1;
      } else {
        comment['likesCount'] = currentCount - 1;
      }
    });
  }
}