import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/hotel_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/room_repository.dart';
import 'booking_room.dart';

class RoomDetailsPage extends StatefulWidget {
  final String hotelId;
  final String roomId;

  const RoomDetailsPage({
    Key? key,
    required this.hotelId,
    required this.roomId,
  }) : super(key: key);

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  HotelProfile? hotelData;
  Room? roomData;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int selectedImageIndex = 0;

  // Room images - will be populated from room data
  List<String> roomImages = [];

  @override
  void initState() {
    super.initState();
    _loadRoomData();
  }

  Future<void> _loadRoomData() async {
    try {
      print('🏨 Loading room details for ID: ${widget.roomId}');
      print('🏨 Hotel ID: ${widget.hotelId}');

      // Load hotel profile
      final hotel = await HotelRepository.getHotelProfileById(widget.hotelId);

      // Load room details
      final room = await RoomRepository.getRoomById(widget.roomId);

      // Initialize room images
      final images = <String>[];
      if (room.imageUrl != null && room.imageUrl!.isNotEmpty) {
        images.add(room.imageUrl!);
      }
      // Add placeholder images for gallery
      images.addAll([
        'assets/images/room_deluxe.jpg',
        'assets/images/room_suite.jpg',
        'assets/images/room_presidential.jpg',
      ]);

      if (mounted) {
        setState(() {
          hotelData = hotel;
          roomData = room;
          roomImages = images;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error loading room details: $e');
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

  String get roomStatus {
    if (roomData != null) {
      return roomData!.status.name.toLowerCase();
    }
    return 'available';
  }

  bool get isRoomAvailable => roomData?.status == RoomStatus.AVAILABLE;

  Color get statusColor {
    switch (roomStatus) {
      case 'available':
        return Colors.green;
      case 'maintenance':
        return Colors.orange;
      case 'occupied':
      case 'reserved':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String get statusText {
    switch (roomStatus) {
      case 'available':
        return 'Available';
      case 'maintenance':
        return 'Under Maintenance';
      case 'occupied':
        return 'Currently Occupied';
      case 'reserved':
        return 'Reserved';
      default:
        return 'Available';
    }
  }

  Widget _buildImageGallery() {
    return Container(
      height: 300,
      child: Column(
        children: [
          // Main Image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: roomImages.isNotEmpty
                    ? Image.network(
                  roomImages[selectedImageIndex],
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
                    return _buildRoomPlaceholder();
                  },
                )
                    : _buildRoomPlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Thumbnail Images
          if (roomImages.length > 1)
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: roomImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedImageIndex == index
                              ? const Color(0xFF0088cc)
                              : Colors.grey.shade300,
                          width: selectedImageIndex == index ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          roomImages[index],
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
                                  strokeWidth: 1,
                                  color: const Color(0xFF0088cc),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: _getRoomColor().withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.bed,
                                size: 30,
                                color: Colors.white,
                              ),
                            );
                          },
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
  }

  Widget _buildRoomPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getRoomColor(),
            _getRoomColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.bed,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  Color _getRoomColor() {
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    final colorIndex = roomData?.id.hashCode ?? 0 % colors.length;
    return colors[colorIndex];
  }

  Widget _buildRoomSpecs() {
    final bedrooms = roomData?.bedrooms ?? 1;
    final bathrooms = roomData?.bathrooms ?? 1;
    final maxOccupancy = roomData?.capacity ?? _calculateMaxOccupancy(bedrooms);
    final roomSize = roomData?.size != null ? '${roomData!.size} sqm' : 'Standard';

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Top row - Room Size and Bed Type
          Row(
            children: [
              // Room Size
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.square_foot, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Room Size',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      roomSize,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Bed Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bed, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Bed Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getBedTypeFromAmenities(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Maximum Occupancy Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.people, size: 24, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maximum Occupancy',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Up to $maxOccupancy ${maxOccupancy == 1 ? 'person' : 'people'} can stay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Row(
            children: [
              // Bedrooms
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bedroom_parent, size: 24, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            '$bedrooms',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Text(
                            'Bedroom${bedrooms > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Bathrooms
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bathroom, size: 24, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            '$bathrooms',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            'Bathroom${bathrooms > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to calculate maximum occupancy based on room type and bedrooms
  int _calculateMaxOccupancy(int bedrooms) {
    if (roomData != null) {
      return roomData!.capacity;
    }

    final roomType = roomData?.roomType.toLowerCase() ?? '';
    if (roomType.contains('presidential') || roomType.contains('suite')) {
      return bedrooms * 3;
    } else if (roomType.contains('deluxe') || roomType.contains('executive')) {
      return bedrooms * 2 + 1;
    } else {
      return bedrooms * 2;
    }
  }

  String _getBedTypeFromAmenities() {
    if (roomData == null) return 'Standard Bed';

    final amenities = roomData!.amenities;
    for (final amenity in amenities) {
      if (amenity.toLowerCase().contains('queen')) return 'Queen Bed';
      if (amenity.toLowerCase().contains('king')) return 'King Bed';
      if (amenity.toLowerCase().contains('single')) return 'Single Bed';
      if (amenity.toLowerCase().contains('double')) return 'Double Bed';
      if (amenity.toLowerCase().contains('twin')) return 'Twin Beds';
    }
    return 'Standard Bed';
  }

  Widget _buildAmenitiesSection() {
    final amenities = roomData?.amenities ?? [];

    // Filter out meal plan options from amenities
    final filteredAmenities = amenities.where((amenity) =>
    !['Full Board', 'Half Board', 'Bed and Breakfast', 'All-Inclusive', 'Room Only'].contains(amenity)
    ).toList();

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (filteredAmenities.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: filteredAmenities.map<Widget>((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getAmenityIcon(amenity),
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        amenity,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
      case 'free wifi':
        return Icons.wifi;
      case 'minibar':
        return Icons.local_bar;
      case 'safe':
        return Icons.security;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'balcony':
        return Icons.balcony;
      case 'ocean view':
      case 'city view':
      case 'garden view':
        return Icons.landscape;
      case 'work desk':
      case 'work station':
        return Icons.desk;
      case 'bathtub':
      case 'marble bathroom':
      case 'premium bathroom':
        return Icons.bathtub;
      case 'living room':
      case 'separate living room':
        return Icons.weekend;
      case 'butler service':
        return Icons.room_service;
      default:
        return Icons.star;
    }
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Room Rate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                roomData?.formattedPrice ?? '\$0.00/night',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'per night',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Room only - Meal plans available during booking',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isRoomAvailable ? () {
                // Convert to maps for compatibility with BookingRoomPage
                final hotelMap = hotelData?.toNavigationMap() ?? {};
                final roomMap = roomData?.toNavigationMap() ?? {};

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingRoomPage(
                      hotel: hotelMap,
                      room: roomMap,
                    ),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRoomAvailable ? const Color(0xFF0088cc) : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: isRoomAvailable ? 2 : 0,
              ),
              child: Text(
                isRoomAvailable ? 'Book Now' :
                (roomStatus == 'maintenance' ? 'Under Maintenance' : 'Currently Unavailable'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError || roomData == null || hotelData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: const Text(
            'Room Not Found',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                'Room not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Room ID: ${widget.roomId}',
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
                child: const Text('Back to Hotel'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          roomData!.displayRoomType,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            _buildImageGallery(),
            const SizedBox(height: 24),

            // Room Title and Basic Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomData!.displayRoomType,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hotelData!.name} • ${hotelData!.location}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Room Specifications
            _buildRoomSpecs(),
            const SizedBox(height: 20),

            // Room Amenities
            _buildAmenitiesSection(),
            const SizedBox(height: 20),

            // Pricing and Booking Section
            _buildPricingSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}