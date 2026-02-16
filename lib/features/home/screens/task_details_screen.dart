import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/utils/app_assets.dart';
import 'package:tasky_app/core/widgets/bottom_sheet_add_task.dart';
import 'package:tasky_app/features/auth/widgets/custom_button.dart';
import 'package:tasky_app/features/home/widgets/build_info_widget.dart';
import '../data/model/task_model.dart';
import '../data/firebase/home_firebase.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/networking/result.dart';

class TaskDetailsScreen extends StatelessWidget {
  static const String routeName = '/task-details';
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    return Scaffold(
      backgroundColor: Colors.white,
      //
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: .circular(5),
            ),
            child: Icon(Icons.close, color: Colors.red),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      //
      body: Padding(
        padding: const .symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  task.isDone!
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: const Color(0xff5F33E1),
                  size: 28,
                ),
                const SizedBox(width: 15),
                Text(
                  task.title ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const .only(left: 43),
              child: Text(
                task.description ?? "No Description",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            BuildInfoWidget(
              image: AppAssets.timerIcon,
              title: "Task Time :",
              value: "Today",
            ),

            const SizedBox(height: 20),
            BuildInfoWidget(
              image: AppAssets.flagIcon,
              title: "Task Priority :",
              value: "Default",
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () async {
                AppDialog.showLoading(context);
                final result = await HomeFirebase.deleteTask(task.id!);
                Navigator.pop(context);

                if (result is Success) {
                  Navigator.pop(context, true);
                } else if (result is ErrorState) {
                  AppDialog.showError(
                    context: context,
                    message: (result).error,
                  );
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/trash.svg"),
                  SizedBox(width: 10),
                  Text(
                    "Delete Task",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onPressed: () async {
                final bool? isUpdated = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) =>
                      BottomSheetAddTask(taskToEdit: task, notifyTasks: () {}),
                );
                if (isUpdated == true) {
                  Navigator.pop(context, true);
                }
              },
              text: "Edit Task",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
