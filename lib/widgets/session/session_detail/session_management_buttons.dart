import 'package:flutter/material.dart';

class SessionManagementButtons
    extends StatelessWidget {
  final bool visible;
  final bool loading;
  final VoidCallback onCancel;

  const SessionManagementButtons({
    super.key,
    required this.visible,
    required this.loading,
    required this.onCancel,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed:
              loading ? null : onCancel,
          icon: const Icon(
            Icons.cancel_outlined,
          ),
          label: Text(
            loading
                ? "Processing..."
                : "Cancel Session",
          ),
          style:
              OutlinedButton.styleFrom(
            foregroundColor:
                const Color(0xFFEF4444),
            side:
                const BorderSide(
              color:
                  Color(0xFFEF4444),
            ),
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}