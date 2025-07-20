// File: lib/features/marketplace/pages/booking_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingAgencyPage extends StatefulWidget {
  final String agencyId;

  const BookingAgencyPage({
    Key? key,
    required this.agencyId,
  }) : super(key: key);

  @override
  State<BookingAgencyPage> createState() => _BookingAgencyPageState();
}

class _BookingAgencyPageState extends State<BookingAgencyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupLocationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _returnTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedVehicle = '';
  bool _isAcSelected = true;
  bool _isRoundTrip = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? agency;
  bool isLoading = true;
  bool hasError = false;

  // Agency database (same as travel_agency_details.dart)
  static final List<Map<String, dynamic>> _agencyDatabase = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'location': 'Colombo 03, Sri Lanka',
      'contact': '+94 11 234 5678',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'vehicles': [
        {'type': 'Car', 'seats': 4, 'acPricePerKm': 55, 'nonAcPricePerKm': 45},
        {'type': 'Van', 'seats': 8, 'acPricePerKm': 75, 'nonAcPricePerKm': 60},
        {'type': 'Mini Bus', 'seats': 15, 'acPricePerKm': 95, 'nonAcPricePerKm': 80},
      ],
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'location': 'Colombo 01, Sri Lanka',
      'contact': '+94 11 345 6789',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'vehicles': [
        {'type': 'Luxury Car', 'seats': 4, 'acPricePerKm': 65, 'nonAcPricePerKm': 50},
        {'type': 'Premium Van', 'seats': 8, 'acPricePerKm': 85, 'nonAcPricePerKm': 70},
        {'type': 'Coach Bus', 'seats': 25, 'acPricePerKm': 110, 'nonAcPricePerKm': 90},
      ],
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'location': 'Colombo 02, Sri Lanka',
      'contact': '+94 11 456 7890',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'vehicles': [
        {'type': 'Standard Car', 'seats': 4, 'acPricePerKm': 50, 'nonAcPricePerKm': 40},
        {'type': 'Family Van', 'seats': 8, 'acPricePerKm': 70, 'nonAcPricePerKm': 55},
        {'type': 'Tour Bus', 'seats': 20, 'acPricePerKm': 90, 'nonAcPricePerKm': 75},
      ],
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'location': 'Colombo 05, Sri Lanka',
      'contact': '+94 11 567 8901',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'vehicles': [
        {'type': 'Classic Car', 'seats': 4, 'acPricePerKm': 48, 'nonAcPricePerKm': 38},
        {'type': 'Tourist Van', 'seats': 10, 'acPricePerKm': 68, 'nonAcPricePerKm': 54},
      ],
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'location': 'Colombo 06, Sri Lanka',
      'contact': '+94 11 678 9012',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'vehicles': [
        {'type': 'Adventure Car', 'seats': 4, 'acPricePerKm': 52, 'nonAcPricePerKm': 42},
        {'type': 'Adventure Van', 'seats': 6, 'acPricePerKm': 72, 'nonAcPricePerKm': 58},
        {'type': 'Group Bus', 'seats': 18, 'acPricePerKm': 88, 'nonAcPricePerKm': 72},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAgencyData();
  }

  @override
  void dispose() {
    _pickupLocationController.dispose();
    _destinationController.dispose();
    _pickupDateController.dispose();
    _pickupTimeController.dispose();
    _returnDateController.dispose();
    _returnTimeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadAgencyData() {
    try {
      final agencyData = _getAgencyById(widget.agencyId);
      if (agencyData != null) {
        agency = agencyData;
        final vehicles = agency!['vehicles'] as List<dynamic>;
        if (vehicles.isNotEmpty) {
          _selectedVehicle = vehicles[0]['type'];
        }
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Map<String, dynamic>? _getAgencyById(String id) {
    try {
      return _agencyDatabase.firstWhere((agency) => agency['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0088cc),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0088cc),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0088cc)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0088cc), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  int _calculateEstimatedPrice() {
    if (_selectedVehicle.isEmpty || agency == null) return 0;

    final vehicles = agency!['vehicles'] as List<dynamic>;

    // Fix: Handle the case where vehicle is not found properly
    Map<String, dynamic>? selectedVehicleData;

    try {
      selectedVehicleData = vehicles.firstWhere(
            (vehicle) => vehicle['type'] == _selectedVehicle,
      ) as Map<String, dynamic>;
    } catch (e) {
      // If vehicle not found, use the first vehicle as fallback
      if (vehicles.isNotEmpty) {
        selectedVehicleData = vehicles[0] as Map<String, dynamic>;
      } else {
        return 0; // No vehicles available
      }
    }

    final pricePerKm = _isAcSelected
        ? selectedVehicleData['acPricePerKm'] as int
        : selectedVehicleData['nonAcPricePerKm'] as int;

    // Estimated 50km for booking (you can make this dynamic)
    int basePrice = pricePerKm * 50;

    if (_isRoundTrip) {
      basePrice *= 2;
    }

    return basePrice;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    _showBookingConfirmation();
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade50, Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your booking with ${agency!['name']} has been confirmed.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.confirmation_number, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text('Booking ID', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Text(
                      '#BK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0088cc)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/marketplace/travel_agencies');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Loading...'),
          backgroundColor: const Color(0xFF0088cc),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError || agency == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Agency Not Found'),
          backgroundColor: const Color(0xFF0088cc),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(
          child: Text('Travel Agency not found'),
        ),
      );
    }

    final vehicles = agency!['vehicles'] as List<dynamic>;

    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Book with ${agency!['name']}'),
          backgroundColor: const Color(0xFF0088cc),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Agency Info Card
              Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        agency!['image'] ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  agency!['backgroundColor'] ?? Colors.blue,
                                  (agency!['backgroundColor'] ?? Colors.blue).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.business, color: Colors.white, size: 24),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agency!['name'] ?? 'Travel Agency',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text('${agency!['rating'] ?? 4.5}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Trip Type
            const Text(
              'Trip Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isRoundTrip = false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: !_isRoundTrip ? const Color(0xFF0088cc) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF0088cc)),
                      ),
                      child: Text(
                        'One Way',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_isRoundTrip ? Colors.white : const Color(0xFF0088cc),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isRoundTrip = true),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isRoundTrip ? const Color(0xFF0088cc) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF0088cc)),
                      ),
                      child: Text(
                        'Round Trip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isRoundTrip ? Colors.white : const Color(0xFF0088cc),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Location Details
            const Text(
              'Location Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _pickupLocationController,
              label: 'Pickup Location',
              icon: Icons.location_on,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pickup location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _destinationController,
              label: 'Destination',
              icon: Icons.place,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter destination';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Date & Time Details
            const Text(
              'Date & Time Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _pickupDateController,
                    label: 'Pickup Date',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _selectDate(_pickupDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pickup date';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _pickupTimeController,
                    label: 'Pickup Time',
                    icon: Icons.access_time,
                    readOnly: true,
                    onTap: () => _selectTime(_pickupTimeController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pickup time';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            if (_isRoundTrip) ...[
        const SizedBox(height: 16),
    Row(
    children: [
    Expanded(
    child: _buildTextField(
    controller: _returnDateController,
    label: 'Return Date',
    icon: Icons.calendar_today,
    readOnly: true,
    onTap: () => _selectDate(_returnDateController),
    validator: (value) {
    if (_isRoundTrip && (value == null || value.isEmpty)) {
    return 'Please select return date';
    }
    return null;
    },
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: _buildTextField(
    controller: _returnTimeController,
    label: 'Return Time',
    icon: Icons.access_time,
    readOnly: true,
    onTap: () => _selectTime(_returnTimeController),
    validator: (value) {
    if (_isRoundTrip && (value == null || value.isEmpty)) {
    return 'Please select return time';
    }
    return null;
    },
    ),
    ),
    ],
    ),
    ],

    const SizedBox(height: 24),

    // Vehicle Selection
    const Text(
    'Vehicle Type',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 12),
    Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
    value: _selectedVehicle.isEmpty ? null : _selectedVehicle,
    isExpanded: true,
    icon: const Icon(Icons.keyboard_arrow_down),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    items: vehicles.map<DropdownMenuItem<String>>((vehicle) {
    return DropdownMenuItem<String>(
    value: vehicle['type'],
    child: Row(
    children: [
    Icon(
    _getVehicleIcon(vehicle['type']),
    color: const Color(0xFF0088cc),
    size: 20,
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
    Text(
    vehicle['type'],
    style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    Text(
    '${vehicle['seats']} seats',
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
    );
    }).toList(),
    onChanged: (String? newValue) {
    if (newValue != null) {
    setState(() {
    _selectedVehicle = newValue;
    });
    }
    },
    ),
    ),
    ),

    const SizedBox(height: 16),

    // AC/Non-AC Selection
    Row(
    children: [
    Expanded(
    child: GestureDetector(
    onTap: () => setState(() => _isAcSelected = true),
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: _isAcSelected ? const Color(0xFF0088cc) : Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFF0088cc)),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.ac_unit,
    color: _isAcSelected ? Colors.white : const Color(0xFF0088cc),
    size: 20,
    ),
    const SizedBox(width: 8),
    Text(
    'A/C',
    style: TextStyle(
    color: _isAcSelected ? Colors.white : const Color(0xFF0088cc),
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: GestureDetector(
    onTap: () => setState(() => _isAcSelected = false),
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: !_isAcSelected ? const Color(0xFF0088cc) : Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFF0088cc)),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.nature,
    color: !_isAcSelected ? Colors.white : const Color(0xFF0088cc),
    size: 20,
    ),
    const SizedBox(width: 8),
    Text(
    'Non A/C',
    style: TextStyle(
    color: !_isAcSelected ? Colors.white : const Color(0xFF0088cc),
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),

    const SizedBox(height: 24),

    // Personal Details
    const Text(
    'Personal Details',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 12),
    _buildTextField(
    controller: _nameController,
    label: 'Full Name',
    icon: Icons.person,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your full name';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),
    _buildTextField(
    controller: _phoneController,
    label: 'Phone Number',
    icon: Icons.phone,
    keyboardType: TextInputType.phone,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
    }
    if (value.length < 10) {
    return 'Please enter a valid phone number';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),
    _buildTextField(
    controller: _notesController,
    label: 'Additional Notes (Optional)',
    icon: Icons.note,
    maxLines: 3,
    ),

    const SizedBox(height: 24),


    Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    const Color(0xFF0088cc).withOpacity(0.1),
    const Color(0xFF0088cc).withOpacity(0.05),
    ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFF0088cc).withOpacity(0.3)),
    ),
    child: Column(
    children: [
    Row(
    children: [
    const Icon(Icons.calculate, color: Color(0xFF0088cc)),
    const SizedBox(width: 8),
    const Text(
    'Estimated Price',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    const Spacer(),
    Text(
    'Rs. ${_calculateEstimatedPrice()}',
    style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    ),
    ],
    ),
    const SizedBox(height: 8),
    Text(
    'Based on estimated 50km ${_isRoundTrip ? 'round trip' : 'one way'} journey',
    style: TextStyle(
    fontSize: 12,
    color: Colors.grey.shade600,
    ),
    ),
    ],
    ),
    ),

    const SizedBox(height: 32),

    // Book Now Button
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: _isSubmitting ? null : _submitBooking,
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF0088cc),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 18),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
    ),
    child: _isSubmitting
    ? const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 2,
    ),
    ),
    SizedBox(width: 12),
    Text(
    'Processing...',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    ],
    )
        : const Text(
    'Book Now',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    ),
    ),

    const SizedBox(height: 20),
    ],
    ),
    ),
    ),
    );
  }

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'car':
      case 'luxury car':
      case 'standard car':
      case 'classic car':
      case 'adventure car':
        return Icons.directions_car;
      case 'van':
      case 'premium van':
      case 'family van':
      case 'tourist van':
      case 'adventure van':
        return Icons.airport_shuttle;
      case 'mini bus':
      case 'coach bus':
      case 'tour bus':
      case 'group bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }
}