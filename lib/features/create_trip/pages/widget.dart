// widget.dart
import 'package:flutter/material.dart';
import 'package:journeyq/data/models/journey_model/joureny_model.dart'; // Fixed typo: joureny -> journey

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress bar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (index) {
                final isCompleted = index < currentStep;
                final isCurrent = index == currentStep;
                
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent ? Color(0xFF0088cc) : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                      if (index < totalSteps - 1)
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: index < currentStep ? Color(0xFF0088cc) : Colors.grey[300],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class ProfessionalTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final String? prefix;
  final String? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;

  const ProfessionalTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            enabled: enabled,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.black)
                  : null,
              prefixText: prefix,
              suffixText: suffix,
              prefixStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              suffixStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.white,
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
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfessionalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isLoading;

  const ProfessionalButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isPrimary && onPressed != null ? [
          BoxShadow(
            color: const Color(0xFF0088cc).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF0088cc) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF0088cc),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary ? BorderSide.none : const BorderSide(
              color: Color(0xFF0088cc),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: isLoading 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : const Color(0xFF0088cc),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF0088cc)),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Color(0xFF0088cc)),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getMoodColor(place.tripMood),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                place.tripMood,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF0088cc)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    place.location.address,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            if (place.images.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: place.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(place.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            if (place.activities.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Activities:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: place.activities.take(3).map((activity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088cc).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0088cc).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      activity,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (place.activities.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ ${place.activities.length - 3} more activities',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'adventure':
        return const Color(0xFFFF6B35);
      case 'cultural':
        return const Color(0xFF8B5CF6);
      case 'beach':
        return const Color(0xFF06B6D4);
      case 'nature':
        return const Color(0xFF10B981);
      case 'relaxation':
        return const Color(0xFF6366F1);
      case 'food':
        return const Color(0xFFEF4444);
      case 'shopping':
        return const Color(0xFFEC4899);
      case 'nightlife':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF0088cc);
    }
  }
}

class EmptyPlacesWidget extends StatelessWidget {
  const EmptyPlacesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_location_alt,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No places added yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button below to add amazing places to your trip',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  final Widget child;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinue;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: SizedBox(
            width: double.infinity,
            child: ProfessionalButton(
              text: 'Continue',
              onPressed: onContinue ?? () => Navigator.pop(context),
              isPrimary: true,
            ),
          ),
        ),
      ],
    );
  }
}

class BudgetBreakdownWidget extends StatelessWidget {
  final BudgetBreakdown budgetBreakdown;
  final Function(BudgetBreakdown) onChanged;

  const BudgetBreakdownWidget({
    Key? key,
    required this.budgetBreakdown,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How do you plan to spend your budget?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A8A),
            ),
          ), 
          const SizedBox(height: 16),
          
          // Total percentage indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getTotalColor() == Colors.green 
                    ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                    : _getTotalColor() == Colors.orange
                        ? [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]
                        : [const Color(0xFFEF4444), const Color(0xFFF87171)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Percentage:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_getTotal()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
 Widget _buildSlider(BuildContext context, String label, int value, Function(int) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E3A8A),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0088cc).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$value%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088cc),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
          activeTrackColor: const Color(0xFF0088cc),
          inactiveTrackColor: const Color(0xFF0088cc).withOpacity(0.2),
          thumbColor: const Color(0xFF0088cc),
          overlayColor: const Color(0xFF0088cc).withOpacity(0.2),
        ),
        child: Slider(
          value: value.toDouble(),
          min: 0.0,
          max: 100.0,
          divisions: 20,
          onChanged: (double newValue) => onChanged(newValue.round()),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
 

  int _getTotal() {
    return budgetBreakdown.accommodation +
           budgetBreakdown.food +
           budgetBreakdown.transport +
           budgetBreakdown.activities;
  }

  Color _getTotalColor() {
    final total = _getTotal();
    if (total == 100) return Colors.green;
    if (total < 100) return Colors.orange;
    return Colors.red;
  }
}

class EnhancedRecommendationsSection extends StatelessWidget {
  final OverallRecommendations recommendations;
  final Function(OverallRecommendations) onRecommendationsChanged;

