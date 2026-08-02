import 'package:flutter/material.dart';

class PendingSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PendingSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<PendingSearchBar> createState() =>
      _PendingSearchBarState();
}

class _PendingSearchBarState
    extends State<PendingSearchBar> {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_updateClearButton);
  }

  @override
  void dispose() {
    widget.controller.removeListener(
      _updateClearButton,
    );

    super.dispose();
  }

  void _updateClearButton() {
    // Chỉ rebuild riêng SearchBar
    // để hiện / ẩn nút X
    if (mounted) {
      setState(() {});
    }
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

        // Không setState PendingTab
        // Chỉ gửi text ra ngoài
        onChanged: widget.onChanged,

        textInputAction:
            TextInputAction.search,

        decoration: InputDecoration(
          hintText:
              'Tìm Mentor, chủ đề, ghi chú...',

          prefixIcon: const Icon(
            Icons.search,
          ),

          suffixIcon:
              widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();

                        widget.onChanged('');
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
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
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}