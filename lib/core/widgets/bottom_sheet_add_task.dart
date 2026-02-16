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
  const BottomSheetAddTask({
    super.key,
    required this.notifyTasks,
    this.taskToEdit,
  });

  final void Function() notifyTasks;
  final TaskModel? taskToEdit;

  @override
  State<BottomSheetAddTask> createState() => _BottomSheetAddTaskState();
}

class _BottomSheetAddTaskState extends State<BottomSheetAddTask> {
  late DateTime selectedDate;
  late int selectedPriority;
  late TextEditingController title;
  late TextEditingController description;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.taskToEdit?.title ?? "");
    description = TextEditingController(
      text: widget.taskToEdit?.description ?? "",
    );
    selectedDate = widget.taskToEdit?.date ?? DateTime.now();
    selectedPriority = widget.taskToEdit?.priority ?? 1;
  }

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
            widget.taskToEdit == null ? "Add Task" : "Edit Task",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff404147),
            ),
          ),
          const SizedBox(height: 20),

          TextFormFieldWidget(
            title: "Title",
            hintText: "Enter task title",
            controller: title,
            myValidator: ValidatorApp.validateName,
          ),

          const SizedBox(height: 16),

          TextFormFieldWidget(
            title: "Description",
            hintText: "Enter task Description",
            controller: description,
            myValidator: ValidatorApp.validateName,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _IconAddTask(
                imagePath: AppAssets.timerIcon,
                onTap: () async {
                  selectedDate =
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: selectedDate,
                      ) ??
                      selectedDate;
                },
              ),
              const SizedBox(width: 10),
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
                onTap: _saveTaskLogic,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _saveTaskLogic() async {
    if (title.text.isEmpty) return;

    AppDialog.showLoading(context);

    final task = TaskModel(
      id: widget.taskToEdit?.id,
      title: title.text,
      description: description.text,
      date: selectedDate,
      priority: selectedPriority,
      isDone: widget.taskToEdit?.isDone ?? false,
    );

    final result = widget.taskToEdit == null
        ? await HomeFirebase.addTask(task)
        : await HomeFirebase.updateTask(task);

    Navigator.of(context).pop();

    if (result is Success) {
      widget.notifyTasks();
      Navigator.of(context).pop(true);
    } else if (result is ErrorState) {
      AppDialog.showError(context: context, message: (result).error);
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
