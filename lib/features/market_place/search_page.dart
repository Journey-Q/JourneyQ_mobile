import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class Market_SearchPage extends StatefulWidget {
  const Market_SearchPage({Key? key}) : super(key: key);

  @override
  State<Market_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<Market_SearchPage> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  String selectedLocation = 'All Locations';
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> allResults = [];
  bool isSearching = false;
  bool hasSearched = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static const Color primaryColor = Color(0xFF1976D2);

  final List<String> locations = [
    'All Locations',
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Sigiriya',
    'Ella',
    'Nuwara Eliya',
    'Trincomalee',
    'Batticaloa',
    'Matara',
    'Hikkaduwa',
    'Bentota'
  ];

  // Dummy search results data
  final List<Map<String, dynamic>> dummyResults = [
    // Hotels
    {
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Colombo',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/shangri_la.jpg',
      'rating': 4.8,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Galle Face Hotel',
      'location': 'Colombo',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/galle_face.jpg',
      'rating': 4.5,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Cinnamon Grand Colombo',
      'location': 'Colombo',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/cinnamon_grand.jpg',
      'rating': 4.7,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Earl\'s Regency',
      'location': 'Kandy',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/earls_regency.jpg',
      'rating': 4.6,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Jetwing Lighthouse',
      'location': 'Galle',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/jetwing_lighthouse.jpg',
      'rating': 4.9,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Grand Hotel Nuwara Eliya',
      'location': 'Nuwara Eliya',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/grand_hotel.jpg',
      'rating': 4.4,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    {
      'name': 'Ella Rock House',
      'location': 'Ella',
      'serviceType': 'Hotel',
      'profileImage': 'assets/images/ella_rock.jpg',
      'rating': 4.8,
      'icon': Icons.hotel,
      'color': primaryColor,
    },
    
    // Travel Agencies
    {
      'name': 'Ceylon Roots',
      'location': 'Colombo',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/ceylon_roots.jpg',
      'rating': 4.9,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Jetwing Travels',
      'location': 'Colombo',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/jetwing.jpg',
      'rating': 4.8,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Aitken Spence',
      'location': 'Colombo',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/aitken_spence.jpg',
      'rating': 4.7,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Walkers Tours',
      'location': 'Kandy',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/walkers.jpg',
      'rating': 4.6,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Red Dot Tours',
      'location': 'Galle',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/red_dot.jpeg',
      'rating': 4.5,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Nuwara Eliya Travel Co.',
      'location': 'Nuwara Eliya',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/nuwara_travel.jpg',
      'rating': 4.3,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    {
      'name': 'Ella Adventure Tours',
      'location': 'Ella',
      'serviceType': 'Travel Agency',
      'profileImage': 'assets/images/ella_adventure.jpg',
      'rating': 4.7,
      'icon': Icons.directions_car,
      'color': primaryColor,
    },
    
    // Tour Guides
    {
      'name': 'Saman Perera',
      'location': 'Colombo',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_saman.jpg',
      'rating': 4.9,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Nimal Silva',
      'location': 'Kandy',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_nimal.jpg',
      'rating': 4.8,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Chamara Fernando',
      'location': 'Galle',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_chamara.jpg',
      'rating': 4.7,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Ruwan Jayasinghe',
      'location': 'Nuwara Eliya',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_ruwan.jpg',
      'rating': 4.6,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Tharindu Weerasinghe',
      'location': 'Ella',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_tharindu.jpg',
      'rating': 4.8,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Kasun Rathnayake',
      'location': 'Sigiriya',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_kasun.jpg',
      'rating': 4.9,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
    {
      'name': 'Dilan Madushanka',
      'location': 'Anuradhapura',
      'serviceType': 'Tour Guide',
      'profileImage': 'assets/images/guide_dilan.jpg',
      'rating': 4.7,
      'icon': Icons.person_pin_circle,
      'color': primaryColor,
    },
  ];

  @override
  void initState() {
    super.initState();
    allResults = List.from(dummyResults);
    searchResults = [];
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _performSearch() {
    String query = searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        hasSearched = false;
        isSearching = false;
      });
      _animationController.reset();
      return;
    }

    setState(() {
      isSearching = true;
      hasSearched = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      List<Map<String, dynamic>> filtered = allResults.where((result) {
        bool matchesLocation = selectedLocation == 'All Locations' || 
                              result['location'] == selectedLocation;
        
        bool matchesQuery = result['name'].toLowerCase().contains(query) ||
                           result['serviceType'].toLowerCase().contains(query) ||
                           result['location'].toLowerCase().contains(query);
        
        return matchesLocation && matchesQuery;
      }).toList();
      
      setState(() {
        searchResults = filtered;
        isSearching = false;
      });
      
      _animationController.forward();
    });
  }

  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            LucideIcons.mapPin,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Select Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Location list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    String location = locations[index];
                    bool isSelected = selectedLocation == location;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? primaryColor.withOpacity(0.1) : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedLocation = location;
                            });
                            Navigator.pop(context);
                            _performSearch();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                      ? primaryColor.withOpacity(0.15)
                                      : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    location == 'All Locations' 
                                      ? LucideIcons.globe 
                                      : LucideIcons.mapPin,
                                    color: isSelected 
                                      ? primaryColor
                                      : Colors.grey.shade600,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected 
                                        ? FontWeight.w600 
                                        : FontWeight.w500,
                                      color: isSelected 
                                        ? primaryColor 
                                        : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected) 
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search hotels, agencies, guides...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          LucideIcons.search,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  _performSearch();
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.black54,
                                    size: 16,
                                  ),
                                ),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      _performSearch();
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Location Filter Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showLocationBottomSheet,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: selectedLocation != 'All Locations' 
                                  ? primaryColor.withOpacity(0.15)
                                  : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                LucideIcons.mapPin,
                                color: selectedLocation != 'All Locations' 
                                  ? primaryColor
                                  : Colors.grey.shade600,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedLocation,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: selectedLocation != 'All Locations' 
                                        ? primaryColor
                                        : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Tap to change location',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Search Results
          Expanded(
            child: isSearching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Searching...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  )
                : !hasSearched
                    ? _buildSearchPrompt()
                    : searchResults.isEmpty
                        ? _buildNoResults()
                        : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPrompt() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.search,
                size: 48,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Start Your Search',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover amazing hotels, travel agencies,\nand expert tour guides',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.searchX,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms\nor change the location filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return _buildSearchResultCard(searchResults[index], index);
        },
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleResultTap(result),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Profile Image/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryColor.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      result['profileImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            result['icon'],
                            color: primaryColor,
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              LucideIcons.mapPin,
                              size: 14,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            result['location'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              result['serviceType'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  result['rating'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
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
        ),
      ),
    );
  }

  void _handleResultTap(Map<String, dynamic> result) {
    String serviceType = result['serviceType'];
    
    switch (serviceType) {
      case 'Hotel':
        context.push('/marketplace/hotels/details', extra: result);
        break;
      case 'Travel Agency':
        context.push('/marketplace/travel_agencies/details', extra: result);
        break;
      case 'Tour Guide':
        context.push('/marketplace/tour_guides/details', extra: result);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }
}