  const EnhancedRecommendationsSection({
    Key? key,
    required this.recommendations,
    required this.onRecommendationsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          context,
          'Hotels',
          Icons.hotel,
          '🏨',
          recommendations.hotels,
          (items) => onRecommendationsChanged(
            recommendations.copyWith(hotels: items),
          ),
        ),
        
        const SizedBox(height: 16),
        
        _buildSection(
          context,
          'Restaurants',
          Icons.restaurant,
          '🍽️',
          recommendations.restaurants,
          (items) => onRecommendationsChanged(
            recommendations.copyWith(restaurants: items),
          ),
        ),
        
        const SizedBox(height: 16),
        
        _buildSection(
          context,
          'Transportation',
          Icons.directions_car,
          '🚗',
          recommendations.transportation,
          (items) => onRecommendationsChanged(
            recommendations.copyWith(transportation: items),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String emoji,
    List<RecommendationItem> items,
    Function(List<RecommendationItem>) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showAddRecommendationDialog(context, title, items, onChanged),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (items.isNotEmpty)
              ...items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0088cc).withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              item.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < item.rating ? Icons.star : Icons.star_border,
                                    color: const Color(0xFFF59E0B),
                                    size: 16,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final updatedItems = [...items];
                            updatedItems.remove(item);
                            onChanged(updatedItems);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ))
            else
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No $title added yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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

  void _showAddRecommendationDialog(
    BuildContext context,
    String title,
    List<RecommendationItem> items,
    Function(List<RecommendationItem>) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddRecommendationDialog(
        type: title,
        onRecommendationAdded: (recommendation) {
          final updatedItems = [...items, recommendation];
          onChanged(updatedItems);
        },
      ),
    );
  }
}

class AddRecommendationDialog extends StatefulWidget {
  final String type;
  final Function(RecommendationItem) onRecommendationAdded;

  const AddRecommendationDialog({
    Key? key,
    required this.type,
    required this.onRecommendationAdded,
  }) : super(key: key);

  @override
  State<AddRecommendationDialog> createState() => _AddRecommendationDialogState();
}

class _AddRecommendationDialogState extends State<AddRecommendationDialog> {
  final _nameController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Add ${widget.type}',
        style: const TextStyle(
          color: Color(0xFF1E3A8A),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfessionalTextFormField(
            controller: _nameController,
            label: '${widget.type} Name',
            hint: 'Enter name...',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          ProfessionalTextFormField(
            controller: _ratingController,
            label: 'Rating (1-5)',
            hint: '4.5',
            icon: Icons.star,
            keyboardType: TextInputType.number,
            suffix: '★',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ProfessionalButton(
          text: 'Add',
          onPressed: _saveRecommendation,
          isPrimary: true,
        ),
      ],
    );
  }

  void _saveRecommendation() {
    if (_nameController.text.trim().isNotEmpty && _ratingController.text.trim().isNotEmpty) {
      final rating = double.tryParse(_ratingController.text);
      if (rating != null && rating >= 1 && rating <= 5) {
        final recommendation = RecommendationItem(
          name: _nameController.text.trim(),
          rating: rating,
        );
        widget.onRecommendationAdded(recommendation);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid rating between 1 and 5'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}



class EnhancedTipsSection extends StatefulWidget {
  final List<String> tips;
  final Function(List<String>) onTipsChanged;

  const EnhancedTipsSection({
    Key? key,
    required this.tips,
    required this.onTipsChanged,
  }) : super(key: key);

  @override
  _EnhancedTipsSectionState createState() => _EnhancedTipsSectionState();
}

class _EnhancedTipsSectionState extends State<EnhancedTipsSection> {
  final TextEditingController _tipController = TextEditingController();
  bool _isAddingTip = false;

  @override
  void dispose() {
    _tipController.dispose();
    super.dispose();
  }

  void _startAddingTip() {
    setState(() {
      _isAddingTip = true;
    });
  }

  void _cancelAddingTip() {
    setState(() {
      _isAddingTip = false;
      _tipController.clear();
    });
  }

  void _addTip() {
    if (_tipController.text.trim().isNotEmpty) {
      final updatedTips = [...widget.tips, _tipController.text.trim()];
      widget.onTipsChanged(updatedTips);
      setState(() {
        _isAddingTip = false;
        _tipController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF0088cc),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Travel Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (!_isAddingTip)
                  GestureDetector(
                    onTap: _startAddingTip,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088cc),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Add Tip Input
            if (_isAddingTip)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tipController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your tip...',
                          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onFieldSubmitted: (_) => _addTip(),
                      ),
                    ),
                    IconButton(
                      onPressed: _addTip,
                      icon: const Icon(Icons.check, color: Color(0xFF0088cc), size: 20),
                    ),
                    IconButton(
                      onPressed: _cancelAddingTip,
                      icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
              ),
            if (_isAddingTip) const SizedBox(height: 16),
            // Existing Tips List
            if (widget.tips.isNotEmpty)
              ...widget.tips.asMap().entries.map((entry) {
                final index = entry.key;
                final tip = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0088cc),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final updatedTips = [...widget.tips];
                          updatedTips.removeAt(index);
                          widget.onTipsChanged(updatedTips);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              })
            else if (!_isAddingTip)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No tips yet. Add one!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}