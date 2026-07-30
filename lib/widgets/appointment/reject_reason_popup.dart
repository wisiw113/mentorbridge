import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/appointment/reject_reason_option.dart';

class RejectReasonPopup extends StatefulWidget {
  const RejectReasonPopup({
    super.key,
  });

  @override
  State<RejectReasonPopup> createState() =>
      _RejectReasonPopupState();
}

class _RejectReasonPopupState
    extends State<RejectReasonPopup> {
  String? selectedReason;

  final TextEditingController _otherController =
      TextEditingController();

  final List<String> reasons = [
    "Tôi không có thời gian vào thời điểm này",
    "Lịch hẹn không phù hợp với tôi",
    "Tôi đã có lịch khác",
    "Nội dung yêu cầu không phù hợp",
    "Khác",
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _submit() {
    if (selectedReason == null) {
      _showError("Vui lòng chọn một lý do.");
      return;
    }

    if (selectedReason == "Khác") {
      final otherReason =
          _otherController.text.trim();

      if (otherReason.isEmpty) {
        _showError(
          "Vui lòng nhập lý do từ chối.",
        );
        return;
      }

      Navigator.pop(context, otherReason);
      return;
    }

    Navigator.pop(context, selectedReason);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom:
              MediaQuery.of(context)
                  .viewInsets
                  .bottom +
              20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Từ chối yêu cầu",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Vui lòng chọn lý do để mentee biết vì sao yêu cầu bị từ chối.",
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            ...reasons.map(
              (reason) {
                return RejectReasonOption(
                  reason: reason,
                  isSelected:
                      selectedReason == reason,
                  onTap: () {
                    setState(() {
                      selectedReason = reason;
                    });
                  },
                );
              },
            ),

            if (selectedReason == "Khác") ...[
              const SizedBox(height: 8),

              TextField(
                controller: _otherController,
                maxLines: 3,
                autofocus: true,
                decoration: InputDecoration(
                  hintText:
                      "Nhập lý do từ chối...",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          AppColors.deepGreen,
                      padding:
                          const EdgeInsets
                              .symmetric(
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
                    child: const Text("Hủy"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.error,
                      foregroundColor:
                          AppColors.white,
                      padding:
                          const EdgeInsets
                              .symmetric(
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
                    child:
                        const Text("Từ chối"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}