import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  final List<String> statusOptions = [
    'All',
    'Confirmed',
    'Completed',
    'Cancelled',
    'Pending'
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

  // Sample booking data - in real app, this would come from API
  final List<Map<String, dynamic>> bookingHistory = [
    {
      'bookingId': 'BK-2025-0615-001',
      'type': 'Hotel',
      'serviceName': 'Shangri-La Hotel Colombo',
      'roomType': 'Deluxe Suite',
      'roomNumber': '#302',
      'guestName': 'John D. Silva',
      'email': 'john.silva@example.com',
      'checkIn': DateTime(2025, 6, 15),
      'checkOut': DateTime(2025, 6, 18),
      'guests': 2,
      'nights': 3,
      'amount': 135000.00,
      'currency': 'LKR',
      'status': 'Confirmed',
      'bookedDate': DateTime(2025, 5, 20),
      'image': 'assets/images/shangri_la.jpg',
    },
    {
      'bookingId': 'BK-2025-0612-002',
      'type': 'Hotel',
      'serviceName': 'Galle Face Hotel',
      'roomType': 'Standard Double',
      'roomNumber': '#215',
      'guestName': 'Alice M. Smith',
      'email': 'alice.smith@example.com',
      'checkIn': DateTime(2025, 6, 12),
      'checkOut': DateTime(2025, 6, 15),
      'guests': 1,
      'nights': 3,
      'amount': 90000.00,
      'currency': 'LKR',
      'status': 'Completed',
      'bookedDate': DateTime(2025, 5, 15),
      'image': 'assets/images/galle_face.jpg',
    },
    {
      'bookingId': 'BK-2025-0520-003',
      'type': 'Tour Package',
      'serviceName': 'Cultural Triangle Tour',
      'description': '5 Days • Anuradhapura, Polonnaruwa, Sigiriya',
      'guestName': 'Michael Johnson',
      'email': 'michael.johnson@example.com',
      'startDate': DateTime(2025, 5, 20),
      'endDate': DateTime(2025, 5, 25),
      'guests': 4,
      'duration': '5 Days',
      'amount': 100000.00,
      'currency': 'LKR',
      'status': 'Completed',
      'bookedDate': DateTime(2025, 4, 10),
      'image': 'assets/images/cultural_triangle.jpg',
    },
    {
      'bookingId': 'BK-2025-0718-004',
      'type': 'Travel Agency',
      'serviceName': 'Ceylon Roots',
      'service': 'Airport Transfer & City Tour',
      'guestName': 'Sarah Williams',
      'email': 'sarah.williams@example.com',
      'serviceDate': DateTime(2025, 7, 18),
      'guests': 2,
      'amount': 15000.00,
      'currency': 'LKR',
      'status': 'Pending',
      'bookedDate': DateTime(2025, 7, 10),
      'image': 'assets/images/ceylon_roots.jpg',
    },
    {
      'bookingId': 'BK-2025-0505-005',
      'type': 'Hotel',
      'serviceName': 'Cinnamon Grand Colombo',
      'roomType': 'Executive Room',
      'roomNumber': '#410',
      'guestName': 'David Brown',
      'email': 'david.brown@example.com',
      'checkIn': DateTime(2025, 5, 5),
      'checkOut': DateTime(2025, 5, 7),
      'guests': 2,
      'nights': 2,
      'amount': 80000.00,
      'currency': 'LKR',
      'status': 'Cancelled',
      'bookedDate': DateTime(2025, 4, 20),
      'image': 'assets/images/cinnamon_grand.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredBookings() {
    return bookingHistory.where((booking) {
      bool statusMatch = selectedStatus == 'All' ||
          booking['status'] == selectedStatus;

      bool monthMatch = selectedMonth == 'All Months' ||
          _getMonthName(booking['bookedDate'].month) == selectedMonth;

      bool yearMatch = booking['bookedDate'].year.toString() == selectedYear;

      return statusMatch && monthMatch && yearMatch;
    }).toList();
  }

  List<Map<String, dynamic>> getBookingsByType(String type) {
    List<Map<String, dynamic>> filtered = getFilteredBookings();
    if (type == 'All') return filtered;
    return filtered.where((booking) => booking['type'] == type).toList();
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
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
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _buildBookingCard(Map<String, dynamic> booking) {
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
                    booking['bookingId'],
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
                      color: _getStatusColor(booking['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking['status'],
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
              child: Row(
                children: [
                  // Service image/icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        booking['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0088cc).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getTypeIcon(booking['type']),
                              color: const Color(0xFF0088cc),
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Service details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['serviceName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (booking['type'] == 'Hotel') ...[
                          Text(
                            '${booking['roomType']} • ${booking['roomNumber']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${booking['nights']} nights • ${booking['guests']} guests',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ] else if (booking['type'] == 'Tour Package') ...[
                          Text(
                            booking['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${booking['duration']} • ${booking['guests']} guests',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ] else if (booking['type'] == 'Travel Agency') ...[
                          Text(
                            booking['service'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${booking['guests']} guests',
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
                              '${booking['currency']} ${booking['amount'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088cc),
                              ),
                            ),
                            Text(
                              'Booked: ${_formatDate(booking['bookedDate'])}',
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
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
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
                          Text(
                            'Booking Details',
                            style: const TextStyle(
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
                              color: _getStatusColor(booking['status']),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking['status'],
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
                      _buildDetailRow('Booking ID', booking['bookingId']),
                      _buildDetailRow('Service Type', booking['type']),
                      _buildDetailRow('Service Name', booking['serviceName']),
                      _buildDetailRow('Guest Name', booking['guestName']),
                      _buildDetailRow('Email', booking['email']),

                      if (booking['type'] == 'Hotel') ...[
                        _buildDetailRow('Room Type', booking['roomType']),
                        _buildDetailRow('Room Number', booking['roomNumber']),
                        _buildDetailRow('Check-in', _formatDate(booking['checkIn'])),
                        _buildDetailRow('Check-out', _formatDate(booking['checkOut'])),
                        _buildDetailRow('Nights', booking['nights'].toString()),
                      ] else if (booking['type'] == 'Tour Package') ...[
                        _buildDetailRow('Description', booking['description']),
                        _buildDetailRow('Start Date', _formatDate(booking['startDate'])),
                        _buildDetailRow('End Date', _formatDate(booking['endDate'])),
                        _buildDetailRow('Duration', booking['duration']),
                      ] else if (booking['type'] == 'Travel Agency') ...[
                        _buildDetailRow('Service', booking['service']),
                        _buildDetailRow('Service Date', _formatDate(booking['serviceDate'])),
                      ],

                      _buildDetailRow('Guests', booking['guests'].toString()),
                      _buildDetailRow('Amount', '${booking['currency']} ${booking['amount'].toStringAsFixed(2)}'),
                      _buildDetailRow('Booked Date', _formatDate(booking['bookedDate'])),

                      const SizedBox(height: 20),

                      // Action buttons
                      if (booking['status'] == 'Confirmed' || booking['status'] == 'Pending') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle booking cancellation
                              _showCancelBookingDialog(booking);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cancel Booking'),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

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

  void _showCancelBookingDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel booking ${booking['bookingId']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Handle cancellation logic here
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking ${booking['bookingId']} has been cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes, Cancel'),
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
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFF0088cc),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF0088cc),
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'All (${getBookingsByType('All').length})'),
                Tab(text: 'Hotels (${getBookingsByType('Hotel').length})'),
                Tab(text: 'Tours (${getBookingsByType('Tour Package').length})'),
                Tab(text: 'Agencies (${getBookingsByType('Travel Agency').length})'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
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

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }
}