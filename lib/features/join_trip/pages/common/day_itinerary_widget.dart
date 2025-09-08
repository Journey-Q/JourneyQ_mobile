import 'package:flutter/material.dart';

class DayItineraryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> initialItinerary;
  final int totalDays;
  final bool isReadOnly;
  final Function(List<Map<String, dynamic>>)? onItineraryChanged;

  const DayItineraryWidget({
    super.key,
    required this.initialItinerary,
    required this.totalDays,
    this.isReadOnly = false,
    this.onItineraryChanged,
  });

  @override
  State<DayItineraryWidget> createState() => _DayItineraryWidgetState();
}

class _DayItineraryWidgetState extends State<DayItineraryWidget> {
  late List<Map<String, dynamic>> _itinerary;
  final PageController _pageController = PageController();
  int _currentDay = 0;

  @override
  void initState() {
    super.initState();
    _itinerary = _normalizeItineraryData(List.from(widget.initialItinerary));
  }

  // Helper method to ensure all list fields are properly typed
  List<Map<String, dynamic>> _normalizeItineraryData(List<Map<String, dynamic>> data) {
    return data.map((day) {
      return {
        'day': day['day'] ?? 1,
        'places': _ensureStringList(day['places']),
        'accommodations': _ensureStringList(day['accommodations']),
        'restaurants': _ensureStringList(day['restaurants']),
        'notes': day['notes']?.toString() ?? '',
      };
    }).toList();
  }

  List<String> _ensureStringList(dynamic value) {
    if (value == null) return <String>[];
    if (value is String && value.isNotEmpty) return [value];
    if (value is List) {
      return value.map((item) => item.toString()).where((str) => str.isNotEmpty).toList();
    }
    return <String>[];
  }

  Map<String, dynamic> _createEmptyDay(int dayNumber) {
    return {
      'day': dayNumber,
      'places': <String>[],
      'accommodations': <String>[],
      'restaurants': <String>[],
      'notes': '',
    };
  }

  void _updateItinerary() {
    if (widget.onItineraryChanged != null) {
      final filledDays = _itinerary.where((day) => _isDayFilled(day)).toList();
      widget.onItineraryChanged!(filledDays);
    }
  }

  bool _isDayFilled(Map<String, dynamic> day) {
    return (day['places'] as List).isNotEmpty ||
           (day['accommodations'] as List).isNotEmpty ||
           (day['restaurants'] as List).isNotEmpty ||
           day['notes'].toString().isNotEmpty;
  }

