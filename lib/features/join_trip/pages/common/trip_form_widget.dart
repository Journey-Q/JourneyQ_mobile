import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/common/day_itinerary_widget.dart';

enum TripFormMode { create, edit, view }

class TripFormWidget extends StatefulWidget {
  final TripFormMode mode;
  final Map<String, dynamic>? initialData;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final String? customTitle;
  final String? submitButtonText;
  final bool isGroupMember;

  const TripFormWidget({
    super.key,
    required this.mode,
    this.initialData,
    this.onSubmit,
    this.customTitle,
    this.submitButtonText,
    this.isGroupMember = false,
  });

  @override
  State<TripFormWidget> createState() => _TripFormWidgetState();
}

class _TripFormWidgetState extends State<TripFormWidget> {
  final _formKey = GlobalKey<FormState>();
  
  // Basic controllers
  late TextEditingController _titleController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  
  // Form state
  late String _selectedTripType;
  late List<Map<String, dynamic>> _dayByDayItinerary;
  int _calculatedDays = 0;
  bool _isLoading = false;
  
  // Trip types
  static const List<String> tripTypes = [
    'Cultural Heritage',
    'Hill Country Adventure', 
    'Beach & Coastal',
    'Wildlife Safari',
    'Tea Plantation Tour',
    'Ancient Cities',
    'Spiritual Journey',
  ];
  
  bool get _isReadOnly => widget.mode == TripFormMode.view;
  bool get _isEdit => widget.mode == TripFormMode.edit;
  bool get _isCreate => widget.mode == TripFormMode.create;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData ?? {};
    
    _titleController = TextEditingController(text: data['title'] ?? '');
    _startDateController = TextEditingController(text: data['startDate'] ?? '');
    _endDateController = TextEditingController(text: data['endDate'] ?? '');
    _locationController = TextEditingController(text: data['destination'] ?? '');
    _descriptionController = TextEditingController(text: data['description'] ?? '');
    _durationController = TextEditingController(text: data['duration'] ?? '');
    
    _selectedTripType = _validateTripType(data['tripType']);
    
    if (data['dayByDayItinerary'] != null && data['dayByDayItinerary'] is List) {
      _dayByDayItinerary = List<Map<String, dynamic>>.from(data['dayByDayItinerary']);
    } else {
      _dayByDayItinerary = <Map<String, dynamic>>[];
    }

    _calculateDaysFromDuration();
  }

  String _validateTripType(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return tripTypes.first;
    }
    
    String stringValue = value.toString();
    if (tripTypes.contains(stringValue)) {
      return stringValue;
    }
    
    return tripTypes.first;
  }

  void _calculateDaysFromDuration() {
    final durationText = _durationController.text.toLowerCase();
    if (durationText.contains('day')) {
      final match = RegExp(r'(\d+)').firstMatch(durationText);
      if (match != null) {
        _calculatedDays = int.parse(match.group(1)!);
      }
    }
    
    if (_calculatedDays == 0) {
      _calculateDuration();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller, String title) async {
    if (_isReadOnly) return;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: title,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0088cc),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
      _calculateDuration();
    }
  }

  void _calculateDuration() {
    if (_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty) {
      try {
        final startParts = _startDateController.text.split('/');
        final endParts = _endDateController.text.split('/');
        
        final startDate = DateTime(
          int.parse(startParts[2]),
          int.parse(startParts[1]),
          int.parse(startParts[0]),
        );
        
        final endDate = DateTime(
          int.parse(endParts[2]),
          int.parse(endParts[1]),
          int.parse(endParts[0]),
        );
        
        final difference = endDate.difference(startDate).inDays + 1;
        setState(() {
          _durationController.text = '$difference ${difference == 1 ? 'day' : 'days'}';
          _calculatedDays = difference;
        });
      } catch (e) {
        print('Error calculating duration: $e');
      }
    }
  }

  void _onItineraryChanged(List<Map<String, dynamic>> updatedItinerary) {
    setState(() {
      _dayByDayItinerary = updatedItinerary;
    });
  }

// Replace the _submitForm method in trip_form_widget.dart

