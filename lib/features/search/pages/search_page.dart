import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Sri Lankan search data extracted from your journey data
final List<Map<String, dynamic>> search_data = [
  // Travellers from journey data
  {
    'title': 'Samantha Fernando',
    'subtitle': 'Cultural Triangle Explorer',
    'image': 'https://i.pravatar.cc/150?img=25',
    'type': 'traveller',
    'id': 'samantha_fernando',
  },
  {
    'title': 'Kasun Ratnayake',
    'subtitle': 'Cultural Heritage Guide',
    'image': 'https://i.pravatar.cc/150?img=42',
    'type': 'traveller',
    'id': 'kasun_ratnayake',
  },
  {
    'title': 'Tharaka Wijesinghe',
    'subtitle': 'Coastal Adventure Specialist',
    'image': 'https://i.pravatar.cc/150?img=33',
    'type': 'traveller',
    'id': 'tharaka_wijesinghe',
  },
  {
    'title': 'Anjali Mendis',
    'subtitle': 'Hill Country Tea Expert',
    'image': 'https://i.pravatar.cc/150?img=27',
    'type': 'traveller',
    'id': 'anjali_mendis',
  },
  {
    'title': 'Dinesh Jayawardena',
    'subtitle': 'Wildlife Safari Guide',
    'image': 'https://i.pravatar.cc/150?img=39',
    'type': 'traveller',
    'id': 'dinesh_jayawardena',
  },
  {
    'title': 'Chamara Gunasekara',
    'subtitle': 'Mountain Hiking Expert',
    'image': 'https://i.pravatar.cc/150?img=34',
    'type': 'traveller',
    'id': 'chamara_gunasekara',
  },
  {
    'title': 'Nadeesha Silva',
    'subtitle': 'Beach Paradise Guide',
    'image': 'https://i.pravatar.cc/150?img=28',
    'type': 'traveller',
    'id': 'nadeesha_silva',
  },
  {
    'title': 'Priya Weerasinghe',
    'subtitle': 'Sacred Mountain Pilgrim',
    'image': 'https://i.pravatar.cc/150?img=35',
    'type': 'traveller',
    'id': 'priya_weerasinghe',
  },
  {
    'title': 'Ruwan Perera',
    'subtitle': 'Ancient Heritage Explorer',
    'image': 'https://i.pravatar.cc/150?img=41',
    'type': 'traveller',
    'id': 'ruwan_perera',
  },
  {
    'title': 'Suranga Bandara',
    'subtitle': 'Surf Adventure Expert',
    'image': 'https://i.pravatar.cc/150?img=36',
    'type': 'traveller',
    'id': 'suranga_bandara',
  },

  // Journey trips from journey data
  {
    'title': 'Ancient Wonders of Cultural Triangle',
    'subtitle': '6 days exploring Sigiriya, Dambulla & Polonnaruwa',
    'image': 'assets/images/img1.jpg',
    'type': 'journey',
    'id': '1',
    'author': 'Samantha Fernando',
    'budget': 85000,
    'duration': 6,
  },
  {
    'title': 'Cultural Heart of Sri Lanka',
    'subtitle': '4 days in Kandy discovering Buddhist heritage',
    'image': 'assets/images/img11.jpg',
    'type': 'journey',
    'id': '2',
    'author': 'Kasun Ratnayake',
    'budget': 65000,
    'duration': 4,
  },
  {
    'title': 'Colonial Charm & Coastal Beauty',
    'subtitle': '5 days exploring Galle Fort and southern beaches',
    'image': 'assets/images/img12.jpg',
    'type': 'journey',
    'id': '3',
    'author': 'Tharaka Wijesinghe',
    'budget': 75000,
    'duration': 5,
  },
  {
    'title': 'Hill Country Tea Trail Adventure',
    'subtitle': '5 days in Ella experiencing tea culture',
    'image': 'assets/images/img14.jpg',
    'type': 'journey',
    'id': '4',
    'author': 'Anjali Mendis',
    'budget': 70000,
    'duration': 5,
  },
  {
    'title': 'Wildlife Safari Adventure',
    'subtitle': '4 days in Yala spotting leopards and elephants',
    'image': 'assets/images/img6.jpg',
    'type': 'journey',
    'id': '5',
    'author': 'Dinesh Jayawardena',
    'budget': 95000,
    'duration': 4,
  },
  {
    'title': 'Little England in the Hills',
    'subtitle': '4 days in Nuwara Eliya\'s cool climate',
    'image': 'assets/images/img31.jpg',
    'type': 'journey',
    'id': '6',
    'author': 'Chamara Gunasekara',
    'budget': 80000,
    'duration': 4,
  },
  {
    'title': 'Mirissa Beach Paradise',
    'subtitle': '3 days of whale watching and beach relaxation',
    'image': 'assets/images/mirissa_beach.jpg',
    'type': 'journey',
    'id': '7',
    'author': 'Nadeesha Silva',
    'budget': 45000,
    'duration': 3,
  },
  {
    'title': 'Sacred Adams Peak Pilgrimage',
    'subtitle': '2 days spiritual journey to holy summit',
    'image': 'assets/images/adams_peak.jpg',
    'type': 'journey',
    'id': '8',
    'author': 'Priya Weerasinghe',
    'budget': 25000,
    'duration': 2,
  },
  {
    'title': 'Ancient Anuradhapura Heritage',
    'subtitle': '3 days exploring the first capital',
    'image': 'assets/images/anuradhapura.jpeg',
    'type': 'journey',
    'id': '9',
    'author': 'Ruwan Perera',
    'budget': 40000,
    'duration': 3,
  },
  {
    'title': 'Arugam Bay Surf Paradise',
    'subtitle': '4 days surfing world-class waves',
    'image': 'assets/images/arugam_bay.jpg',
    'type': 'journey',
    'id': '10',
    'author': 'Suranga Bandara',
    'budget': 55000,
    'duration': 4,
  },
];

