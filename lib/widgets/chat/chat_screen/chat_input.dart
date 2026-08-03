
import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          10,
          12,
          10,
        ),

        decoration: const BoxDecoration(
          color: AppColors.white,

          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,

          children: [
            // =================================================
            // TEXT FIELD
            // =================================================

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.softMint,

                  borderRadius:
                      BorderRadius.circular(22),

                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),

                child: TextField(
                  controller: controller,

                  minLines: 1,
                  maxLines: 4,

                  textCapitalization:
                      TextCapitalization.sentences,

                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 14,
                  ),

                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',

                    hintStyle: TextStyle(
                      color: AppColors.gray,
                      fontSize: 14,
                    ),

                    border: InputBorder.none,

                    contentPadding:
                        EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // =================================================
            // SEND BUTTON
            // =================================================

            GestureDetector(
              onTap: isSending ? null : onSend,

              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 200),

                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: isSending
                      ? AppColors.gray
                      : AppColors.mintGreen,

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),

                child: isSending
                    ? const Padding(
                        padding: EdgeInsets.all(12),

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColors.white,
                        size: 22,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