void _submitForm() async {
  if (_isReadOnly) return;
  
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      final formData = <String, dynamic>{
        'title': _titleController.text,
        'destination': _locationController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'duration': _durationController.text,
        'tripType': _selectedTripType,
        'description': _descriptionController.text,
        'dayByDayItinerary': _dayByDayItinerary,
      };

      if (_isCreate) {
        formData['id'] = 'trip_${DateTime.now().millisecondsSinceEpoch}';
        formData['status'] = 'Active';
        formData['createdDate'] = 'Just now';
      }

      if (widget.onSubmit != null) {
        await widget.onSubmit!(formData);
      }

      if (mounted) {
        // CRITICAL FIX: Show success message first
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isCreate ? 'Trip created successfully!' : 'Trip updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // CRITICAL FIX: Navigate back with success result after delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context, true); // Return true for success
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.customTitle ?? _getDefaultTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isCreate)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Create Trip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the basic trip details. You can add more details later or collaborate with group members!',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              _buildSectionHeader('Trip Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _titleController,
                labelText: 'Trip Title',
                hintText: 'Amazing Adventure',
                prefixIcon: Icons.title,
                validator: _isReadOnly ? null : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _locationController,
                labelText: 'Destination',
                hintText: 'Amazing Place',
                prefixIcon: Icons.location_on,
                validator: _isReadOnly ? null : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Tell us about your trip...',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: _isReadOnly ? null : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Schedule'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _startDateController,
                      labelText: 'Start Date',
                      hintText: 'Select date',
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(_startDateController, 'Select Start Date'),
                      validator: _isReadOnly ? null : (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select start date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _endDateController,
                      labelText: 'End Date',
                      hintText: 'Select date',
                      prefixIcon: Icons.calendar_month,
                      readOnly: true,
                      onTap: () => _selectDate(_endDateController, 'Select End Date'),
                      validator: _isReadOnly ? null : (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select end date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _durationController,
                labelText: 'Duration',
                hintText: 'Auto-calculated',
                prefixIcon: Icons.schedule,
                readOnly: true,
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Trip Type'),
              const SizedBox(height: 16),

              _buildDropdownField(
                label: 'Trip Type',
                value: _selectedTripType,
                items: tripTypes,
                icon: Icons.category,
                enabled: !_isReadOnly,
                onChanged: (value) {
                  if (!_isReadOnly && value != null) {
                    setState(() {
                      _selectedTripType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              _buildSectionHeader('Day-by-Day Itinerary (Optional)'),
              const SizedBox(height: 8),
              
              Text(
                _calculatedDays > 0 
                    ? 'Plan your $_calculatedDays-day trip day by day. You can add plans for any days you want.'
                    : 'Add your trip dates to enable day-by-day planning.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              if (_calculatedDays > 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DayItineraryWidget(
                      initialItinerary: _dayByDayItinerary,
                      totalDays: _calculatedDays,
                      isReadOnly: _isReadOnly,
                      onItineraryChanged: _onItineraryChanged,
                    ),
                  ),
                )
              else
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: Text(
                      'Select trip dates to enable day-by-day planning',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              if (!_isReadOnly)
                _buildGradientButton(
                  text: widget.submitButtonText ?? _getSubmitButtonText(),
                  onPressed: _isLoading ? null : _submitForm,
                  isLoading: _isLoading,
                ),
              
              if (_isReadOnly)
                _buildGradientButton(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getDefaultTitle() {
    switch (widget.mode) {
      case TripFormMode.create:
        return 'Create Trip';
      case TripFormMode.edit:
        return 'Edit Trip';
      case TripFormMode.view:
        return 'Trip Details';
    }
  }

  String _getSubmitButtonText() {
    return _isCreate ? 'Create Trip' : 'Update Trip';
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly || _isReadOnly,
        maxLines: maxLines,
        onTap: onTap,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: _isReadOnly ? Colors.grey[700] : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              prefixIcon,
              color: _isReadOnly ? Colors.grey[500] : const Color(0xFF0088cc),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isReadOnly ? Colors.grey[400]! : const Color(0xFF0088cc),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: _isReadOnly ? Colors.grey[50] : Colors.grey[100],
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required bool enabled,
    required void Function(String?) onChanged,
  }) {
    String validValue = items.contains(value) ? value : items.first;
    
    return Container(
      decoration: BoxDecoration(
        color: _isReadOnly ? Colors.grey[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: validValue,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: _isReadOnly ? Colors.grey[500] : const Color(0xFF0088cc),
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isReadOnly ? Colors.grey[400]! : const Color(0xFF0088cc),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: _isReadOnly ? Colors.grey[50] : Colors.grey[100],
          labelStyle: TextStyle(color: Colors.grey[700]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14,
                color: _isReadOnly ? Colors.grey[700] : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088cc).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}