
import 'package:flutter/material.dart';

class SessionSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SessionSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SessionSearchBar> createState() =>
      _SessionSearchBarState();
}

class _SessionSearchBarState
    extends State<SessionSearchBar> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(
      _onControllerChanged,
    );

    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        8,
      ),
      child: TextField(
        controller: widget.controller,

        // Không dùng setState ở đây
        // Chỉ gửi giá trị tìm kiếm lên SessionTab
        onChanged: widget.onChanged,

        textInputAction:
            TextInputAction.search,

        decoration: InputDecoration(
          hintText: 'Search session...',
          prefixIcon: const Icon(
            Icons.search,
          ),

          // Nút clear chỉ hiện khi có text
          suffixIcon:
              widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.clear,
                      ),
                      tooltip: 'Clear',
                    )
                  : null,

          filled: true,
          fillColor:
              Colors.grey.shade100,

          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                BorderSide.none,
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide:
                const BorderSide(
              color: Colors.green,
              width: 1.5,
            ),
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}