// Search widget for the search bar (without back button)
class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search travellers and journeys...',
    this.controller,
    this.onChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late FocusNode _focusNode;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Listen to controller changes to show/hide clear button
    if (widget.controller != null) {
      widget.controller!.addListener(_onTextChanged);
      _showClearButton = widget.controller!.text.isNotEmpty;
    }

    // Auto-focus when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        _showClearButton = widget.controller?.text.isNotEmpty ?? false;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
            ),
          ),
          // Clear button
          if (_showClearButton)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
              onPressed: () {
                widget.controller?.clear();
                widget.onChanged?.call('');
              },
            ),
        ],
      ),
    );
  }
}

// Search page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];
  bool isSearching = false;

  final List<Map<String, dynamic>> allSearchItems = search_data;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredItems = [];
      } else {
        filteredItems = allSearchItems.where((item) {
          final title = item['title']?.toString().toLowerCase() ?? '';
          final subtitle = item['subtitle']?.toString().toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();

          return title.contains(searchQuery) || subtitle.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _onItemTap(Map<String, dynamic> item) {
    final itemType = item['type']?.toString() ?? '';
    
    // Navigate based on item type
    switch (itemType) {
      case 'traveller':
        // Navigate to user profile page using the correct route path
        final userId = item['id']?.toString() ?? '';
        final userName = Uri.encodeComponent(item['title']?.toString() ?? '');
        context.push('/user-profile/$userId/$userName');
        break;
        
      case 'journey':
        // Navigate to journey details page
        final journeyId = item['id']?.toString() ?? '';
        context.push('/journey/$journeyId');
        break;
        
      default:
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${item['title']}'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Row(
          children: [
            Text(
              'Search ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search travellers and journeys...',
          ),
          const SizedBox(height: 8),
          // Search results
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Show empty state when not searching
    if (!isSearching || _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Discover Sri Lanka',
              style: TextStyle(fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for travellers and amazing journeys',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show no results when searching but no matches found
    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for "Cultural Triangle" or "Samantha"',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show search results with images
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final title = item['title']?.toString() ?? '';
        final subtitle = item['subtitle']?.toString() ?? '';
        final type = item['type']?.toString() ?? '';
        final imageUrl = item['image']?.toString() ?? '';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(type == 'traveller' ? 25 : 8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(type == 'traveller' ? 25 : 8),
              child: _buildImage(imageUrl, title, type),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle.isNotEmpty) 
                Text(subtitle),
              if (type == 'journey' && item['budget'] != null)
                Text(
                  'LKR ${item['budget']} • ${item['duration']} days',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getTypeColor(type),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              type.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () => _onItemTap(item),
        );
      },
    );
  }

  Widget _buildImage(String imagePath, String title, String type) {
    // Check if it's an asset image or network URL
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar(title, type);
        },
      );
    } else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar(title, type);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey[400]!,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return _buildFallbackAvatar(title, type);
    }
  }

  Widget _buildFallbackAvatar(String title, String type) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(type == 'traveller' ? 25 : 8),
      ),
      child: Center(
        child: Text(
          title.isNotEmpty ? title[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'traveller':
        return Colors.blue[600]!;
      case 'journey':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}