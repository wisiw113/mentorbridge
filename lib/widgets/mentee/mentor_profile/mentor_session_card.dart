import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';

class MentorSessionCard extends StatelessWidget {
final String title;
final String description;
final String date;
final String startTime;
final String endTime;
final int bookedSlots;
final int maxSlots;
final String status;
final VoidCallback? onTap;
final VoidCallback? onJoin;

const MentorSessionCard({
super.key,
required this.title,
required this.description,
required this.date,
required this.startTime,
required this.endTime,
required this.bookedSlots,
required this.maxSlots,
required this.status,
this.onTap,
this.onJoin,
});

bool get _isOpen {
return status.toLowerCase() == "open";
}

bool get _isFull {
return bookedSlots >= maxSlots;
}

bool get _canJoin {
return _isOpen && !_isFull;
}

String get _statusText {
switch (status.toLowerCase()) {
case "open":
return "Open";

 
  case "full":
    return "Full";

  case "completed":
    return "Completed";

  case "cancelled":
    return "Cancelled";

  default:
    return status;
}
 

}

Color get _statusColor {
switch (status.toLowerCase()) {
case "open":
return AppColors.deepGreen;

 
  case "full":
    return Colors.orange;

  case "completed":
    return Colors.blueGrey;

  case "cancelled":
    return AppColors.error;

  default:
    return AppColors.gray;
}
 

}

@override
Widget build(BuildContext context) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(18),

 
  child: Container(
    width: double.infinity,
    margin: const EdgeInsets.only(
      bottom: 14,
    ),
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius:
          BorderRadius.circular(18),

      border: Border.all(
        color:
            AppColors.border.withOpacity(.5),
      ),

      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(.04),
          blurRadius: 8,
          offset:
              const Offset(0, 3),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // =================================================
        // HEADER
        // =================================================

        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors.deepGreen,
                ),
              ),
            ),

            const SizedBox(width: 10),

            _buildStatusBadge(),
          ],
        ),

        const SizedBox(height: 10),

        // =================================================
        // DESCRIPTION
        // =================================================

        if (description
            .trim()
            .isNotEmpty)
          Text(
            description,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style:
                const TextStyle(
              fontSize: 13,
              height: 1.4,
              color:
                  AppColors.darkGray,
            ),
          ),

        const SizedBox(height: 16),

        // =================================================
        // DATE
        // =================================================

        _buildInfoRow(
          icon:
              Icons.calendar_month_outlined,
          value: date,
        ),

        const SizedBox(height: 8),

        // =================================================
        // TIME
        // =================================================

        _buildInfoRow(
          icon:
              Icons.access_time_outlined,
          value:
              "$startTime - $endTime",
        ),

        const SizedBox(height: 8),

        // =================================================
        // PARTICIPANTS
        // =================================================

        _buildInfoRow(
          icon:
              Icons.people_outline,
          value:
              "$bookedSlots / $maxSlots participants",
        ),

        const SizedBox(height: 16),

        // =================================================
        // SLOT PROGRESS
        // =================================================

        _buildProgressBar(),

        const SizedBox(height: 16),

        // =================================================
        // ACTION
        // =================================================

        Row(
          children: [
            Expanded(
              child:
                  OutlinedButton(
                onPressed: onTap,
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      AppColors.deepGreen,

                  side:
                      const BorderSide(
                    color:
                        AppColors.deepGreen,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child:
                    const Text(
                  "View Details",
                ),
              ),
            ),

            if (_canJoin &&
                onJoin != null) ...[
              const SizedBox(width: 10),

              Expanded(
                child:
                    ElevatedButton(
                  onPressed:
                      onJoin,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.deepGreen,

                    foregroundColor:
                        AppColors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  child:
                      const Text(
                    "Join",
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  ),
);
 

}

// =========================================================
// STATUS BADGE
// =========================================================

Widget _buildStatusBadge() {
return Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),

 
  decoration:
      BoxDecoration(
    color:
        _statusColor.withOpacity(.1),

    borderRadius:
        BorderRadius.circular(
      20,
    ),
  ),

  child: Text(
    _statusText,
    style:
        TextStyle(
      fontSize: 11,
      fontWeight:
          FontWeight.w600,
      color:
          _statusColor,
    ),
  ),
);
 

}

// =========================================================
// INFO ROW
// =========================================================

Widget _buildInfoRow({
required IconData icon,
required String value,
}) {
return Row(
children: [
Icon(
icon,
size: 18,
color:
AppColors.deepGreen,
),

 
    const SizedBox(width: 8),

    Expanded(
      child: Text(
        value,
        maxLines: 1,
        overflow:
            TextOverflow.ellipsis,
        style:
            const TextStyle(
          fontSize: 13,
          color:
              AppColors.darkGray,
        ),
      ),
    ),
  ],
);
 

}

// =========================================================
// PROGRESS BAR
// =========================================================

Widget _buildProgressBar() {
final double progress =
maxSlots > 0
? (bookedSlots / maxSlots)
.clamp(0.0, 1.0)
: 0.0;

 
return Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Participants",
          style:
              TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
            color:
                AppColors.darkGray,
          ),
        ),

        Text(
          "$bookedSlots / $maxSlots",
          style:
              const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            color:
                AppColors.deepGreen,
          ),
        ),
      ],
    ),

    const SizedBox(height: 7),

    ClipRRect(
      borderRadius:
          BorderRadius.circular(
        10,
      ),

      child:
          LinearProgressIndicator(
        value:
            progress,
        minHeight: 7,
        backgroundColor:
            AppColors.softMint,
        valueColor:
            AlwaysStoppedAnimation<
                Color>(
          _statusColor,
        ),
      ),
    ),
  ],
);
 

}
}
