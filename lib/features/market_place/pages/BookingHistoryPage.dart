import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/marketplace_repository/booking_history_repository.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({Key? key}) : super(key: key);

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedStatus = 'All';
  String selectedMonth = 'All Months';
  String selectedYear = '2025';

  // Loading and data states
  bool _isLoading = true;
  List<BookingHistory> _allBookings = [];
  String? _errorMessage;

  final List<String> statusOptions = [
    'All',
    'CONFIRMED',
    'COMPLETED',
    'CANCELLED',
    'PENDING'
  ];

  final List<String> monthOptions = [
    'All Months',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> yearOptions = ['2023', '2024', '2025'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookingHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookingHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final bookings = await BookingHistoryRepository.getUserBookingHistory(userId);

      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load booking history: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<BookingHistory> getFilteredBookings() {
    return _allBookings.where((booking) {
      bool statusMatch = selectedStatus == 'All' ||
          booking.status.toUpperCase() == selectedStatus.toUpperCase();

      bool monthMatch = selectedMonth == 'All Months';
      if (!monthMatch && booking.bookingCreatedDate != null) {
        monthMatch = _getMonthName(booking.bookingCreatedDate!.month) == selectedMonth;
      }

      bool yearMatch = true;
      if (booking.bookingCreatedDate != null) {
        yearMatch = booking.bookingCreatedDate!.year.toString() == selectedYear;
      }

      return statusMatch && monthMatch && yearMatch;
    }).toList();
  }

  List<BookingHistory> getBookingsByType(String type) {
    List<BookingHistory> filtered = getFilteredBookings();
    if (type == 'All') return filtered;
    return filtered.where((booking) => booking.bookingTypeLabel == type).toList();
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
        return Icons.hotel;
      case 'tour package':
        return Icons.tour;
      case 'travel agency':
        return Icons.directions_car;
      default:
        return Icons.book;
    }
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Status',
                  selectedStatus,
                  statusOptions,
                      (value) => setState(() => selectedStatus = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  'Month',
                  selectedMonth,
                  monthOptions,
                      (value) => setState(() => selectedMonth = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  'Year',
                  selectedYear,
                  yearOptions,
                      (value) => setState(() => selectedYear = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(BookingHistory booking) {
    bool isCompleted = booking.status.toUpperCase() == 'COMPLETED';

    return GestureDetector(
      onTap: () {
        _showBookingDetails(booking);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          children: [
            // Header with booking ID and status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BK-${booking.bookingId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0088cc),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Service icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088cc).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTypeIcon(booking.bookingTypeLabel),
                          color: const Color(0xFF0088cc),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Service details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.serviceProviderName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (booking.roomBookingDetails != null) ...[
                              Text(
                                booking.roomBookingDetails!.roomType,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${booking.roomBookingDetails!.numberOfNights} nights • ${booking.roomBookingDetails!.numberOfGuests} guests',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ] else if (booking.tourBookingDetails != null) ...[
                              Text(
                                booking.tourBookingDetails!.tourName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${booking.tourBookingDetails!.duration} days • ${booking.tourBookingDetails!.numberOfPeople} people',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ] else if (booking.vehicleBookingDetails != null) ...[
                              Text(
                                booking.vehicleBookingDetails!.vehicleName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${booking.vehicleBookingDetails!.estimatedKilometers} km',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'LKR ${booking.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (booking.bookingCreatedDate != null)
                                  Text(
                                    'Booked: ${_formatDate(booking.bookingCreatedDate!)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showBookingDetails(BookingHistory booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Booking Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Service details
                      _buildDetailRow('Booking ID', 'BK-${booking.bookingId}'),
                      _buildDetailRow('Service Type', booking.bookingTypeLabel),
                      _buildDetailRow('Service Name', booking.serviceProviderName),
                      _buildDetailRow('Customer Name', booking.customerName),
                      _buildDetailRow('Email', booking.customerEmail),
                      _buildDetailRow('Phone', booking.customerPhone),

                      if (booking.roomBookingDetails != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Room Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('Room Type', booking.roomBookingDetails!.roomType),
                        _buildDetailRow('Check-in', booking.startDate),
                        _buildDetailRow('Check-out', booking.endDate),
                        _buildDetailRow('Nights', booking.roomBookingDetails!.numberOfNights.toString()),
                        _buildDetailRow('Guests', booking.roomBookingDetails!.numberOfGuests.toString()),
                        _buildDetailRow('Price per Night', 'LKR ${booking.roomBookingDetails!.pricePerNight.toStringAsFixed(2)}'),
                      ] else if (booking.tourBookingDetails != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Tour Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('Tour Name', booking.tourBookingDetails!.tourName),
                        _buildDetailRow('Description', booking.tourBookingDetails!.tourDescription),
                        _buildDetailRow('Start Date', booking.startDate),
                        _buildDetailRow('End Date', booking.endDate),
                        _buildDetailRow('Duration', '${booking.tourBookingDetails!.duration} days'),
                        _buildDetailRow('People', booking.tourBookingDetails!.numberOfPeople.toString()),
                      ] else if (booking.vehicleBookingDetails != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Vehicle Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('Vehicle', booking.vehicleBookingDetails!.vehicleName),
                        _buildDetailRow('Type', booking.vehicleBookingDetails!.vehicleType),
                        _buildDetailRow('Start Date', booking.startDate),
                        _buildDetailRow('End Date', booking.endDate),
                        _buildDetailRow('Pickup', booking.vehicleBookingDetails!.pickupLocation),
                        _buildDetailRow('Dropoff', booking.vehicleBookingDetails!.dropoffLocation),
                        _buildDetailRow('Distance', '${booking.vehicleBookingDetails!.estimatedKilometers} km'),
                        _buildDetailRow('AC', booking.vehicleBookingDetails!.withAC ? 'Yes' : 'No'),
                      ],

                      const SizedBox(height: 16),
                      _buildDetailRow('Total Amount', 'LKR ${booking.totalAmount.toStringAsFixed(2)}'),
                      if (booking.bookingCreatedDate != null)
                        _buildDetailRow('Booked Date', _formatDate(booking.bookingCreatedDate!)),

                      if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Special Requests',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking.specialRequests!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],

                      if (booking.cancellationReason != null && booking.cancellationReason!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Cancellation Reason',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking.cancellationReason!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Close button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Booking History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: _isLoading
                ? const SizedBox.shrink()
                : TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF0088cc),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF0088cc),
                    indicatorWeight: 3,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'All (${getBookingsByType('All').length})'),
                      Tab(text: 'Hotels (${getBookingsByType('Hotel').length})'),
                      Tab(text: 'Tours (${getBookingsByType('Tour Package').length})'),
                      Tab(text: 'Agency (${getBookingsByType('Travel Agency').length})'),
                    ],
                  ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Bookings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadBookingHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildFilterSection(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildBookingList(getBookingsByType('All')),
                          _buildBookingList(getBookingsByType('Hotel')),
                          _buildBookingList(getBookingsByType('Tour Package')),
                          _buildBookingList(getBookingsByType('Travel Agency')),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildBookingList(List<BookingHistory> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookingHistory,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(bookings[index]);
        },
      ),
    );
  }
}
