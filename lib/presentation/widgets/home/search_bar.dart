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
    return SizedBox(
      height: 48, // Fixed height
      child: Material(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Search onomatopoeia...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(128),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
