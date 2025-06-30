// File: lib/features/marketplace/pages/book_package_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookPackagePage extends StatefulWidget {
  final Map<String, dynamic> package;

  const BookPackagePage({
    Key? key,
    required this.package,
  }) : super(key: key);

  @override
  State<BookPackagePage> createState() => _BookPackagePageState();
}

class _BookPackagePageState extends State<BookPackagePage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Booking Details
  DateTime? _selectedDate;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;

  // Personal Information
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  // Special Requirements
  final TextEditingController _specialRequirementsController = TextEditingController();
  bool _vegetarianMeals = false;
  bool _wheelchairAccess = false;

  // Payment
  String _selectedPaymentMethod = 'card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default date to tomorrow
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _specialRequirementsController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    final basePrice = double.parse(
      widget.package['price'].replaceAll('LKR ', '').replaceAll(',', ''),
    );
    return basePrice * (_adults + _children * 0.7 + _infants * 0.1);
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0088cc),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      height: 80,
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i <= _currentStep
                    ? const Color(0xFF0088cc)
                    : Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: i <= _currentStep ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (i < 3)
              Expanded(
                child: Container(
                  height: 2,
                  color: i < _currentStep
                      ? const Color(0xFF0088cc)
                      : Colors.grey[300],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088cc),
            ),
          ),
          const SizedBox(height: 20),

          // Date Selection
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF0088cc)),
              title: const Text('Travel Date'),
              subtitle: Text(
                _selectedDate != null
                    ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                    : 'Select travel date',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _selectDate,
            ),
          ),
          const SizedBox(height: 16),

          // Travelers Count
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Number of Travelers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Adults
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adults', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('Age 12+', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _adults > 1 ? () => setState(() => _adults--) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$_adults', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => _adults++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Children
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Children', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('Age 2-11', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _children > 0 ? () => setState(() => _children--) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$_children', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => _children++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Infants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Infants', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('Under 2', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _infants > 0 ? () => setState(() => _infants--) : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('$_infants', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => _infants++),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Price Summary
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.package['title']}'),
                      Text('LKR ${NumberFormat('#,###').format(_totalPrice)}'),
                    ],
                  ),
                  if (_children > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Children ($_children × 70%)'),
                        Text('Included'),
                      ],
                    ),
                  ],
                  if (_infants > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Infants ($_infants × 10%)'),
                        Text('Included'),
                      ],
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'LKR ${NumberFormat('#,###').format(_totalPrice)}',
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
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088cc),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
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

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.emergency),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Special Requirements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              title: const Text('Vegetarian Meals'),
              value: _vegetarianMeals,
              onChanged: (value) => setState(() => _vegetarianMeals = value!),
            ),

            CheckboxListTile(
              title: const Text('Wheelchair Access'),
              value: _wheelchairAccess,
              onChanged: (value) => setState(() => _wheelchairAccess = value!),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _specialRequirementsController,
              decoration: const InputDecoration(
                labelText: 'Other Requirements',
                border: OutlineInputBorder(),
                hintText: 'Any other special requirements...',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088cc),
            ),
          ),
          const SizedBox(height: 20),

          // Payment Methods
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Credit/Debit Card'),
                  subtitle: const Text('Visa, Mastercard, Amex'),
                  value: 'card',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                ),
                RadioListTile<String>(
                  title: const Text('Bank Transfer'),
                  subtitle: const Text('Direct bank transfer'),
                  value: 'bank',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_selectedPaymentMethod == 'card') ...[
            TextFormField(
              controller: _cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Cardholder Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],

          if (_selectedPaymentMethod == 'bank') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Transfer Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Bank: Commercial Bank of Ceylon'),
                    const Text('Account Name: JourneyQ Travel Ltd'),
                    const Text('Account Number: 8007123456789'),
                    const Text('Branch: Colombo Main'),
                    const SizedBox(height: 12),
                    const Text(
                      'Please use your booking reference as the transfer reference.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Confirmation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088cc),
            ),
          ),
          const SizedBox(height: 20),

          // Package Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              widget.package['backgroundColor'],
                              widget.package['backgroundColor'].withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Icon(
                          widget.package['icon'],
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.package['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.package['subtitle'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Booking Details
                  _buildDetailRow('Travel Date', DateFormat('MMM dd, yyyy').format(_selectedDate!)),
                  _buildDetailRow('Duration', widget.package['duration']),
                  _buildDetailRow('Travelers', '${_adults + _children + _infants} person(s)'),
                  _buildDetailRow('Adults', '$_adults'),
                  if (_children > 0) _buildDetailRow('Children', '$_children'),
                  if (_infants > 0) _buildDetailRow('Infants', '$_infants'),

                  const Divider(height: 32),

                  // Personal Info
                  _buildDetailRow('Name', _nameController.text),
                  _buildDetailRow('Email', _emailController.text),
                  _buildDetailRow('Phone', _phoneController.text),

                  const Divider(height: 32),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'LKR ${NumberFormat('#,###').format(_totalPrice)}',
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
          ),
          const SizedBox(height: 20),

          // Terms and Conditions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Cancellation must be made 48 hours before travel date\n'
                        '• 50% refund for cancellations made 24-48 hours before\n'
                        '• No refund for same-day cancellations\n'
                        '• Travel insurance is recommended\n'
                        '• ID verification required at check-in',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Book Package'),
        backgroundColor: const Color(0xFF0088cc),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildStepIndicator(),
            ),
          ),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBookingDetailsStep(),
                _buildPersonalInfoStep(),
                _buildPaymentStep(),
                _buildConfirmationStep(),
              ],
            ),
          ),

          // Bottom Navigation
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep == 3) {
                        // Final booking confirmation
                        _showBookingConfirmation();
                      } else if (_currentStep == 1 && _formKey.currentState?.validate() == false) {
                        // Don't proceed if form is invalid
                        return;
                      } else {
                        _nextStep();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088cc),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Confirm Booking' : 'Next',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        title: const Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your booking has been successfully confirmed.'),
            const SizedBox(height: 16),
            Text(
              'Booking Reference: JQ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088cc),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A confirmation email has been sent to your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to packages
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}