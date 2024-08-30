import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whoru/screen/auth/join/s_join.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_create.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_update.dart';

class ActivityCreateTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final OnValueChanged? onValueChanged;

  const ActivityCreateTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.onValueChanged,
  });

  @override
  ConsumerState<ActivityCreateTextField> createState() =>
      _ActivityCreateTextFieldState();
}

class _ActivityCreateTextFieldState
    extends ConsumerState<ActivityCreateTextField> {
  late String? initialValue;
  late String? pickedTime;
  @override
  void initState() {
    // TODO: implement initState
    pickedTime = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getActivity = ref.read(activityUpdateStateProvider);
    if (getActivity != null) {
      switch (widget.label) {
        case "제목":
          initialValue = getActivity.title;
          break;
        case "제한인원":
          initialValue = getActivity.players.length.toString();
          break;
        case "시간":
          if (pickedTime == widget.hintText) {
            String formatedDate = DateFormat("yyyy년 M월 d일 a hh:mm", "ko")
                .format(getActivity.time.toDate());
            initialValue = formatedDate;
          } else {
            initialValue = pickedTime;
          }

          break;
        case "장소":
          initialValue = getActivity.place;
          break;
        case "상세설명":
          initialValue = getActivity.description ?? " ";
          break;
      }
    }
    widget.controller.text = initialValue!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: widget.label != "상세설명" ? 50 : null,
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onValueChanged,
            textInputAction: widget.label == "상세설명"
                ? TextInputAction.newline
                : TextInputAction.next,
            keyboardType: widget.label == "상세설명"
                ? TextInputType.multiline
                : widget.label == "제한인원"
                    ? TextInputType.number
                    : widget.label == "시간"
                        ? TextInputType.datetime
                        : TextInputType.text,
            maxLines: null,
            maxLength: widget.label == "상세설명" ? 100 : null,
            minLines: widget.label == "상세설명" ? 5 : null,
            readOnly: widget.label == "시간" ? true : false,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                labelText: widget.label == "시간" ? pickedTime : widget.label,
                hintText: initialValue == null
                    ? widget.hintText
                    : pickedTime ?? initialValue,
                suffix: widget.label == "시간"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                            onTap: () async {
                              late DateTime selectedDate;
                              late TimeOfDay selectedTime;

                              await showDatePicker(
                                      locale: const Locale('ko', 'KR'),
                                      initialDatePickerMode: DatePickerMode.day,
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100))
                                  .then((date) async {
                                if (date != null) {
                                  selectedDate = date;
                                  await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((time) {
                                    selectedTime = time!;
                                  });
                                }
                              });

                              setState(() {
                                DateTime combinedDateTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute);

                                pickedTime =
                                    DateFormat("yyyy년 M월 d일 a hh:mm", "ko")
                                        .format(combinedDateTime);

                                Timestamp saveTime =
                                    Timestamp.fromDate(combinedDateTime);

                                ref
                                    .watch(activityCreateStateProvider.notifier)
                                    .setActivity(2, saveTime);
                              });
                            },
                            child: const Icon(CupertinoIcons.calendar)),
                      )
                    : null,
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.black45)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
