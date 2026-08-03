import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';
import '../../../services/cloudinary_service.dart';
import '../../../services/session_service.dart';

import '../../../widgets/session/session_create/create_session_button.dart';
import '../../../widgets/session/session_create/session_date_picker.dart';
import '../../../widgets/session/session_create/session_duration_selector.dart';
import '../../../widgets/session/session_create/session_error_dialog.dart';
import '../../../widgets/session/session_create/session_file_picker.dart';
import '../../../widgets/session/session_create/session_text_field.dart';
import '../../../widgets/session/session_create/session_time_picker.dart';

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({
    super.key,
  });

  @override
  State<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState
    extends State<CreateSessionScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final SessionService _service =
      SessionService();

  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final slotController =
      TextEditingController(
    text: '5',
  );

  DateTime? selectedDate;

  TimeOfDay? startTime;

  int selectedDuration = 60;

  PlatformFile? selectedFile;

  bool loading = false;

  String formatTime(
    TimeOfDay time,
  ) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay? get endTime {
    if (startTime == null) {
      return null;
    }

    final totalMinutes =
        startTime!.hour * 60 +
            startTime!.minute +
            selectedDuration;

    if (totalMinutes >= 24 * 60) {
      return null;
    }

    return TimeOfDay(
      hour: totalMinutes ~/ 60,
      minute: totalMinutes % 60,
    );
  }

  DateTime? get startDateTime {
    if (selectedDate == null ||
        startTime == null) {
      return null;
    }

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );
  }

  DateTime? get endDateTime {
    final start =
        startDateTime;

    if (start == null) {
      return null;
    }

    return start.add(
      Duration(
        minutes:
            selectedDuration,
      ),
    );
  }

  Future<void> pickDocument() async {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'doc',
        'docx',
      ],
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file =
        result.files.single;

    if (file.bytes == null) {
      if (!mounted) return;

      SessionErrorDialog.show(
        context,
        message:
            'Không thể đọc file.',
      );

      return;
    }

    final fileSizeInMB =
        file.bytes!.length /
            (1024 * 1024);

    if (fileSizeInMB > 5) {
      if (!mounted) return;

      SessionErrorDialog.show(
        context,
        message:
            'File không được lớn hơn 5 MB.',
      );

      return;
    }

    setState(() {
      selectedFile = file;
    });
  }

  Future<void> createSession() async {
    if (loading) {
      return;
    }

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    if (selectedDate == null) {
      await SessionErrorDialog.show(
        context,
        message:
            'Vui lòng chọn ngày Session.',
      );
      return;
    }

    if (startTime == null) {
      await SessionErrorDialog.show(
        context,
        message:
            'Vui lòng chọn thời gian bắt đầu.',
      );
      return;
    }

    if (endTime == null ||
        endDateTime == null) {
      await SessionErrorDialog.show(
        context,
        message:
            'Thời lượng Session vượt quá giới hạn trong ngày.',
      );
      return;
    }

    final start =
        startDateTime!;

    final end =
        endDateTime!;

    if (!start.isAfter(
      DateTime.now(),
    )) {
      await SessionErrorDialog.show(
        context,
        message:
            'Thời gian bắt đầu phải ở trong tương lai.',
      );
      return;
    }

    if (!end.isAfter(start)) {
      await SessionErrorDialog.show(
        context,
        message:
            'Thời gian kết thúc phải sau thời gian bắt đầu.',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final user =
          FirebaseAuth
              .instance
              .currentUser;

      if (user == null) {
        throw Exception(
          'Bạn chưa đăng nhập.',
        );
      }

      String? fileUrl;

      if (selectedFile != null) {
        fileUrl =
            await CloudinaryService
                .uploadDocument(
          selectedFile!,
        );

        if (fileUrl == null) {
          throw Exception(
            'Không thể tải tài liệu lên.',
          );
        }
      }

      final session =
          SessionModel(
        id: '',

        mentorId:
            user.uid,

        mentorName:
            user.displayName ??
                'Mentor',

        title:
            titleController.text
                .trim(),

        description:
            descriptionController
                .text
                .trim(),

        date:
            '${selectedDate!.year}-'
            '${selectedDate!.month.toString().padLeft(2, '0')}-'
            '${selectedDate!.day.toString().padLeft(2, '0')}',

        startTime:
            formatTime(
          startTime!,
        ),

        endTime:
            formatTime(
          endTime!,
        ),

        startAt:
            start,

        endAt:
            end,

        maxSlots:
            int.parse(
          slotController.text
              .trim(),
        ),

        bookedSlots: 0,

        status: 'open',

        createdAt:
            DateTime.now(),

        fileUrl:
            fileUrl,

        fileName:
            selectedFile?.name,
      );

      await _service
          .createSession(
        session,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Tạo Session thành công.',
          ),
        ),
      );

      Navigator.pop(
        context,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      final message = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );

      await SessionErrorDialog.show(
        context,
        message: message,
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    slotController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.softMint,

      appBar: AppBar(
        title: const Text(
          'Create Session',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent,
        elevation: 0,
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(18),

        child: Card(
          elevation: 2,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(18),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  SessionTextField(
                    controller:
                        titleController,
                    labelText:
                        'Session Title',
                    prefixIcon:
                        Icons.title,
                    validator:
                        (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Please enter session title';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  SessionTextField(
                    controller:
                        descriptionController,
                    labelText:
                        'Description',
                    prefixIcon:
                        Icons
                            .notes_outlined,
                    maxLines: 3,
                    validator:
                        (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Please enter description';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  SessionFilePicker(
                    selectedFile:
                        selectedFile,
                    onPick:
                        pickDocument,
                    onRemove: () {
                      setState(() {
                        selectedFile =
                            null;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  SessionTextField(
                    controller:
                        slotController,
                    labelText:
                        'Maximum Participants',
                    prefixIcon:
                        Icons
                            .groups_outlined,
                    keyboardType:
                        TextInputType
                            .number,
                    validator:
                        (value) {
                      if (value ==
                              null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Please enter maximum participants';
                      }

                      final number =
                          int.tryParse(
                        value.trim(),
                      );

                      if (number ==
                              null ||
                          number <= 0) {
                        return 'Invalid number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SessionDatePicker(
                    selectedDate:
                        selectedDate,
                    onDateSelected:
                        (date) {
                      setState(() {
                        selectedDate =
                            date;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  SessionTimePicker(
                    selectedTime:
                        startTime,
                    onTimeSelected:
                        (time) {
                      setState(() {
                        startTime =
                            time;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  SessionDurationSelector(
                    selectedDuration:
                        selectedDuration,
                    onChanged:
                        (duration) {
                      setState(() {
                        selectedDuration =
                            duration;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  if (endTime != null)
                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets
                              .all(14),
                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .lightMint,
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .schedule,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Text(
                            'End Time: '
                            '${formatTime(endTime!)}',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 30,
                  ),

                  SessionCreateButton(
                    loading:
                        loading,
                    onPressed:
                        createSession,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

