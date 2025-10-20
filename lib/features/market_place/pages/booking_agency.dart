// File: lib/features/marketplace/pages/booking_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/repositories/marketplace_repository/agency_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/vehicle_booking_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
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
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _estimatedKmController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int? _selectedVehicleId; // Changed to use vehicle ID instead of vehicle type
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
    _returnDateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _estimatedKmController.dispose();
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
          _selectedVehicleId = firstVehicle['id'] as int?;
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
    if (_selectedVehicleId == null || vehicles.isEmpty) return 0;

    // Find the selected vehicle by ID
    Map<String, dynamic>? selectedVehicleData;
    try {
      selectedVehicleData = vehicles.firstWhere(
        (vehicle) => vehicle['id'] == _selectedVehicleId,
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

    // Validate that a vehicle is selected
    if (_selectedVehicleId == null || vehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a vehicle'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final vehicleId = _selectedVehicleId!;

      // Get user ID from auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Parse dates from DD/MM/YYYY format
      final startDate = _parseDateFromFormat(_pickupDateController.text);
      final endDate = _parseDateFromFormat(_returnDateController.text);

      // Get estimated kilometers (default to 50 if empty)
      final estimatedKm = int.tryParse(_estimatedKmController.text) ?? 50;

      // Create booking DTO
      final bookingData = VehicleBookingRepository.createBookingData(
        vehicleId: vehicleId,
        userId: userId,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        startDate: startDate,
        endDate: endDate,
        pickupLocation: _pickupLocationController.text.trim(),
        dropoffLocation: _destinationController.text.trim(),
        estimatedKilometers: estimatedKm,
        withAC: _isAcSelected,
        specialRequests: _notesController.text.trim(),
      );

      // Submit booking to API
      final response = await VehicleBookingRepository.createVehicleBooking(bookingData);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        _showBookingConfirmation(response);
      }
    } catch (e) {
      print('❌ Booking error: $e');

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  DateTime _parseDateFromFormat(String dateStr) {
    // Parse DD/MM/YYYY format
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  void _showBookingConfirmation(VehicleBookingResponse response) {
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
                response.message,
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
                      response.bookingId,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0088cc)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(response.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            response.statusDisplay,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Total',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Rs. ${response.estimatedTotalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088cc),
                          ),
                        ),
                      ],
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
                      label: 'Start Date',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_pickupDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select start date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _returnDateController,
                      label: 'End Date',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_returnDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select end date';
                        }

                        // Validate that end date is after or equal to start date
                        if (_pickupDateController.text.isNotEmpty) {
                          final startDate = _parseDateFromFormat(_pickupDateController.text);
                          final endDate = _parseDateFromFormat(value);

                          if (endDate.isBefore(startDate)) {
                            return 'End date must be after start date';
                          }
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

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
                    child: DropdownButton<int>(
                      value: _selectedVehicleId,
                      hint: const Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.grey, size: 20),
                          SizedBox(width: 12),
                          Text('Select a vehicle', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      items: vehicles.map<DropdownMenuItem<int>>((vehicle) {
                        final vehicleId = vehicle['id'] as int;
                        final vehicleType = vehicle['vehicleType'] ?? vehicle['type'] ?? 'Vehicle';
                        final seats = vehicle['capacity'] ?? vehicle['seats'] ?? 4;
                        return DropdownMenuItem<int>(
                          value: vehicleId,
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
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedVehicleId = newValue;
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
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
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
                controller: _estimatedKmController,
                label: 'Estimated Kilometers',
                icon: Icons.speed,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter estimated kilometers';
                  }
                  final km = int.tryParse(value);
                  if (km == null || km < 1) {
                    return 'Please enter a valid distance';
                  }
                  if (km > 10000) {
                    return 'Distance cannot exceed 10000 km';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: 'Special Requests (Optional)',
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}