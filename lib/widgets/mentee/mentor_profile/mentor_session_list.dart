import 'package:flutter/material.dart';

import '/../core/theme/app_colors.dart';
import '/../models/session_model.dart';
import 'mentor_session_card.dart';

class MentorSessionList extends StatelessWidget {
final List<SessionModel> sessions;

final bool isLoading;
final String? errorMessage;

final VoidCallback? onRetry;

final void Function(
SessionModel session,
)? onSessionTap;

final int maxVisibleSessions;

const MentorSessionList({
super.key,
required this.sessions,
this.isLoading = false,
this.errorMessage,
this.onRetry,
this.onSessionTap,
this.maxVisibleSessions = 3,
});

@override
Widget build(BuildContext context) {
// =======================================================
// LOADING
// =======================================================

 
if (isLoading) {
  return _buildLoading();
}

// =======================================================
// ERROR
// =======================================================

if (errorMessage != null &&
    errorMessage!.isNotEmpty) {
  return _buildError();
}

// =======================================================
// EMPTY
// =======================================================

if (sessions.isEmpty) {
  return _buildEmpty();
}

// =======================================================
// LIMIT SESSION DISPLAY
// =======================================================

final visibleSessions =
    sessions
        .take(maxVisibleSessions)
        .toList();

return Container(
  width: double.infinity,
  margin:
      const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  padding:
      const EdgeInsets.all(20),
  decoration:
      BoxDecoration(
    color:
        AppColors.white,
    borderRadius:
        BorderRadius.circular(
      20,
    ),
    boxShadow: [
      BoxShadow(
        color:
            Colors.black.withOpacity(
          .04,
        ),
        blurRadius: 10,
        offset:
            const Offset(0, 4),
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

      _buildHeader(),

      const SizedBox(height: 20),

      // =================================================
      // SESSION CARDS
      // =================================================

      ...visibleSessions.map(
        (session) {
          return MentorSessionCard(
            title:
                session.title,

            description:
                session.description,

            date:
                session.date,

            startTime:
                session.startTime,

            endTime:
                session.endTime,

            bookedSlots:
                session.bookedSlots,

            maxSlots:
                session.maxSlots,

            status:
                session.status,

            onTap:
                onSessionTap == null
                    ? null
                    : () {
                        onSessionTap!(
                          session,
                        );
                      },
          );
        },
      ),

      // =================================================
      // VIEW ALL
      // =================================================

      if (sessions.length >
          maxVisibleSessions)
        _buildViewAllButton(),
    ],
  ),
);
 

}

// =========================================================
// HEADER
// =========================================================

Widget _buildHeader() {
return Row(
children: [
Container(
padding:
const EdgeInsets.all(
8,
),
decoration:
BoxDecoration(
color:
AppColors.mintGreen
.withOpacity(
.12,
),
borderRadius:
BorderRadius.circular(
10,
),
),
child:
const Icon(
Icons.groups_outlined,
color:
AppColors.deepGreen,
size: 22,
),
),

 
    const SizedBox(width: 12),

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Mentor Sessions",
            style:
                TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
              color:
                  AppColors.deepGreen,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            "${sessions.length} session${sessions.length > 1 ? 's' : ''}",
            style:
                TextStyle(
              fontSize: 13,
              color:
                  AppColors.gray,
            ),
          ),
        ],
      ),
    ),
  ],
);
 

}

// =========================================================
// LOADING
// =========================================================

Widget _buildLoading() {
return Container(
width: double.infinity,
margin:
const EdgeInsets.symmetric(
horizontal: 20,
),
padding:
const EdgeInsets.all(
30,
),
decoration:
BoxDecoration(
color:
AppColors.white,
borderRadius:
BorderRadius.circular(
20,
),
),
child:
const Center(
child:
CircularProgressIndicator(),
),
);
}

// =========================================================
// ERROR
// =========================================================

Widget _buildError() {
return Container(
width: double.infinity,
margin:
const EdgeInsets.symmetric(
horizontal: 20,
),
padding:
const EdgeInsets.all(
20,
),
decoration:
BoxDecoration(
color:
AppColors.white,
borderRadius:
BorderRadius.circular(
20,
),
border:
Border.all(
color:
AppColors.error
.withOpacity(
.2,
),
),
),
child:
Column(
children: [
const Icon(
Icons.error_outline,
size: 40,
color:
AppColors.error,
),

 
      const SizedBox(height: 10),

      const Text(
        "Không thể tải Session",
        style:
            TextStyle(
          fontSize: 15,
          fontWeight:
              FontWeight.bold,
          color:
              AppColors.darkGray,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        errorMessage ??
            "Đã xảy ra lỗi.",
        textAlign:
            TextAlign.center,
        style:
            TextStyle(
          fontSize: 13,
          color:
              AppColors.gray,
        ),
      ),

      if (onRetry != null) ...[
        const SizedBox(height: 15),

        OutlinedButton(
          onPressed:
              onRetry,
          child:
              const Text(
            "Thử lại",
          ),
        ),
      ],
    ],
  ),
);
 

}

// =========================================================
// EMPTY
// =========================================================

Widget _buildEmpty() {
return Container(
width: double.infinity,
margin:
const EdgeInsets.symmetric(
horizontal: 20,
),
padding:
const EdgeInsets.symmetric(
vertical: 30,
horizontal: 20,
),
decoration:
BoxDecoration(
color:
AppColors.white,
borderRadius:
BorderRadius.circular(
20,
),
),
child:
Column(
children: [
Icon(
Icons.groups_outlined,
size: 45,
color:
AppColors.gray,
),

 
      const SizedBox(height: 12),

      const Text(
        "Chưa có Session",
        style:
            TextStyle(
          fontSize: 16,
          fontWeight:
              FontWeight.bold,
          color:
              AppColors.darkGray,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        "Mentor hiện chưa có Session nào đang mở.",
        textAlign:
            TextAlign.center,
        style:
            TextStyle(
          fontSize: 13,
          color:
              AppColors.gray,
        ),
      ),
    ],
  ),
);
 

}

// =========================================================
// VIEW ALL BUTTON
// =========================================================

Widget _buildViewAllButton() {
return SizedBox(
width: double.infinity,
child:
OutlinedButton(
onPressed:
onSessionTap == null
? null
: () {
// Việc mở trang
// "All Sessions"
// nên được xử lý
// ở MentorProfileScreen.
},
style:
OutlinedButton.styleFrom(
foregroundColor:
AppColors.deepGreen,
side:
const BorderSide(
color:
AppColors.deepGreen,
),
padding:
const EdgeInsets.symmetric(
vertical: 12,
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
const Text(
"View all sessions",
style:
TextStyle(
fontWeight:
FontWeight.w600,
),
),
),
);
}
}
