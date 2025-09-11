import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/search_repositories/search_repo.dart';

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
  bool isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredItems = [];
        isLoading = false;
      }
    });

    if (query.isNotEmpty) {
      // Set loading state immediately
      setState(() {
        isLoading = true;
      });
      
      // Create new timer to delay search
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _performSearch(query);
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty || !mounted) return;
    
    try {
      final results = await SearchRepository.searchContent(
        query: query,
        limit: 20,
      );
      
      if (mounted) {
        setState(() {
          filteredItems = results;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          filteredItems = [];
          isLoading = false;
        });
      }
    }
  }

  void _onItemTap(Map<String, dynamic> item) {
    final itemType = item['type']?.toString() ?? '';
    
    // Navigate based on item type
    switch (itemType) {
      case 'traveller':
        // Validate required data before navigation
        final userId = item['id']?.toString();
        final userName = item['title']?.toString();
        
        if (userId != null && userId.isNotEmpty && userName != null && userName.isNotEmpty) {
          final encodedUserName = Uri.encodeComponent(userName);
          context.push('/user-profile/$userId/$encodedUserName');
        } else {
          // Show error if data is missing
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to load user profile - missing data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;
        
      case 'journey':
        // Validate journey ID before navigation
        final journeyId = item['id']?.toString();
        
        if (journeyId != null && journeyId.isNotEmpty) {
          context.push('/journey/$journeyId');
        } else {
          // Show error if data is missing
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to load journey - missing data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;
        
      default:
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${item['title'] ?? 'Unknown'}'),
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

    // Show loading indicator while searching
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Show no results only when search is complete and no results found
    if (isSearching && !isLoading && filteredItems.isEmpty) {
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
              'Try a different search term',
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
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}