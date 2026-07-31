import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/theme/app_colors.dart';

import '../../../models/appointment_model.dart';
import '../../../models/session_model.dart';
import '../../../models/schedule_item.dart';

import '../../../services/appointment_service.dart';
import '../../../services/session_service.dart';

import '../../../widgets/mentor/mentor_home/greeting_card.dart';
import '../../../widgets/mentor/mentor_home/request_card.dart';
import '../../../widgets/mentor/mentor_home/summary_card.dart';
import '../../../widgets/mentor/mentor_home/upcoming_appointment_card.dart';
import '../../../widgets/mentor/mentor_home/upcoming_session.dart';
import '../../../widgets/mentor/mentor_home/weekly_schedule_card.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;


    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Chưa đăng nhập"),
        ),
      );
    }


    return Scaffold(
      backgroundColor: AppColors.lightMint,

      body: SafeArea(

        child: StreamBuilder<List<AppointmentModel>>(

          stream: AppointmentService()
              .getMentorRequests(user.uid),


          builder: (context, appointmentSnapshot) {


            if (!appointmentSnapshot.hasData) {

              return const Center(
                child:
                    CircularProgressIndicator(),
              );

            }


            final appointments =
                appointmentSnapshot.data!;



            return StreamBuilder<List<SessionModel>>(

              stream: SessionService()
                  .getMentorSessions(user.uid),


              builder: (context, sessionSnapshot) {


                if (!sessionSnapshot.hasData) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );

                }


                final sessions =
                    sessionSnapshot.data!;



                final upcomingAppointments =
                    appointments
                        .where(
                          (e) =>
                              e.status ==
                              "accepted",
                        )
                        .toList();



                final upcomingSessions =
                    sessions
                        .where(
                          (e) =>
                              e.status ==
                              "open",
                        )
                        .toList();



                final scheduleItems = [

                  ...sessions.map(
                    ScheduleItem.fromSession,
                  ),

                  ...appointments.map(
                    ScheduleItem.fromAppointment,
                  ),

                ];



                return ListView(

                  padding:
                      const EdgeInsets.all(16),


                  children: [


                    GreetingCard(

                      mentorName:
                          user.displayName ??
                          "Mentor",

                    ),



                    const SizedBox(height:20),



                    Row(

                      children: [

                        Expanded(

                          child: SummaryCard(

                            title:
                                "Sessions",

                            value:
                                sessions.length
                                    .toString(),

                            icon:
                                Icons.groups,

                            color:
                                Colors.green,

                          ),

                        ),



                        const SizedBox(width:12),



                        Expanded(

                          child: SummaryCard(

                            title:
                                "Appointments",

                            value:
                                appointments.length
                                    .toString(),

                            icon:
                                Icons.calendar_today,

                            color:
                                Colors.blue,

                          ),

                        ),

                      ],

                    ),




                    const SizedBox(height:12),




                    Row(

                      children: [

                        Expanded(

                          child: SummaryCard(

                            title:
                                "Pending",

                            value:
                                appointments
                                    .where(
                                      (e) =>
                                          e.status ==
                                          "pending",
                                    )
                                    .length
                                    .toString(),

                            icon:
                                Icons.pending_actions,

                            color:
                                Colors.orange,

                          ),

                        ),



                        const SizedBox(width:12),



                        Expanded(

                          child: SummaryCard(

                            title:
                                "Completed",

                            value:
                                appointments
                                    .where(
                                      (e) =>
                                          e.status ==
                                          "completed",
                                    )
                                    .length
                                    .toString(),

                            icon:
                                Icons.check_circle,

                            color:
                                Colors.purple,

                          ),

                        ),

                      ],

                    ),




                    const SizedBox(height:20),




                    RequestCard(

                      requests:
                          appointments,

                    ),





                    if (upcomingAppointments.isNotEmpty) ...[

                      const SizedBox(height:20),


                      UpcomingAppointmentCard(

                        appointment:
                            upcomingAppointments.first,

                        onPressed: () {},

                      ),

                    ],




                    if (upcomingSessions.isNotEmpty) ...[

                      const SizedBox(height:20),


                      UpcomingSessionCard(

                        session:
                            upcomingSessions.first,

                        onPressed: () {},

                      ),

                    ],





                    const SizedBox(height:20),




                    WeeklyScheduleCard(

                      schedules:
                          scheduleItems,


                      onDayTap: (day){},


                      onViewAll: () {},

                    ),

                  ],

                );

              },

            );

          },

        ),

      ),

    );

  }

}