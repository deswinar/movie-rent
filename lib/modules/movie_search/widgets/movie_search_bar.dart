import 'package:flutter/material.dart';

class MovieSearchBar extends StatefulWidget {
  const MovieSearchBar({
    super.key,
    this.onSearch,
    this.readOnly = false,
    this.initialValue = '',
    this.hintText = 'Search for movies...',
  });

  final void Function(String)? onSearch;
  final bool readOnly;
  final String initialValue;
  final String hintText;

  @override
  State<MovieSearchBar> createState() => _MovieSearchBarState();
}

class _MovieSearchBarState extends State<MovieSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    widget.onSearch?.call(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: widget.readOnly,
      onSubmitted: _handleSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _controller.clear();
            widget.onSearch?.call('');
          },
        ),
      ),
      onTap: widget.readOnly
          ? () {
              FocusScope.of(context).unfocus();
              // Optionally: trigger navigation or callback if needed
            }
          : null,
    );
  }
}