  void _editDay(int dayIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayEditSheet(
        day: _itinerary[dayIndex],
        isReadOnly: widget.isReadOnly,
        onSave: (updatedDay) {
          setState(() {
            _itinerary[dayIndex] = updatedDay;
          });
          _updateItinerary();
        },
      ),
    );
  }

  void _addNewDay() {
    if (_itinerary.length < widget.totalDays) {
      setState(() {
        _itinerary.add(_createEmptyDay(_itinerary.length + 1));
      });
      _updateItinerary();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients && _itinerary.isNotEmpty) {
          _pageController.animateToPage(
            _itinerary.length - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_itinerary.isEmpty && widget.isReadOnly) {
      return _buildEmptyState();
    }

    if (_itinerary.isEmpty && !widget.isReadOnly) {
      return _buildInitialAddDayState();
    }

    return Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with day indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day ${_currentDay + 1} of ${widget.totalDays}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0088cc),
                  ),
                ),
                if (!widget.isReadOnly && _itinerary.length < widget.totalDays)
                  TextButton.icon(
                    onPressed: _addNewDay,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Day'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0088cc),
                    ),
                  ),
              ],
            ),
          ),

          // Day cards with PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentDay = index;
                });
              },
              itemCount: _itinerary.length,
              itemBuilder: (context, index) {
                final day = _itinerary[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDayCard(day, index),
                );
              },
            ),
          ),

          // Navigation dots
          _buildNavigationDots(),
        ],
      ),
    );
  }

  Widget _buildInitialAddDayState() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[400], size: 32),
            const SizedBox(height: 12),
            Text(
              'Start planning your day-by-day itinerary',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addNewDay,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Day 1'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'No day-by-day itinerary added',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day, int index) {
    final isFilled = _isDayFilled(day);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFilled ? const Color(0xFF0088cc).withOpacity(0.3) : Colors.grey[200]!,
          width: isFilled ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.isReadOnly ? null : () => _editDay(index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFilled 
                            ? const Color(0xFF0088cc).withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Day ${day['day']}',
                        style: TextStyle(
                          color: isFilled ? const Color(0xFF0088cc) : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (!widget.isReadOnly)
                      Icon(
                        isFilled ? Icons.edit : Icons.add_circle_outline,
                        color: isFilled ? const Color(0xFF0088cc) : Colors.grey[400],
                        size: 20,
                      ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                if (!isFilled) ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.isReadOnly 
                                ? 'No plans for this day'
                                : 'Tap to add plans',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((day['places'] as List).isNotEmpty) ...[
                            _buildSectionTitle('Places', Icons.location_on),
                            _buildTagList(day['places']),
                            const SizedBox(height: 8),
                          ],
                          
                          if ((day['accommodations'] as List).isNotEmpty) ...[
                            _buildSectionTitle('Accommodations', Icons.hotel),
                            _buildTagList(day['accommodations']),
                            const SizedBox(height: 8),
                          ],
                          
                          if ((day['restaurants'] as List).isNotEmpty) ...[
                            _buildSectionTitle('Restaurants', Icons.restaurant),
                            _buildTagList(day['restaurants']),
                            const SizedBox(height: 8),
                          ],

                          if (day['notes'].toString().isNotEmpty) ...[
                            _buildSectionTitle('Notes', Icons.note),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                day['notes'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF0088cc)),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088cc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDots() {
    if (_itinerary.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_itinerary.length > 1 && _currentDay > 0)
            GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  _currentDay - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          
          ...List.generate(
            _itinerary.length,
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentDay == index ? 32 : 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _currentDay == index
                      ? const Color(0xFF0088cc)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _currentDay == index
                        ? const Color(0xFF0088cc)
                        : Colors.grey[400]!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _currentDay == index ? Colors.white : Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          if (_itinerary.length > 1 && _currentDay < _itinerary.length - 1)
            GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  _currentDay + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagList(List<dynamic> items) {
    final List<Widget> tagWidgets = items.take(3).map((item) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item.toString(),
        style: const TextStyle(fontSize: 11),
      ),
    )).toList();

    if (items.length > 3) {
      tagWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '+${items.length - 3}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tagWidgets,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Day Edit Sheet
class DayEditSheet extends StatefulWidget {
  final Map<String, dynamic> day;
  final bool isReadOnly;
  final Function(Map<String, dynamic>) onSave;

  const DayEditSheet({
    super.key,
    required this.day,
    required this.isReadOnly,
    required this.onSave,
  });

  @override
  State<DayEditSheet> createState() => _DayEditSheetState();
}

class _DayEditSheetState extends State<DayEditSheet> {
  late Map<String, dynamic> _editedDay;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _newPlaceController = TextEditingController();
  final TextEditingController _newAccommodationController = TextEditingController();
  final TextEditingController _newRestaurantController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedDay = _normalizeDay(Map.from(widget.day));
    _notesController.text = _editedDay['notes'] ?? '';
  }

  Map<String, dynamic> _normalizeDay(Map<String, dynamic> day) {
    return {
      'day': day['day'] ?? 1,
      'places': _ensureStringList(day['places']),
      'accommodations': _ensureStringList(day['accommodations']),
      'restaurants': _ensureStringList(day['restaurants']),
      'notes': day['notes']?.toString() ?? '',
    };
  }

  List<String> _ensureStringList(dynamic value) {
    if (value == null) return <String>[];
    if (value is String && value.isNotEmpty) return [value];
    if (value is List) {
      return value.map((item) => item.toString()).where((str) => str.isNotEmpty).toList();
    }
    return <String>[];
  }

  void _addItem(String key, String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        (_editedDay[key] as List).add(value.trim());
      });
    }
  }

  void _removeItem(String key, int index) {
    setState(() {
      (_editedDay[key] as List).removeAt(index);
    });
  }

  void _saveDay() {
    _editedDay['notes'] = _notesController.text;
    widget.onSave(_editedDay);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Day ${_editedDay['day']} Plans',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!widget.isReadOnly) ...[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveDay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088cc),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ] else ...[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildListSection(
                    'Places to Visit',
                    Icons.location_on,
                    'places',
                    _newPlaceController,
                    'Add a place...',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildListSection(
                    'Accommodations',
                    Icons.hotel,
                    'accommodations',
                    _newAccommodationController,
                    'Add accommodation...',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildListSection(
                    'Restaurants',
                    Icons.restaurant,
                    'restaurants',
                    _newRestaurantController,
                    'Add a restaurant...',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildTextFieldSection(
                    'Notes',
                    Icons.note,
                    _notesController,
                    'Any additional notes...',
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(
    String title,
    IconData icon,
    String key,
    TextEditingController controller,
    String hint,
  ) {
    final items = _editedDay[key] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0088cc), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        ...items.asMap().entries.map((entry) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(entry.value.toString()),
              ),
              if (!widget.isReadOnly)
                GestureDetector(
                  onTap: () => _removeItem(key, entry.key),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        )),
        
        if (!widget.isReadOnly)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _addItem(key, controller.text);
                  controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(60, 36),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTextFieldSection(
    String title,
    IconData icon,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0088cc), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          readOnly: widget.isReadOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _newPlaceController.dispose();
    _newAccommodationController.dispose();
    _newRestaurantController.dispose();
    super.dispose();
  }
}