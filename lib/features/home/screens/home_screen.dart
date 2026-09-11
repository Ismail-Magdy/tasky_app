import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/features/home/data/model/task_model.dart';
import 'package:tasky_app/features/home/screens/task_details_screen.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/widgets/bottom_sheet_add_task.dart';
import '../../auth/screens/login_screen.dart';
import '../data/firebase/home_firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  bool isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getAllTasks(_selectedDate);
  }

  void updateTask(TaskModel task) async {
    AppDialog.showLoading(context);
    final result = await HomeFirebase.toggleTaskStatus(task);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    if (result is Success) {
      getAllTasks(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(AppAssets.logo, width: 80),
            const Spacer(),
            Image.asset(AppAssets.logout, height: 25, width: 25),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: const Text("Log out", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        bottom: BottomDatePicker(
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
              getAllTasks(date);
            });
          },
        ),
      ),
      body: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                ? const EmptyHomeScreen()
                : DataHomeScreen(
                    tasks: tasks,
                    onTapCheck: (task) => updateTask(task),
                    onTapTask: (task) async {
                      final isDeleted = await Navigator.pushNamed(
                        context,
                        TaskDetailsScreen.routeName,
                        arguments: task,
                      );
                      if (isDeleted == true) {
                        getAllTasks(_selectedDate);
                      }
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => BottomSheetAddTask(
              notifyTasks: () => getAllTasks(_selectedDate),
            ),
          );
        },
        backgroundColor: const Color(0xFF5F33E1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void getAllTasks(DateTime date) async {
    isLoading = true;
    final result = await HomeFirebase.getTasks(date);
    isLoading = false;
    if (result is Success<List<TaskModel>>) {
      tasks = result.value;
      setState(() {});
    }
  }
}

class EmptyHomeScreen extends StatelessWidget {
  const EmptyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Image.asset(AppAssets.homeEmpty),
          const SizedBox(height: 5),
          const Text(
            "What do you want to do today?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: .w400,
              color: Color(0xff404147),
            ),
          ),
          const Text(
            "Tap + to add your tasks",
            style: TextStyle(
              fontSize: 16,
              fontWeight: .w400,
              color: Color(0xff404147),
            ),
          ),
        ],
      ),
    );
  }
}

class DataHomeScreen extends StatelessWidget {
  const DataHomeScreen({
    super.key,
    required this.tasks,
    required this.onTapCheck,
    required this.onTapTask,
  });
  final List<TaskModel> tasks;
  final Function(TaskModel) onTapCheck;
  final Function(TaskModel) onTapTask;

  @override
  Widget build(BuildContext context) {
    final pending = tasks.where((t) => t.isDone == false).toList();
    final completed = tasks.where((t) => t.isDone == true).toList();

    return Expanded(
      child: ListView(
        children: [
          ...pending.map((task) => _buildTaskCard(task, context)),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: 20),
            Align(
              alignment: .centerLeft,
              child: Chip(
                label: const Text("Completed"),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 10),
            ...completed.map((task) => _buildTaskCard(task, context)),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, BuildContext context) {
    return Container(
      margin: const .only(bottom: 12),
      padding: const .all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: .circular(15),
        border: .all(color: Colors.grey),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => onTapCheck(task),
            child: Icon(
              task.isDone!
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: const Color(0xff5F33E1),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () => onTapTask(task),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    task.title ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: .w500,
                      decoration: task.isDone! ? .lineThrough : null,
                      color: task.isDone! ? Colors.grey : Colors.black,
                    ),
                  ),
                  Text(
                    "Today At ${task.date?.hour}:${task.date?.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const .symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: .circular(8),
              border: .all(color: Color(0xff5F33E1)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.flag_outlined,
                  size: 14,
                  color: Color(0xff5F33E1),
                ),
                const SizedBox(width: 4),
                Text(
                  task.priority.toString(),
                  style: const TextStyle(
                    color: Color(0xff5F33E1),
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomDatePicker extends StatelessWidget implements PreferredSizeWidget {
  const BottomDatePicker({super.key, this.onDateChange});

  final void Function(DateTime)? onDateChange;

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      .now(),
      initialSelectedDate: .now(),
      selectionColor: Colors.black,
      selectedTextColor: Colors.white,
      height: 120,
      onDateChange: onDateChange,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
