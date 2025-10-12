import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/hotel_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/room_repository.dart';

class HotelDetailsPage extends StatefulWidget {
  final String hotelId;

  const HotelDetailsPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  HotelProfile? hotelData;
  List<Room> rooms = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

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

      // Load rooms for this hotel
      final hotelRooms = await RoomRepository.getRoomsByServiceProvider(widget.hotelId);

      if (mounted) {
        setState(() {
          hotelData = hotel;
          rooms = hotelRooms;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error loading hotel details: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  void _viewReviews() {
    context.push('/marketplace/hotels/reviews/${widget.hotelId}');
  }

  // UPDATED: Simplified navigation to room details
  void _viewRoomDetails(Room room) {
    context.push(
      '/marketplace/hotels/room_details',
      extra: {
        'hotelId': hotelData?.id ?? '',
        'roomId': room.id,
      },
    );
  }

  String _getBedTypeFromAmenities(List<String> amenities) {
    for (final amenity in amenities) {
      if (amenity.toLowerCase().contains('queen')) return 'Queen Bed';
      if (amenity.toLowerCase().contains('king')) return 'King Bed';
      if (amenity.toLowerCase().contains('single')) return 'Single Bed';
      if (amenity.toLowerCase().contains('double')) return 'Double Bed';
      if (amenity.toLowerCase().contains('twin')) return 'Twin Beds';
    }
    return 'Standard Bed';
  }

  // FIXED: Corrected color selection method to prevent RangeError
  Color _getRoomColor(String roomId) {
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    // Use absolute value and ensure it's within bounds
    final colorIndex = (roomId.hashCode.abs() % colors.length);
    return colors[colorIndex];
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

  // Helper method to get formatted room name
  String _getFormattedRoomName(Room room) {
    String roomType = room.roomType;

    // Handle empty or default room types
    if (roomType.isEmpty || roomType == 'Unknown' || roomType == 'Standard') {
      // Try to determine room type from amenities or other features
      if (room.amenities.any((amenity) => amenity.toLowerCase().contains('queen') || amenity.toLowerCase().contains('king'))) {
        return 'Deluxe Room';
      } else if (room.amenities.any((amenity) => amenity.toLowerCase().contains('suite'))) {
        return 'Suite';
      } else if (room.price > 10000) {
        return 'Premium Room';
      } else if (room.price > 7000) {
        return 'Standard Room';
      } else {
        return 'Budget Room';
      }
    }

    // Capitalize first letter of each word
    roomType = roomType.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return roomType;
  }

  // Helper method to get room number display
  String _getRoomNumberDisplay(Room room) {
    if (room.roomNumber.isNotEmpty && room.roomNumber != 'Unknown') {
      return 'Room ${room.roomNumber}';
    }
    return 'Room Details';
  }

  // Enhanced room card with proper data mapping
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
                        color: room.statusColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room.statusText,
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
                          room.statusText.toUpperCase(),
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
                // Room Type - FIXED: Better room name handling
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
                    if (room.size != null)
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

                // Room Number - FIXED: Better room number display
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

                // Room Features - FIXED: Better layout and pixel alignment
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

                // Room Amenities - FIXED: Better amenities display
                if (room.amenities.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: room.amenities.take(6).map<Widget>((amenity) {
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

                // Price and Book Button - FIXED: Better alignment and syntax error
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
                            room.formattedPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (!isBookable)
                            Text(
                              room.statusText,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade600,
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

  Widget _buildRoomImage(Room room) {
    bool isBookable = room.status == RoomStatus.AVAILABLE;

    if (room.imageUrl != null && room.imageUrl!.isNotEmpty) {
      return Image.network(
        room.imageUrl!,
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
          return _buildRoomPlaceholder(room);
        },
      );
    }
    return _buildRoomPlaceholder(room);
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
    // FIXED: Use absolute value to prevent negative index
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
              room.statusText,
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

  Widget _buildHotelImage() {
    if (hotelData?.imageUrl != null && hotelData!.imageUrl!.isNotEmpty) {
      return Image.network(
        hotelData!.imageUrl!,
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
          return _buildHotelPlaceholder();
        },
      );
    }
    return _buildHotelPlaceholder();
  }

  Widget _buildHotelPlaceholder() {
    // Generate consistent color based on hotel ID
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    // FIXED: Use absolute value to prevent negative index
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

  // Default review stats (you can replace this with actual data from your API)
  Map<String, int> get _defaultReviewStats => {
    '5': 45,
    '4': 30,
    '3': 15,
    '2': 5,
    '1': 5,
  };

  int get _totalReviews => _defaultReviewStats.values.reduce((a, b) => a + b);

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
          // App Bar with Hotel Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHotelImage(),
            ),
          ),
          // Hotel Details Content
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

                  // Rating (using default values since they're not in the database)
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5', // Default rating
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($_totalReviews reviews)', // Default review count
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
                        if (hotel.phone != null) ...[
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
                        if (hotel.email != null) ...[
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
                              'Open: 24/7', // Default open time
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hotel Amenities
                  const Text(
                    'Hotel Facilities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (hotel.amenities.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hotel.amenities.map<Widget>((amenity) {
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
                  Container(
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

                        Row(
                          children: [
                            // Left side - Overall rating
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  '4.5', // Default rating
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    const double rating = 4.5;
                                    if (index < rating.floor()) {
                                      return const Icon(Icons.star, color: Colors.orange, size: 20);
                                    } else if (index < rating) {
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

                            // Right side - Rating breakdown
                            Expanded(
                              child: Column(
                                children: [
                                  _buildRatingBar(5, _defaultReviewStats['5']!, _totalReviews),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(4, _defaultReviewStats['4']!, _totalReviews),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(3, _defaultReviewStats['3']!, _totalReviews),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(2, _defaultReviewStats['2']!, _totalReviews),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(1, _defaultReviewStats['1']!, _totalReviews),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Read Reviews Button
                        GestureDetector(
                          onTap: _viewReviews,
                          child: Row(
                            children: [
                              Text(
                                'Read reviews',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue.shade600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

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