import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class SessionFilePicker extends StatelessWidget {
  final PlatformFile? selectedFile;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  const SessionFilePicker({
    super.key,
    required this.selectedFile,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: AppColors.lightMint,
      leading: const Icon(
        Icons.description_outlined,
      ),
      title: Text(
        selectedFile?.name ??
            "Attach Word document",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: selectedFile == null
          ? const Icon(
              Icons.upload_file,
            )
          : IconButton(
              icon: const Icon(
                Icons.close,
              ),
              onPressed: onRemove,
            ),
      onTap: onPick,
    );
  }
}