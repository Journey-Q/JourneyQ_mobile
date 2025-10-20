// File: lib/features/marketplace/pages/booking_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/agency_repository.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

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
  AgencyProfile? agency;
  List<dynamic> vehicles = [];
  bool isLoading = true;
  bool hasError = false;

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

  void _loadAgencyData() async {
    try {
      print('🚗 Loading agency data for booking: ${widget.agencyId}');

      // Load agency profile
      final agencyData = await AgencyRepository.getAgencyProfileById(widget.agencyId);

      if (agencyData.id == 'unknown_id') {
        throw Exception('Could not find agency with ID: ${widget.agencyId}');
      }

      // Load vehicles for this agency
      await _loadVehicles(widget.agencyId);

      setState(() {
        agency = agencyData;
        if (vehicles.isNotEmpty) {
          final firstVehicle = vehicles[0];
          _selectedVehicle = firstVehicle['vehicleType'] ?? firstVehicle['type'] ?? 'Vehicle';
        }
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading agency data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadVehicles(String agencyId) async {
    try {
      print('🚗 Loading vehicles for agency: $agencyId');

      // Convert agencyId to Long (serviceProviderId)
      final serviceProviderId = int.tryParse(agencyId);
      if (serviceProviderId == null) {
        print('⚠ Invalid agency ID for vehicles: $agencyId');
        return;
      }

      final response = await MarketplaceService.get('/service/vehicles/service-provider/$serviceProviderId');

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            vehicles = response.data as List<dynamic>;
          });
          print('✅ Loaded ${vehicles.length} vehicles');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            setState(() {
              vehicles = responseMap['data'] as List<dynamic>;
            });
            print('✅ Loaded ${vehicles.length} vehicles from data field');
          }
        }
      } else {
        print('⚠ Failed to load vehicles: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading vehicles: $e');
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
    if (_selectedVehicle.isEmpty || vehicles.isEmpty) return 0;

    // Find the selected vehicle
    Map<String, dynamic>? selectedVehicleData;
    try {
      selectedVehicleData = vehicles.firstWhere(
            (vehicle) {
          final vehicleType = vehicle['vehicleType'] ?? vehicle['type'] ?? '';
          return vehicleType == _selectedVehicle;
        },
      ) as Map<String, dynamic>?;
    } catch (e) {
      // If vehicle not found, use the first vehicle as fallback
      if (vehicles.isNotEmpty) {
        selectedVehicleData = vehicles[0] as Map<String, dynamic>;
      } else {
        return 0; // No vehicles available
      }
    }

    if (selectedVehicleData == null) return 0;

    final pricePerKm = _isAcSelected
        ? (selectedVehicleData['acPricePerKm'] ?? selectedVehicleData['pricePerKm'] ?? 50) as int
        : (selectedVehicleData['nonAcPricePerKm'] ?? 40) as int;

    // Estimated 50km for booking
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
                'Your booking with ${agency!.name} has been confirmed.',
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
                    context.go('/marketplace');
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Book with ${agency!.name}'),
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
                        color: const Color(0xFF0088cc).withOpacity(0.1),
                      ),
                      child: const Icon(Icons.business, color: Color(0xFF0088cc), size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agency!.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              const Text('4.5'),
                              const SizedBox(width: 8),
                              Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                agency!.location ?? 'Colombo, Sri Lanka',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
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
              if (vehicles.isNotEmpty) ...[
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
                        final vehicleType = vehicle['vehicleType'] ?? vehicle['type'] ?? 'Vehicle';
                        final seats = vehicle['capacity'] ?? vehicle['seats'] ?? 4;
                        return DropdownMenuItem<String>(
                          value: vehicleType,
                          child: Row(
                            children: [
                              Icon(
                                _getVehicleIcon(vehicleType),
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
                                      vehicleType,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '$seats seats',
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
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text(
                      'No vehicles available for this agency',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],

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

              // Estimated Price
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