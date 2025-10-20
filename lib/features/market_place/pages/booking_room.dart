// File: lib/features/marketplace/pages/booking_room.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/marketplace_repository/booking_repository.dart';

class BookingRoomPage extends StatefulWidget {
  final Map<String, dynamic>? hotel;
  final Map<String, dynamic>? room;

  const BookingRoomPage({Key? key, this.hotel, this.room}) : super(key: key);

  @override
  State<BookingRoomPage> createState() => _BookingRoomPageState();
}

class _BookingRoomPageState extends State<BookingRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  // Payment controllers
  final _cardHolderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _billingAddressController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;
  int _nights = 1;
  bool _isLoading = false;
  bool _showPaymentSection = false;

  late Map<String, dynamic> hotelData;
  late Map<String, dynamic> roomData;

  @override
  void initState() {
    super.initState();
    hotelData = widget.hotel ?? _getDefaultHotelData();
    roomData = widget.room ?? _getDefaultRoomData();

    // Set default dates (tomorrow and day after - backend requires future dates)
    _checkInDate = DateTime.now().add(const Duration(days: 1));
    _checkOutDate = DateTime.now().add(const Duration(days: 2));
    _calculateNights();

    // Debug: Print received data
    print('🏨 BookingRoomPage - Hotel Data: $hotelData');
    print('🏨 BookingRoomPage - Room Data: $roomData');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _billingAddressController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getDefaultHotelData() {
    return {
      'name': 'Unknown Hotel',
      'location': 'Unknown Location',
      'contact': 'Not available',
      'email': 'Not available',
    };
  }

  Map<String, dynamic> _getDefaultRoomData() {
    return {
      'displayRoomType': 'Standard Room',
      'formattedPrice': 'LKR 0.00/night',
      'size': 'Standard',
      'imageUrl': '',
      'amenities': ['Standard Amenities'],
    };
  }

  void _calculateNights() {
    if (_checkInDate != null && _checkOutDate != null) {
      setState(() {
        _nights = _checkOutDate!.difference(_checkInDate!).inDays;
        if (_nights < 1) _nights = 1;
      });
    }
  }

  double _getRoomBasePrice() {
    // Handle different price formats
    if (roomData['price'] is double) {
      return roomData['price'] as double;
    } else if (roomData['price'] is int) {
      return (roomData['price'] as int).toDouble();
    } else if (roomData['price'] is String) {
      String priceStr = roomData['price'].toString();
      RegExp regex = RegExp(r'[\d,]+\.?\d*');
      String numericStr = regex.firstMatch(priceStr)?.group(0) ?? '0';
      return double.tryParse(numericStr.replaceAll(',', '')) ?? 0;
    } else if (roomData['formattedPrice'] is String) {
      String priceStr = roomData['formattedPrice'].toString();
      RegExp regex = RegExp(r'[\d,]+\.?\d*');
      String numericStr = regex.firstMatch(priceStr)?.group(0) ?? '0';
      return double.tryParse(numericStr.replaceAll(',', '')) ?? 0;
    }
    return 0.0;
  }

  double _calculateTotalAmount() {
    double basePrice = _getRoomBasePrice();
    double roomSubtotal = basePrice * _nights;

    double taxes = roomSubtotal * 0.12; // 12% tax
    double serviceCharge = roomSubtotal * 0.10; // 10% service charge

    return roomSubtotal + taxes + serviceCharge;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    // Backend requires future dates, so minimum is tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkInDate ?? tomorrow)
          : (_checkOutDate ?? tomorrow.add(const Duration(days: 1))),
      firstDate: tomorrow, // Must be in the future (backend @Future validation)
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
        if (isCheckIn) {
          _checkInDate = picked;
          // Ensure check-out is at least 1 day after check-in
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
        _calculateNights();
      });
    }
  }

  void _showGuestSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Number of Guests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _guests > 1 ? () {
                          setModalState(() {
                            _guests--;
                          });
                        } : null,
                        icon: Icon(
                          Icons.remove_circle,
                          color: _guests > 1 ? const Color(0xFF0088cc) : Colors.grey,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0088cc)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_guests',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0088cc),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        onPressed: _guests < 6 ? () {
                          setModalState(() {
                            _guests++;
                          });
                        } : null,
                        icon: Icon(
                          Icons.add_circle,
                          color: _guests < 6 ? const Color(0xFF0088cc) : Colors.grey,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // _guests is already updated above
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088cc),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (_checkInDate == null || _checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select check-in and check-out dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate payment section if shown
    if (_showPaymentSection) {
      if (_cardHolderNameController.text.isEmpty ||
          _cardNumberController.text.isEmpty ||
          _expiryMonthController.text.isEmpty ||
          _expiryYearController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _billingAddressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all payment details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      // Payment details are required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add payment details to complete the booking'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get user ID from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId;

      if (userId == null) {
        throw Exception('User not authenticated. Please log in to continue.');
      }

      // Get room ID from roomData and ensure it's an integer
      final roomIdRaw = roomData['id'] ?? roomData['roomId'];
      if (roomIdRaw == null) {
        throw Exception('Room ID not found');
      }

      // Parse roomId ensuring it's an integer (backend expects Long)
      int roomId;
      if (roomIdRaw is int) {
        roomId = roomIdRaw;
      } else if (roomIdRaw is String) {
        roomId = int.parse(roomIdRaw);
      } else {
        roomId = int.parse(roomIdRaw.toString());
      }

      print('🔢 Type Check - roomId: $roomId (${roomId.runtimeType}), userId: $userId (${userId.runtimeType})');

      // Create card details DTO (combine month/year to MM/YYYY format)
      final expiryMonth = _expiryMonthController.text.trim().padLeft(2, '0');
      final expiryYear = _expiryYearController.text.trim();
      final expiryDate = '$expiryMonth/$expiryYear';

      final cardDetails = CardDetailsDTO(
        cardHolderName: _cardHolderNameController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        expiryDate: expiryDate,
        cvv: _cvvController.text.trim(),
        billingAddress: _billingAddressController.text.trim(),
      );

      // Create booking data with userId from AuthProvider
      final bookingData = BookingRepository.createBookingData(
        roomId: roomId,
        userId: userId,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        numberOfGuests: _guests,
        specialRequests: _specialRequestsController.text.trim().isEmpty
            ? 'None'
            : _specialRequestsController.text.trim(),
        cardDetails: cardDetails,
      );

      print('🏨 Submitting booking for room ID: $roomId, user ID: $userId');

      // Call API to create booking
      final response = await BookingRepository.createRoomBooking(bookingData);

      print('✅ Booking created successfully: ${response.bookingId}');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show confirmation popup with actual booking response
        _showBookingConfirmationDialog(response: response);
      }
    } catch (e) {
      print('❌ Error creating booking: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Parse error message to check for 409 status code
        String errorMessage;
        String errorTitle = 'Booking Failed';

        final errorString = e.toString();

        // Check for 409 Conflict error (room already booked)
        if (errorString.contains('409') || errorString.contains('Conflict')) {
          errorTitle = 'Room Not Available';
          errorMessage = 'This room is already booked for the selected dates. Please select different dates or choose another room.';
        } else if (errorString.contains('400') || errorString.contains('Bad Request')) {
          errorTitle = 'Invalid Booking Details';
          errorMessage = 'Please check your booking details and try again.';
        } else if (errorString.contains('401') || errorString.contains('Unauthorized')) {
          errorTitle = 'Authentication Required';
          errorMessage = 'Please log in again to continue.';
        } else if (errorString.contains('500') || errorString.contains('Server')) {
          errorTitle = 'Server Error';
          errorMessage = 'Something went wrong on our end. Please try again later.';
        } else {
          errorMessage = 'Failed to create booking. Please try again.';
        }

        // Show detailed error dialog instead of snackbar
        _showErrorDialog(errorTitle, errorMessage);
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Optionally navigate back to room selection
                        if (title.contains('Not Available')) {
                          Navigator.of(context).pop(); // Go back to room details
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088cc),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        title.contains('Not Available') ? 'Choose Another' : 'Try Again',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingConfirmationDialog({required BookingResponse response}) {
    // Format dates for display
    final checkInFormatted = '${response.checkInDate.day}/${response.checkInDate.month}/${response.checkInDate.year}';
    final checkOutFormatted = '${response.checkOutDate.day}/${response.checkOutDate.month}/${response.checkOutDate.year}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                response.message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.confirmation_number, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Booking Reference',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      response.bookingId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0088cc),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBookingDetailRow('Status', response.statusDisplay),
                    _buildBookingDetailRow('Hotel', hotelData['name'] ?? 'Unknown Hotel'),
                    _buildBookingDetailRow('Room', roomData['displayRoomType'] ?? roomData['roomType'] ?? 'Standard Room'),
                    _buildBookingDetailRow('Check-in', checkInFormatted),
                    _buildBookingDetailRow('Check-out', checkOutFormatted),
                    _buildBookingDetailRow('Nights', '${response.numberOfNights}'),
                    _buildBookingDetailRow('Guests', '${response.numberOfGuests}'),
                    _buildBookingDetailRow('Card', response.maskedCardNumber),
                    const Divider(),
                    _buildBookingDetailRow('Total', 'LKR ${response.totalAmount.toStringAsFixed(2)}', isTotal: true),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? const Color(0xFF0088cc) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool isPaymentField = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      obscureText: isPaymentField && label.toLowerCase().contains('cvv'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0088cc)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0088cc), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: const Color(0xFF0088cc), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Card Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildTextField(
            controller: _cardHolderNameController,
            label: 'Card Holder Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card holder name';
              }
              return null;
            },
            isPaymentField: true,
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _cardNumberController,
            label: 'Card Number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              if (value.length < 16) {
                return 'Please enter a valid card number';
              }
              return null;
            },
            isPaymentField: true,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _expiryMonthController,
                  label: 'Month (MM)',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final month = int.tryParse(value);
                    if (month == null || month < 1 || month > 12) {
                      return 'Invalid month';
                    }
                    return null;
                  },
                  isPaymentField: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _expiryYearController,
                  label: 'Year (YYYY)',
                  icon: Icons.event,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final year = int.tryParse(value);
                    final currentYear = DateTime.now().year;
                    if (year == null || year < currentYear || year > currentYear + 20) {
                      return 'Invalid year';
                    }
                    return null;
                  },
                  isPaymentField: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 3 || value.length > 4) {
                      return 'Invalid CVV';
                    }
                    return null;
                  },
                  isPaymentField: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _billingAddressController,
            label: 'Billing Address',
            icon: Icons.location_on_outlined,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter billing address';
              }
              return null;
            },
            isPaymentField: true,
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.security, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment information is secure and encrypted',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
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

  Widget _buildRoomImage() {
    if (roomData['imageUrl'] != null && roomData['imageUrl'].toString().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          roomData['imageUrl'].toString(),
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
        ),
      );
    }
    return _buildRoomPlaceholder();
  }

  Widget _buildRoomPlaceholder() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0088cc),
            const Color(0xFF0088cc).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.bed,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Book Room',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0088cc),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
              // Room Summary Card with Image
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Room Image
                    _buildRoomImage(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomData['displayRoomType'] ?? roomData['roomType'] ?? 'Standard Room',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hotelData['name'] ?? 'Unknown Hotel',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (roomData['size'] != null && roomData['size'].toString().isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Text(
                                    roomData['size'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                roomData['formattedPrice'] ?? roomData['price']?.toString() ?? 'LKR 0.00/night',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0088cc),
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
              const SizedBox(height: 30),

              // Booking Details
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Date Selection Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Color(0xFF0088cc), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Check-in',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _checkInDate != null
                                  ? '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}'
                                  : 'Select date',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
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
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Color(0xFF0088cc), size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Check-out',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _checkOutDate != null
                                  ? '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}'
                                  : 'Select date',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Number of Guests
              GestureDetector(
                onTap: _showGuestSelector,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF0088cc), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Number of Guests',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_guests guest${_guests > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Guest Information
              const Text(
                'Guest Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Form Fields
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
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
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _specialRequestsController,
                label: 'Special Requests (Optional)',
                icon: Icons.note_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Payment Section Toggle
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
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
                          'Payment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showPaymentSection = !_showPaymentSection;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showPaymentSection ? Colors.grey : const Color(0xFF0088cc),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _showPaymentSection ? 'Hide Payment' : 'Add Payment',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showPaymentSection
                          ? 'Enter your payment details below'
                          : 'Click "Add Payment" to enter payment details',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Details Section
              if (_showPaymentSection) ...[
                _buildPaymentSection(),
                const SizedBox(height: 20),
              ],

              // Booking Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('$_nights night${_nights > 1 ? 's' : ''} × ${roomData['formattedPrice'] ?? roomData['price'] ?? 'LKR 0.00/night'}',
                        'LKR ${(_getRoomBasePrice() * _nights).toStringAsFixed(2)}'),

                    const SizedBox(height: 8),
                    _buildSummaryRow('Service Charge (10%)',
                        'LKR ${((_getRoomBasePrice() * _nights) * 0.10).toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Taxes (12%)',
                        'LKR ${((_getRoomBasePrice() * _nights) * 0.12).toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'LKR ${_calculateTotalAmount().toStringAsFixed(2)}',
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
              const SizedBox(height: 40),

              // Confirm Booking Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
}