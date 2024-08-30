import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/screen/home/activity/component/w_activity_create_textfield.dart';

import '../controller/c_activity_create.dart';

class CreatTextFieldArea extends ConsumerStatefulWidget {
  const CreatTextFieldArea({super.key});

  @override
  ConsumerState<CreatTextFieldArea> createState() => _CreatTextFieldAreaState();
}

class _CreatTextFieldAreaState extends ConsumerState<CreatTextFieldArea> {
  List<String> labelList = ["제목", "제한인원", "시간", "장소", "상세설명"];

  List<String> informList = [];

  List<String> hintTextList = [
    "제목을 입력해주세요",
    "숫자만 입력해주세요",
    "날짜와 시간을 선택해주세요",
    "업체명 또는 상세주소를 입력해주세요",
    "100자 이내로 입력해주세요"
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(activityCreateStateProvider.notifier);

    return Column(
      children: [
        ActivityCreateTextField(
            controller: titleController,
            label: "제목",
            hintText: "제목을 입력해주세요",
            onValueChanged: (value) {
              provider.setActivity(0, value);
            }),
        ActivityCreateTextField(
            controller: memberController,
            label: "제한인원",
            hintText: "숫자만 입력해주세요",
            onValueChanged: (value) {
              provider.setActivity(1, value);
            }),
        ActivityCreateTextField(
          controller: timeController,
          label: "시간",
          hintText: "날짜와 시간을 선택해주세요",
        ),
        ActivityCreateTextField(
            controller: placeController,
            label: "장소",
            hintText: "상호명 또는 상세주소를 입력해주세요",
            onValueChanged: (value) {
              provider.setActivity(3, value);
            }),
        ActivityCreateTextField(
            controller: descriptionController,
            label: "상세설명",
            hintText: "100자 이내로 입력해주세요",
            onValueChanged: (value) {
              value = value.split("\n").join("\n");
              provider.setActivity(4, value);
            }),
      ],
    );
  }
}
