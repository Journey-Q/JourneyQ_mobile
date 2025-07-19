import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'booking_room.dart';

class RoomDetailsPage extends StatefulWidget {
  final Map<String, dynamic> hotel;
  final Map<String, dynamic> room;

  const RoomDetailsPage({
    Key? key,
    required this.hotel,
    required this.room,
  }) : super(key: key);

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  int selectedImageIndex = 0;

  // Sample room images - in a real app, these would come from the room data
  List<String> roomImages = [];

  @override
  void initState() {
    super.initState();
    // Initialize room images - in real app, get from room data
    roomImages = [
      widget.room['image'],
      // Add more sample images for the gallery
      'assets/images/room_deluxe.jpg',
      'assets/images/room_suite.jpg',
      'assets/images/room_presidential.jpg',
    ];
  }

  String get roomStatus {
    if (widget.room.containsKey('status') && widget.room['status'] != null) {
      return widget.room['status'];
    } else {
      return (widget.room['available'] == true) ? 'available' : 'booked';
    }
  }

  bool get isRoomAvailable => roomStatus == 'available';

  Color get statusColor {
    switch (roomStatus) {
      case 'available':
        return Colors.green;
      case 'maintenance':
        return Colors.orange;
      case 'booked':
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
      case 'booked':
        return 'Currently Booked';
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
                child: Image.asset(
                  roomImages[selectedImageIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.room['backgroundColor'],
                            widget.room['backgroundColor'].withOpacity(0.8),
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
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Thumbnail Images
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
                      child: Image.asset(
                        roomImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: widget.room['backgroundColor'].withOpacity(0.3),
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

  Widget _buildRoomSpecs() {
    int bedrooms = widget.room['bedrooms'] ?? 1;
    int bathrooms = widget.room['bathrooms'] ?? 1;
    int maxOccupancy = widget.room['maxOccupancy'] ?? _calculateMaxOccupancy(bedrooms);

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
                      widget.room['size'],
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
                      widget.room['bedType'],
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
    String roomType = widget.room['type'].toLowerCase();

    // Calculate based on room type and bedroom count
    if (roomType.contains('presidential') || roomType.contains('suite')) {
      return bedrooms * 3; // Suites can accommodate more people
    } else if (roomType.contains('deluxe') || roomType.contains('executive')) {
      return bedrooms * 2 + 1; // Deluxe rooms have extra capacity
    } else {
      return bedrooms * 2; // Standard rooms
    }
  }

  Widget _buildAmenitiesSection() {
    final amenities = widget.room['amenities'] as List<dynamic>;

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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: amenities.map<Widget>((amenity) {
              // Special styling for meal plan options
              bool isMealPlan = ['Full Board', 'Half Board', 'Bed and Breakfast', 'All-Inclusive', 'Room Only'].contains(amenity);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isMealPlan ? Colors.blue.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isMealPlan ? Colors.blue.shade200 : Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 16,
                      color: isMealPlan ? Colors.blue.shade600 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: TextStyle(
                        fontSize: 14,
                        color: isMealPlan ? Colors.blue.shade700 : Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodDetailsSection() {
    final amenities = widget.room['amenities'] as List<dynamic>;

    // Find the meal plan from room amenities
    String? mealPlan;
    for (String amenity in amenities) {
      if (['Full Board', 'Half Board', 'Bed and Breakfast', 'All-Inclusive', 'Room Only'].contains(amenity)) {
        mealPlan = amenity;
        break;
      }
    }

    if (mealPlan == null) return Container(); // Don't show section if no meal plan found

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
          Row(
            children: [
              Icon(Icons.restaurant, size: 24, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Meal Plan Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Meal Plan Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.local_dining, size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  mealPlan!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Meal Plan Details
          ..._getMealPlanDetails(mealPlan).map((detail) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      detail['included'] ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: detail['included'] ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (detail['description'] != null)
                            Text(
                              detail['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ).toList(),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getMealPlanNote(mealPlan),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMealPlanDetails(String mealPlan) {
    switch (mealPlan) {
      case 'Room Only':
        return [
          {'title': 'Breakfast', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Lunch', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Dinner', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Beverages', 'included': false, 'description': 'Minibar and restaurant beverages at extra cost'},
        ];
      case 'Bed and Breakfast':
        return [
          {'title': 'Breakfast', 'included': true, 'description': 'Daily breakfast buffet included'},
          {'title': 'Lunch', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Dinner', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Beverages', 'included': false, 'description': 'Complimentary tea/coffee, other beverages at extra cost'},
        ];
      case 'Half Board':
        return [
          {'title': 'Breakfast', 'included': true, 'description': 'Daily breakfast buffet included'},
          {'title': 'Lunch', 'included': false, 'description': 'Available for purchase at hotel restaurant'},
          {'title': 'Dinner', 'included': true, 'description': 'Daily dinner at hotel restaurant included'},
          {'title': 'Beverages', 'included': false, 'description': 'Complimentary tea/coffee, other beverages at extra cost'},
        ];
      case 'Full Board':
        return [
          {'title': 'Breakfast', 'included': true, 'description': 'Daily breakfast buffet included'},
          {'title': 'Lunch', 'included': true, 'description': 'Daily lunch at hotel restaurant included'},
          {'title': 'Dinner', 'included': true, 'description': 'Daily dinner at hotel restaurant included'},
          {'title': 'Beverages', 'included': false, 'description': 'Complimentary tea/coffee, other beverages at extra cost'},
        ];
      case 'All-Inclusive':
        return [
          {'title': 'Breakfast', 'included': true, 'description': 'Daily breakfast buffet included'},
          {'title': 'Lunch', 'included': true, 'description': 'Daily lunch at hotel restaurant included'},
          {'title': 'Dinner', 'included': true, 'description': 'Daily dinner at hotel restaurant included'},
          {'title': 'Beverages', 'included': true, 'description': 'House beverages, soft drinks, and selected alcoholic drinks'},
          {'title': 'Snacks', 'included': true, 'description': 'Afternoon snacks and light refreshments'},
        ];
      default:
        return [];
    }
  }

  String _getMealPlanNote(String mealPlan) {
    switch (mealPlan) {
      case 'Room Only':
        return 'This rate includes accommodation only. All meals and beverages are available for purchase at the hotel\'s restaurants and bars.';
      case 'Bed and Breakfast':
        return 'Breakfast is served daily from 6:30 AM to 10:30 AM at the hotel restaurant. Special dietary requirements can be accommodated.';
      case 'Half Board':
        return 'Breakfast (6:30-10:30 AM) and dinner (7:00-10:00 PM) are included. Lunch and beverages are available for purchase.';
      case 'Full Board':
        return 'All three meals are included: breakfast (6:30-10:30 AM), lunch (12:00-3:00 PM), and dinner (7:00-10:00 PM).';
      case 'All-Inclusive':
        return 'All meals, snacks, and selected beverages are included. Premium brands and room service may incur additional charges.';
      default:
        return '';
    }
  }

  IconData _getAmenityIcon(String amenity) {
    // Simple mapping of amenities to icons
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
      case 'full board':
      case 'half board':
      case 'bed and breakfast':
      case 'all-inclusive':
      case 'room only':
        return Icons.restaurant;
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
                widget.room['price'],
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
            'Taxes and fees included',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingRoomPage(
                      hotel: widget.hotel,
                      room: widget.room,
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
          widget.room['type'],
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [], // Remove the IconButton by setting actions to an empty list

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
                        widget.room['type'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.hotel['name']} • ${widget.hotel['location']}',
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

            // Food Details Section
            _buildFoodDetailsSection(),
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