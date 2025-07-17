import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';
import 'package:journeyq/features/join_trip/pages/widget.dart';

enum TripFormMode { create, edit, view }

class TripFormWidget extends StatefulWidget {
  final TripFormMode mode;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>)? onSubmit;
  final String? customTitle;
  final String? submitButtonText;
  final bool isGroupMember; // Controls whether to show advanced options

  const TripFormWidget({
    super.key,
    required this.mode,
    this.initialData,
    this.onSubmit,
    this.customTitle,
    this.submitButtonText,
    this.isGroupMember = false, // Default to basic form
  });

  @override
  State<TripFormWidget> createState() => _TripFormWidgetState();
}

class _TripFormWidgetState extends State<TripFormWidget> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for basic trip info (always visible)
  late TextEditingController _titleController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  
  // Controllers for advanced trip info (only for group members)
  late TextEditingController _maxMembersController;
  late TextEditingController _travelBudgetController;
  late TextEditingController _foodBudgetController;
  late TextEditingController _hotelBudgetController;
  late TextEditingController _otherBudgetController;
  late TextEditingController _meetingPointController;
  late TextEditingController _customActivityController;
  
  // Form state
  late String _selectedTripType;
  late List<String> _selectedActivities;
  bool _isLoading = false;
  
  bool get _isReadOnly => widget.mode == TripFormMode.view;
  bool get _isEdit => widget.mode == TripFormMode.edit;
  bool get _isCreate => widget.mode == TripFormMode.create;
  
  // Key logic: Show advanced options only for group members
  bool get _showAdvancedOptions => widget.isGroupMember;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData ?? {};
    
    // Basic trip information (always available)
    _titleController = TextEditingController(text: data['title'] ?? '');
    _startDateController = TextEditingController(text: data['startDate'] ?? '');
    _endDateController = TextEditingController(text: data['endDate'] ?? '');
    _locationController = TextEditingController(text: data['destination'] ?? '');
    _descriptionController = TextEditingController(text: data['description'] ?? '');
    _durationController = TextEditingController(text: data['duration'] ?? '');
    
    // Advanced options (only for group members)
    _maxMembersController = TextEditingController(text: data['maxMembers']?.toString() ?? '');
    _travelBudgetController = TextEditingController(text: data['travelBudget'] ?? '');
    _foodBudgetController = TextEditingController(text: data['foodBudget'] ?? '');
    _hotelBudgetController = TextEditingController(text: data['hotelBudget'] ?? '');
    _otherBudgetController = TextEditingController(text: data['otherBudget'] ?? '');
    _meetingPointController = TextEditingController(text: data['meetingPoint'] ?? '');
    _customActivityController = TextEditingController();
    
    // Initialize dropdown values
    _selectedTripType = _validateAndSetDropdownValue(
      data['tripType'], 
      SampleData.tripTypes, 
      SampleData.tripTypes.first
    );
    
    // Safely initialize activities list
    if (data['activities'] != null) {
      if (data['activities'] is List) {
        _selectedActivities = List<String>.from(data['activities']);
      } else {
        _selectedActivities = <String>[];
      }
    } else {
      _selectedActivities = <String>[];
    }
  }

  String _validateAndSetDropdownValue(dynamic value, List<String> validOptions, String defaultValue) {
    if (value == null || value.toString().isEmpty) {
      return defaultValue;
    }
    
    String stringValue = value.toString();
    
    if (validOptions.contains(stringValue)) {
      return stringValue;
    }
    
    print('Warning: Dropdown value "$stringValue" not found in options. Using default: $defaultValue');
    return defaultValue;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _maxMembersController.dispose();
    _travelBudgetController.dispose();
    _foodBudgetController.dispose();
    _hotelBudgetController.dispose();
    _otherBudgetController.dispose();
    _meetingPointController.dispose();
    _customActivityController.dispose();
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
        });
      } catch (e) {
        print('Error calculating duration: $e');
      }
    }
  }

  void _selectActivities() {
    if (_isReadOnly || !_showAdvancedOptions) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
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
                'Select Activities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Custom Activity Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Custom Activity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0088cc),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customActivityController,
                            decoration: const InputDecoration(
                              hintText: 'Enter activity name...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final customActivity = _customActivityController.text.trim();
                            if (customActivity.isNotEmpty && 
                                !_selectedActivities.contains(customActivity)) {
                              setModalState(() {
                                _selectedActivities.add(customActivity);
                                _customActivityController.clear();
                              });
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088cc),
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Popular Activities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              Expanded(
                child: ListView.builder(
                  itemCount: SampleData.activities.length,
                  itemBuilder: (context, index) {
                    final activity = SampleData.activities[index];
                    final isSelected = _selectedActivities.contains(activity);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[50] : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          activity,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        value: isSelected,
                        activeColor: const Color(0xFF0088cc),
                        onChanged: (bool? value) {
                          setModalState(() {
                            if (value ?? false) {
                              _selectedActivities.add(activity);
                            } else {
                              _selectedActivities.remove(activity);
                            }
                          });
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088cc),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
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

  void _submitForm() async {
    if (_isReadOnly) return;
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Basic trip data (always included)
      final formData = <String, dynamic>{
        'title': _titleController.text,
        'destination': _locationController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'duration': _durationController.text,
        'tripType': _selectedTripType,
        'description': _descriptionController.text,
      };

      // Advanced data (only if user is group member)
      if (_showAdvancedOptions) {
        formData.addAll({
          'maxMembers': _maxMembersController.text,
          'travelBudget': _travelBudgetController.text,
          'foodBudget': _foodBudgetController.text,
          'hotelBudget': _hotelBudgetController.text,
          'otherBudget': _otherBudgetController.text,
          'activities': _selectedActivities,
          'meetingPoint': _meetingPointController.text,
        });
      }

      if (_isCreate) {
        formData['id'] = 'form_${DateTime.now().millisecondsSinceEpoch}';
        formData['status'] = 'Draft';
        formData['requestCount'] = '0';
        formData['createdDate'] = 'Just now';
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (widget.onSubmit != null) {
        widget.onSubmit!(formData);
      }

      if (mounted) {
        if (_isCreate && !_showAdvancedOptions) {
          // For basic trip creation, show follower selection
          _showFollowerSelection(formData);
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isCreate ? 'Trip created successfully!' : 'Trip updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _showFollowerSelection(Map<String, dynamic> tripData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FollowerSelectionSheet(
        tripData: tripData,
        onSendRequests: (selectedFollowers) {
          Navigator.pop(context); // Close follower selection
          Navigator.pop(context); // Close trip form
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Trip created and requests sent to ${selectedFollowers.length} followers!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
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
        // Removed actions - using bottom button instead
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice for basic vs advanced mode
              if (_isCreate && !_showAdvancedOptions)
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
                            'Create Basic Trip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start with basic details. After forming a group, you and your members can add budget, activities, and other details together!',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              if (_showAdvancedOptions)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.group, color: Colors.green[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Group Trip Planning',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'As a group member, you can edit all trip details including budget, activities, and group size. Plan together!',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              // Basic Trip Information Section (Always visible)
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

              // Schedule Section (Always visible)
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

              // Trip Type Section (Always visible)
              _buildSectionHeader('Trip Type'),
              const SizedBox(height: 16),

              _buildDropdownField(
                label: 'Trip Type',
                value: _selectedTripType,
                items: SampleData.tripTypes,
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

              // Advanced Options (Only for group members)
              if (_showAdvancedOptions) ...[
                const SizedBox(height: 32),
                
                // Advanced Options Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Advanced Group Options',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24),
                
                _buildSectionHeader('Group Details'),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _maxMembersController,
                  labelText: 'Max Members',
                  hintText: '8',
                  prefixIcon: Icons.people,
                  keyboardType: TextInputType.number,
                  validator: _isReadOnly ? null : (value) {
                    if (value != null && value.isNotEmpty) {
                      if (int.tryParse(value) == null || int.parse(value) < 2) {
                        return 'Must be at least 2 members';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Activities'),
                const SizedBox(height: 16),

                _buildActivitiesSelector(),
                const SizedBox(height: 24),

                _buildSectionHeader('Budget Details'),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _travelBudgetController,
                  labelText: 'Travel Budget (USD)',
                  hintText: 'e.g., 500',
                  prefixIcon: Icons.flight,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _foodBudgetController,
                  labelText: 'Food Budget (USD)',
                  hintText: 'e.g., 300',
                  prefixIcon: Icons.restaurant,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _hotelBudgetController,
                  labelText: 'Hotel Budget (USD)',
                  hintText: 'e.g., 700',
                  prefixIcon: Icons.hotel,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _otherBudgetController,
                  labelText: 'Other Expenses (USD)',
                  hintText: 'e.g., 200',
                  prefixIcon: Icons.more_horiz,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _meetingPointController,
                  labelText: 'Meeting Point',
                  hintText: 'Where to meet',
                  prefixIcon: Icons.location_pin,
                ),
              ],

              const SizedBox(height: 32),

              // Submit Button
              if (!_isReadOnly)
                buildPrimaryGradientButton(
                  text: widget.submitButtonText ?? _getSubmitButtonText(),
                  onPressed: _isLoading ? null : _submitForm,
                  isLoading: _isLoading,
                  gradientColors: const [Color(0xFF0088cc), Color(0xFF00B4DB)],
                ),
              
              if (_isReadOnly)
                buildPrimaryGradientButton(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                  gradientColors: const [Color(0xFF0088cc), Color(0xFF00B4DB)],
                ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getDefaultTitle() {
    if (_showAdvancedOptions) {
      switch (widget.mode) {
        case TripFormMode.create:
          return 'Create Group Trip';
        case TripFormMode.edit:
          return 'Edit Group Trip';
        case TripFormMode.view:
          return 'Group Trip Details';
      }
    } else {
      switch (widget.mode) {
        case TripFormMode.create:
          return 'Create Basic Trip';
        case TripFormMode.edit:
          return 'Edit Trip';
        case TripFormMode.view:
          return 'Trip Details';
      }
    }
  }

  String _getSubmitButtonText() {
    if (_isCreate) {
      return _showAdvancedOptions ? 'Update & Notify' : 'Create & Send';
    } else {
      return _showAdvancedOptions ? 'Update & Notify Group' : 'Update';
    }
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

  Widget _buildActivitiesSelector() {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isReadOnly ? null : _selectActivities,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.local_activity,
                    color: _isReadOnly ? Colors.grey[500] : const Color(0xFF0088cc),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedActivities.isEmpty 
                            ? 'No activities selected' 
                            : '${_selectedActivities.length} activities selected',
                        style: TextStyle(
                          color: _selectedActivities.isEmpty ? Colors.grey[500] : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_selectedActivities.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedActivities.take(3).map((activity) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088cc).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                activity,
                                style: const TextStyle(
                                  color: Color(0xFF0088cc),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_selectedActivities.length > 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '+${_selectedActivities.length - 3} more',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                if (!_isReadOnly && _showAdvancedOptions)
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Follower Selection Sheet Widget
class FollowerSelectionSheet extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final Function(List<Map<String, dynamic>>) onSendRequests;

  const FollowerSelectionSheet({
    super.key,
    required this.tripData,
    required this.onSendRequests,
  });

  @override
  State<FollowerSelectionSheet> createState() => _FollowerSelectionSheetState();
}

class _FollowerSelectionSheetState extends State<FollowerSelectionSheet> {
  List<Map<String, dynamic>> _selectedFollowers = [];
  
  // Sample followers data
  final List<Map<String, dynamic>> _followers = [
    {
      'id': 'follower_1',
      'name': 'Alex Johnson',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'isOnline': true,
    },
    {
      'id': 'follower_2',
      'name': 'Maria Rodriguez',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,
    },
    {
      'id': 'follower_3',
      'name': 'John Smith',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'isOnline': true,
    },
    {
      'id': 'follower_4',
      'name': 'Emma Wilson',
      'avatar': 'https://i.pravatar.cc/150?img=16',
      'isOnline': false,
    },
    {
      'id': 'follower_5',
      'name': 'Sarah Lee',
      'avatar': 'https://i.pravatar.cc/150?img=15',
      'isOnline': true,
    },
    {
      'id': 'follower_6',
      'name': 'Mike Chen',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
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
            'Send Trip Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Select followers to invite for "${widget.tripData['title']}"',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          if (_selectedFollowers.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Color(0xFF0088cc),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedFollowers.length} followers selected',
                    style: const TextStyle(
                      color: Color(0xFF0088cc),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          Expanded(
            child: ListView.builder(
              itemCount: _followers.length,
              itemBuilder: (context, index) {
                final follower = _followers[index];
                final isSelected = _selectedFollowers.any((f) => f['id'] == follower['id']);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue[200]! : Colors.grey[200]!,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          _selectedFollowers.add(follower);
                        } else {
                          _selectedFollowers.removeWhere((f) => f['id'] == follower['id']);
                        }
                      });
                    },
                    activeColor: const Color(0xFF0088cc),
                    title: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(follower['avatar']),
                            ),
                            if (follower['isOnline'])
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                follower['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                follower['isOnline'] ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: follower['isOnline'] ? Colors.green : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedFollowers.isEmpty 
                      ? null 
                      : () => widget.onSendRequests(_selectedFollowers),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _selectedFollowers.isEmpty 
                        ? 'Select Followers' 
                        : 'Send Requests (${_selectedFollowers.length})',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}