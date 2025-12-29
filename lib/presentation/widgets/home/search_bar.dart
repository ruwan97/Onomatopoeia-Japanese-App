import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/core/themes/app_text_styles.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onSearchChanged(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Search onomatopoeia...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          onPressed: _clearSearch,
        )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
      ),
      style: AppTextStyles.bodyMedium,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}