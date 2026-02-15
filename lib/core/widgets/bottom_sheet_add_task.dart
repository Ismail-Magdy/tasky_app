import 'package:flutter/material.dart';
import 'package:tasky_app/core/helpers/validator_app.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/core/widgets/text_form_field_widget.dart';
import '../../features/home/data/firebase/home_firebase.dart';
import '../../features/home/data/model/task_model.dart';

import '../utils/app_assets.dart';
import '../utils/app_dialog.dart';
import 'alert_dialog_task_priority.dart';

class BottomSheetAddTask extends StatefulWidget {
  const BottomSheetAddTask({super.key, required this.notifyTasks});
  final void Function() notifyTasks;

  @override
  State<BottomSheetAddTask> createState() => _BottomSheetAddTaskState();
}

class _BottomSheetAddTaskState extends State<BottomSheetAddTask> {
  DateTime selectedDate = DateTime.now();
  int selectedPriority = 1;
  var title = TextEditingController();
  var description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Task",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff404147),
            ),
          ),
          SizedBox(height: 20),

          TextFormFieldWidget(
            title: "Title",
            hintText: "Enter task title",
            controller: title,
            myValidator: ValidatorApp.validateName,
          ),

          SizedBox(height: 16),

          TextFormFieldWidget(
            title: "Description",
            hintText: "Enter task Description",
            controller: description,
            myValidator: ValidatorApp.validateName,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _IconAddTask(
                imagePath: AppAssets.timerIcon,
                onTap: () async {
                  selectedDate =
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        initialDate: DateTime.now(),
                      ) ??
                      DateTime.now();
                },
              ),
              SizedBox(width: 10),
              _IconAddTask(
                imagePath: AppAssets.flagIcon,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialogTaskPriority(
                      getPriority: (p) {
                        selectedPriority = p;
                      },
                    ),
                  );
                },
              ),
              const Spacer(),
              _IconAddTask(
                imagePath: AppAssets.sendIcon,
                onTap: _addTaskOFirebase,
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void _addTaskOFirebase() async {
    AppDialog.showLoading(context);

    final task = TaskModel(
      title: title.text,
      description: description.text,
      date: selectedDate,
      priority: selectedPriority,
    );

    final result = await HomeFirebase.addTask(task);
    Navigator.of(context).pop();

    switch (result) {
      case Success<TaskModel>():
        Navigator.of(context).pop();
        widget.notifyTasks;

      case ErrorState<TaskModel>():
        AppDialog.showError(context: context, message: result.error);
    }
  }
}

class _IconAddTask extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const _IconAddTask({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(imagePath, height: 24, width: 24, fit: BoxFit.contain),
    );
  }
}
