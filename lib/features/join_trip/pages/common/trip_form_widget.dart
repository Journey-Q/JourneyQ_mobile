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

  const TripFormWidget({
    super.key,
    required this.mode,
    this.initialData,
    this.onSubmit,
    this.customTitle,
    this.submitButtonText,
  });

  @override
  State<TripFormWidget> createState() => _TripFormWidgetState();
}

class _TripFormWidgetState extends State<TripFormWidget> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _maxMembersController;
  late TextEditingController _budgetController;
  late TextEditingController _durationController;
  late TextEditingController _meetingPointController;
  
  // Form state
  late String _selectedDifficulty;
  late String _selectedTripType;
  late String _selectedBudgetType;
  late List<String> _selectedActivities;
  bool _isLoading = false;
  
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
    _maxMembersController = TextEditingController(text: data['maxMembers']?.toString() ?? '');
    _budgetController = TextEditingController(text: data['budget'] ?? '');
    _durationController = TextEditingController(text: data['duration'] ?? '');
    _meetingPointController = TextEditingController(text: data['meetingPoint'] ?? '');
    
    // Initialize dropdown values with proper validation
    _selectedDifficulty = _validateAndSetDropdownValue(
      data['difficulty'], 
      SampleData.difficulties, 
      SampleData.difficulties.first
    );
    
    _selectedTripType = _validateAndSetDropdownValue(
      data['tripType'], 
      SampleData.tripTypes, 
      SampleData.tripTypes.first
    );
    
    _selectedBudgetType = _validateAndSetDropdownValue(
      data['budgetType'], 
      SampleData.budgetTypes, 
      SampleData.budgetTypes.first
    );
    
    _selectedActivities = List<String>.from(data['activities'] ?? []);
  }

  // Helper method to validate dropdown values
  String _validateAndSetDropdownValue(dynamic value, List<String> validOptions, String defaultValue) {
    if (value == null || value.toString().isEmpty) {
      return defaultValue;
    }
    
    String stringValue = value.toString();
    
    // Check if the value exists in valid options
    if (validOptions.contains(stringValue)) {
      return stringValue;
    }
    
    // If not found, try to find a close match or return default
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
    _maxMembersController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    _meetingPointController.dispose();
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
        // Handle parsing error
        print('Error calculating duration: $e');
      }
    }
  }

  void _selectActivities() {
    if (_isReadOnly) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Handle bar
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

      final formData = {
        'title': _titleController.text,
        'destination': _locationController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'duration': _durationController.text,
        'maxMembers': int.tryParse(_maxMembersController.text) ?? 0,
        'difficulty': _selectedDifficulty,
        'tripType': _selectedTripType,
        'description': _descriptionController.text,
        'budget': _budgetController.text,
        'budgetType': _selectedBudgetType,
        'activities': _selectedActivities,
        'meetingPoint': _meetingPointController.text,
      };

      if (_isCreate) {
        formData['id'] = 'form_${DateTime.now().millisecondsSinceEpoch}';
        formData['status'] = 'Active';
        formData['requestCount'] = 0;
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
        actions: _isReadOnly ? null : [
          TextButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.submitButtonText ?? (_isCreate ? 'Create' : 'Update'),
                    style: const TextStyle(
                      color: Color(0xFF0088cc),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Information Section
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

              // Schedule Section
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

              // Trip Details Section
              _buildSectionHeader('Trip Details'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Difficulty',
                      value: _selectedDifficulty,
                      items: SampleData.difficulties,
                      icon: Icons.trending_up,
                      enabled: !_isReadOnly,
                      onChanged: (value) {
                        if (!_isReadOnly && value != null) {
                          setState(() {
                            _selectedDifficulty = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _maxMembersController,
                labelText: 'Max Members',
                hintText: '8',
                prefixIcon: Icons.people,
                keyboardType: TextInputType.number,
                validator: _isReadOnly ? null : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter max members';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 2) {
                    return 'Must be at least 2 members';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Activities Section
              _buildSectionHeader('Activities'),
              const SizedBox(height: 16),

              _buildActivitiesSelector(),
              const SizedBox(height: 24),

              // Budget & Meeting Section
              _buildSectionHeader('Budget & Meeting'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _budgetController,
                labelText: 'Budget (USD)',
                hintText: 'e.g., 1500',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildDropdownField(
                label: 'Budget Type',
                value: _selectedBudgetType,
                items: SampleData.budgetTypes,
                icon: Icons.monetization_on,
                enabled: !_isReadOnly,
                onChanged: (value) {
                  if (!_isReadOnly && value != null) {
                    setState(() {
                      _selectedBudgetType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _meetingPointController,
                labelText: 'Meeting Point',
                hintText: 'Where to meet',
                prefixIcon: Icons.location_pin,
              ),
              const SizedBox(height: 32),

              // Submit Button (only show if not read-only)
              if (!_isReadOnly)
                buildPrimaryGradientButton(
                  text: widget.submitButtonText ?? (_isCreate ? 'Create Trip' : 'Update Trip'),
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
    switch (widget.mode) {
      case TripFormMode.create:
        return 'Create New Trip';
      case TripFormMode.edit:
        return 'Edit Trip Details';
      case TripFormMode.view:
        return 'Trip Details';
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
    // Ensure the value exists in the items list
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
                if (!_isReadOnly)
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