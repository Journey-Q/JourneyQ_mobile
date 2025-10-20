// File: lib/features/marketplace/pages/hotel_details.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/hotel_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/room_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/review_repository.dart';

class HotelDetailsPage extends StatefulWidget {
  final String hotelId;

  const HotelDetailsPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  HotelProfile? hotelData;
  List<Room> rooms = [];
  ReviewStats? reviewStats;
  List<Review> hotelReviews = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  bool reviewsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotelData();
  }

  Future<void> _loadHotelData() async {
    try {
      print('🏨 Loading hotel details for ID: ${widget.hotelId}');

      // Load hotel profile
      final hotel = await HotelRepository.getHotelProfileById(widget.hotelId);
      print('✅ Hotel profile loaded: ${hotel.name}');

      // Load rooms for this hotel with detailed debugging
      print('🛏️ Fetching rooms for hotel ID: ${widget.hotelId}');
      final hotelRooms = await RoomRepository.getRoomsByServiceProvider(widget.hotelId);

      print('✅ Rooms loaded: ${hotelRooms.length} rooms');

      // Debug each room
      for (var room in hotelRooms) {
        print('🛏️ Room Details:');
        print('   - ID: ${room.id}');
        print('   - Number: ${room.roomNumber}');
        print('   - Type: ${room.roomType}');
        print('   - Display Type: ${room.displayRoomType}');
        print('   - Price: ${room.price}');
        print('   - Status: ${room.status}');
        print('   - Image URL: ${room.imageUrl}');
        print('   - Capacity: ${room.capacity}');
      }

      if (mounted) {
        setState(() {
          hotelData = hotel;
          rooms = hotelRooms;
          isLoading = false;
        });
      }

      // Load reviews separately to not block the main UI
      _loadReviewsData();
    } catch (e, stackTrace) {
      print('❌ Error loading hotel details: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
          reviewsLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadReviewsData() async {
    try {
      print('📊 Loading review data for hotel ID: ${widget.hotelId}');

      // Load review statistics
      final stats = await ReviewRepository.getReviewStatsByServiceProviderId(widget.hotelId);
      print('✅ Review stats loaded: ${stats.totalReviews} reviews, ${stats.averageRating} avg rating');

      // Load recent reviews
      List<Review> reviews = [];
      if (stats.totalReviews > 0) {
        reviews = await ReviewRepository.getReviewsByServiceProviderId(widget.hotelId);
        print('✅ Reviews loaded: ${reviews.length} reviews');
      } else {
        print('ℹ️ No reviews to load (totalReviews: 0)');
      }

      if (mounted) {
        setState(() {
          reviewStats = stats;
          hotelReviews = reviews;
          reviewsLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error loading review data: $e');
      print('Stack trace: $stackTrace');

      // Use default empty stats if review loading fails
      if (mounted) {
        setState(() {
          reviewStats = ReviewStats(
            totalReviews: 0,
            averageRating: 0.0,
            fiveStarCount: 0,
            fourStarCount: 0,
            threeStarCount: 0,
            twoStarCount: 0,
            oneStarCount: 0,
          );
          hotelReviews = [];
          reviewsLoading = false;
        });
      }
    }
  }

  void _viewReviews() {
    if (_totalReviews > 0) {
      context.push('/marketplace/hotels/reviews/${widget.hotelId}');
    }
  }

  void _viewRoomDetails(Room room) {
    context.push(
      '/marketplace/hotels/room_details',
      extra: {
        'hotelId': hotelData?.id ?? '',
        'roomId': room.id,
      },
    );
  }

  // FIXED: Get unique amenities to prevent duplicates
  List<String> get _uniqueAmenities {
    if (hotelData?.amenities == null) return [];
    final uniqueAmenities = hotelData!.amenities.toSet().toList();
    return uniqueAmenities;
  }

  // FIXED: Better room status handling
  String _getRoomStatusText(Room room) {
    switch (room.status) {
      case RoomStatus.AVAILABLE:
        return 'Available';
      case RoomStatus.OCCUPIED:
        return 'Occupied';
      case RoomStatus.MAINTENANCE:
        return 'Under Maintenance';
      case RoomStatus.RESERVED:
        return 'Reserved';
      default:
        return 'Available';
    }
  }

  Color _getRoomStatusColor(Room room) {
    switch (room.status) {
      case RoomStatus.AVAILABLE:
        return Colors.green;
      case RoomStatus.OCCUPIED:
        return Colors.red;
      case RoomStatus.MAINTENANCE:
        return Colors.orange;
      case RoomStatus.RESERVED:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  Widget _buildRatingBar(int starCount, int reviewCount, int totalReviews) {
    double percentage = totalReviews > 0 ? reviewCount / totalReviews : 0;

    return Row(
      children: [
        Text(
          '$starCount',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.star,
          size: 16,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$reviewCount',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // Helper method for feature items
  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // FIXED: Use displayRoomType from Room model instead of custom logic
  String _getFormattedRoomName(Room room) {
    return room.displayRoomType;
  }

  // Helper method to get room number display
  String _getRoomNumberDisplay(Room room) {
    if (room.roomNumber.isNotEmpty && room.roomNumber != 'Unknown') {
      return 'Room ${room.roomNumber}';
    }
    return 'Room Details';
  }

  // FIXED: Enhanced room card with proper status handling and LKR currency
  Widget _buildRoomCard(Room room) {
    bool isBookable = room.status == RoomStatus.AVAILABLE;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Room image from database
                  _buildRoomImage(room),
                  // Status Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoomStatusColor(room).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getRoomStatusText(room),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Overlay for unavailable rooms
                  if (!isBookable)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          _getRoomStatusText(room).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Room Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getFormattedRoomName(room),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (room.size != null && room.size! > 0)
                      Text(
                        '${room.size} sqm',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Room Number
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        _getRoomNumberDisplay(room),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Room Features
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Capacity
                      Expanded(
                        child: _buildFeatureItem(
                          icon: Icons.people,
                          text: '${room.capacity} guest${room.capacity > 1 ? 's' : ''}',
                        ),
                      ),
                      // Vertical divider
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      // Bedrooms
                      Expanded(
                        child: _buildFeatureItem(
                          icon: Icons.bed,
                          text: '${room.bedrooms ?? 1} bedroom${(room.bedrooms ?? 1) > 1 ? 's' : ''}',
                        ),
                      ),
                      // Vertical divider
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      // Bathrooms
                      Expanded(
                        child: _buildFeatureItem(
                          icon: Icons.bathtub,
                          text: '${room.bathrooms ?? 1} bathroom${(room.bathrooms ?? 1) > 1 ? 's' : ''}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Room Amenities
                if (room.amenities.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room Amenities:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: room.amenities.take(4).map<Widget>((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Price and Book Button
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.formattedPrice, // This now uses LKR format
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (!isBookable)
                            Text(
                              _getRoomStatusText(room),
                              style: TextStyle(
                                fontSize: 12,
                                color: _getRoomStatusColor(room),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: isBookable ? () {
                          _viewRoomDetails(room);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isBookable ? const Color(0xFF0088cc) : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          isBookable ? 'View Details' : 'Not Available',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED: Improved image loading with better validation and error handling
  Widget _buildRoomImage(Room room) {
    bool isBookable = room.status == RoomStatus.AVAILABLE;

    // Enhanced image URL validation
    String? imageUrl = room.imageUrl;

    // Debug the image URL
    print('🖼️ Room Image Debug for ${room.displayRoomType}:');
    print('   - Raw imageUrl: $imageUrl');
    print('   - Room ID: ${room.id}');
    print('   - Is bookable: $isBookable');

    // Enhanced image URL validation
    bool isValidImageUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl != 'null' &&
        imageUrl != '<null>' &&
        imageUrl != 'undefined' &&
        (imageUrl.startsWith('http://') ||
            imageUrl.startsWith('https://') ||
            imageUrl.startsWith('www.') ||
            imageUrl.contains('.jpg') ||
            imageUrl.contains('.jpeg') ||
            imageUrl.contains('.png') ||
            imageUrl.contains('.webp') ||
            imageUrl.contains('.gif') ||
            imageUrl.contains('cloudinary') ||
            imageUrl.contains('storage.googleapis.com'));

    if (isValidImageUrl) {
      // Add https if it starts with www
      if (imageUrl.startsWith('www.')) {
        imageUrl = 'https://$imageUrl';
      }

      print('✅ Loading room image from URL: $imageUrl');

      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 180,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: const Color(0xFF0088cc),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading room image: $error');
          print('❌ Image URL that failed: $imageUrl');
          print('❌ Stack trace: $stackTrace');
          return _buildRoomPlaceholder(room);
        },
      );
    } else {
      print('⚠️ No valid image URL for room: ${room.displayRoomType}');
      print('⚠️ Image URL value: ${room.imageUrl}');
      print('⚠️ Room data: ${room.toJson()}');
    }

    return _buildRoomPlaceholder(room);
  }

  // Temporary method to test image loading - remove after testing
  Widget _buildTestImage() {
    // Test with some sample hotel room images
    final testImageUrls = [
      'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
      'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=400',
    ];

    final random = Random();
    final testUrl = testImageUrls[random.nextInt(testImageUrls.length)];

    print('🧪 Testing with sample image URL: $testUrl');

    return Image.network(
      testUrl,
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Even test image failed: $error');
        return Container(
          color: Colors.red,
          child: Center(
            child: Text('Image load failed', style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }

  Widget _buildRoomPlaceholder(Room room) {
    bool isBookable = room.status == RoomStatus.AVAILABLE;

    // Generate consistent color based on room ID
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    final colorIndex = (room.id.hashCode.abs() % colors.length);
    final backgroundColor = colors[colorIndex];

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bed,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedRoomName(room),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!isBookable) ...[
            const SizedBox(height: 8),
            Text(
              _getRoomStatusText(room),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // UPDATED: Improved hotel image loading
  Widget _buildHotelImage() {
    // Enhanced hotel image URL handling
    if (hotelData?.imageUrl != null &&
        hotelData!.imageUrl!.isNotEmpty &&
        hotelData!.imageUrl! != 'null' &&
        hotelData!.imageUrl! != '<null>' &&
        hotelData!.imageUrl! != 'undefined' &&
        (hotelData!.imageUrl!.startsWith('http://') ||
            hotelData!.imageUrl!.startsWith('https://') ||
            hotelData!.imageUrl!.startsWith('www.') ||
            hotelData!.imageUrl!.contains('.jpg') ||
            hotelData!.imageUrl!.contains('.jpeg') ||
            hotelData!.imageUrl!.contains('.png'))) {

      String imageUrl = hotelData!.imageUrl!;

      // Add https if it starts with www
      if (imageUrl.startsWith('www.')) {
        imageUrl = 'https://$imageUrl';
      }

      print('🏨 Loading hotel image from URL: $imageUrl');

      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: const Color(0xFF0088cc),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading hotel image: $error');
          print('❌ Hotel image URL: ${hotelData!.imageUrl}');
          return _buildHotelPlaceholder();
        },
      );
    } else {
      print('⚠️ No valid hotel image URL');
      print('⚠️ Hotel image URL value: ${hotelData?.imageUrl}');
    }
    return _buildHotelPlaceholder();
  }

  Widget _buildHotelPlaceholder() {
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    final colorIndex = ((hotelData?.id.hashCode ?? 0).abs() % colors.length);
    final backgroundColor = colors[colorIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.hotel,
        size: 100,
        color: Colors.white,
      ),
    );
  }

  // Updated review stats to use real data
  Map<String, int> get _reviewStats {
    if (reviewStats != null) {
      return {
        '5': reviewStats!.fiveStarCount,
        '4': reviewStats!.fourStarCount,
        '3': reviewStats!.threeStarCount,
        '2': reviewStats!.twoStarCount,
        '1': reviewStats!.oneStarCount,
      };
    }
    return {
      '5': 0,
      '4': 0,
      '3': 0,
      '2': 0,
      '1': 0,
    };
  }

  int get _totalReviews => reviewStats?.totalReviews ?? 0;
  double get _averageRating => reviewStats?.averageRating ?? 0.0;

  // FIXED: Build recent reviews preview with loading state
  Widget _buildRecentReviewsPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          if (reviewsLoading)
            _buildReviewsLoadingState()
          else if (_totalReviews == 0)
            _buildNoReviewsState()
          else
            _buildReviewsContent(),
        ],
      ),
    );
  }

  Widget _buildReviewsLoadingState() {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading reviews...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoReviewsState() {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No reviews yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to share your experience!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsContent() {
    return Column(
      children: [
        Row(
          children: [
            // Overall rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    if (index < _averageRating.floor()) {
                      return const Icon(Icons.star, color: Colors.orange, size: 20);
                    } else if (index < _averageRating) {
                      return const Icon(Icons.star_half, color: Colors.orange, size: 20);
                    } else {
                      return Icon(Icons.star_border, color: Colors.grey.shade300, size: 20);
                    }
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_totalReviews reviews',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 32),

            // Rating breakdown
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar(5, _reviewStats['5']!, _totalReviews),
                  const SizedBox(height: 8),
                  _buildRatingBar(4, _reviewStats['4']!, _totalReviews),
                  const SizedBox(height: 8),
                  _buildRatingBar(3, _reviewStats['3']!, _totalReviews),
                  const SizedBox(height: 8),
                  _buildRatingBar(2, _reviewStats['2']!, _totalReviews),
                  const SizedBox(height: 8),
                  _buildRatingBar(1, _reviewStats['1']!, _totalReviews),
                ],
              ),
            ),
          ],
        ),

        if (hotelReviews.isNotEmpty) ...[
          const SizedBox(height: 20),
          // Recent Reviews
          Column(
            children: hotelReviews.take(3).map((review) => _buildReviewPreviewCard(review)).toList(),
          ),
        ],

        const SizedBox(height: 16),

        // Read Reviews Button
        GestureDetector(
          onTap: _totalReviews > 0 ? _viewReviews : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _totalReviews > 0 ? Colors.grey.shade300 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
              color: _totalReviews > 0 ? Colors.transparent : Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _totalReviews > 0 ? 'View all $_totalReviews reviews' : 'No reviews available',
                  style: TextStyle(
                    fontSize: 16,
                    color: _totalReviews > 0 ? Colors.blue.shade600 : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_totalReviews > 0) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewPreviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  review.customerName.isNotEmpty ? review.customerName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.customerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    size: 14,
                    color: Colors.orange,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.reviewText.length > 100
                ? '${review.reviewText.substring(0, 100)}...'
                : review.reviewText,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
          if (review.isVerified) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 14,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Verified Stay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError || hotelData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Hotel Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hotel not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Hotel ID: ${widget.hotelId}',
                style: const TextStyle(color: Colors.grey),
              ),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Hotels'),
              ),
            ],
          ),
        ),
      );
    }

    final hotel = hotelData!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHotelImage(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hotel.location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(
                            hotel.isActive ? Icons.check_circle : Icons.cancel,
                            color: hotel.isActive ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hotel.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: hotel.isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($_totalReviews reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description ?? 'No description available for this hotel.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Information
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (hotel.phone != null && hotel.phone!.isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Color(0xFF0088cc)),
                              const SizedBox(width: 12),
                              Text(
                                hotel.phone!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (hotel.email != null && hotel.email!.isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(Icons.email, color: Color(0xFF0088cc)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hotel.email!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF0088cc)),
                            const SizedBox(width: 12),
                            Text(
                              'Open: 24/7',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // FIXED: Hotel Amenities with unique items
                  const Text(
                    'Hotel Facilities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_uniqueAmenities.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _uniqueAmenities.map<Widget>((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      'No amenities listed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Customer Reviews Section
                  _buildRecentReviewsPreview(),

                  const SizedBox(height: 32),

                  // Available Rooms
                  const Text(
                    'Available Rooms',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (rooms.isNotEmpty)
                    Column(
                      children: rooms.map((room) => _buildRoomCard(room)).toList(),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.bed,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No rooms available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for room availability',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
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
    );
  }
}