import 'package:flutter/material.dart';
import 'package:journeyq/features/search/data.dart';
import 'package:go_router/go_router.dart';

// Search widget for the search page
class SearchPageWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onBack;

  const SearchPageWidget({
    super.key,
    this.hintText = 'Search travellers, destinations, trips...',
    this.controller,
    this.onChanged,
    this.onBack,
  });

  @override
  State<SearchPageWidget> createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
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
    return Row(
      children: [
        // Back Button OUTSIDE the search box
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: widget.onBack,
        ),

        // Search box
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                // Removed back button from here
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
                        horizontal: 2,
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
          ),
        ),
      ],
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
    Navigator.pop(context);
    final title = item['title']?.toString() ?? 'Unknown';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Selected: $title')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: SearchPageWidget(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onBack: () => context.pop(context),
          hintText: 'Search travellers, destinations, trips...',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
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
              'Start typing to search',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Find travellers, destinations, and trips',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
              'Try searching for something else',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackAvatar(title);
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
                    )
                  : _buildFallbackAvatar(title),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
          trailing: type.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          onTap: () => _onItemTap(item),
        );
      },
    );
  }

  Widget _buildFallbackAvatar(String title) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(25),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
