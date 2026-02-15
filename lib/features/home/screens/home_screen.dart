import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/features/home/data/model/task_model.dart';

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(AppAssets.logo, width: 90),
            const Spacer(),
            SizedBox(width: 5),
            Image.asset(AppAssets.logout, height: 30, width: 30),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: Text(
                "Log out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        bottom: BottomDatePicker(
          onDateChange: (date) {
            // New date selected
            setState(() {
              _selectedDate = date;
              getAllTasks(date);
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : tasks.isEmpty
                ? EmptyHomeScreen()
                : DataHomeScreen(tasks: tasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => BottomSheetAddTask(
              notifyTasks: () {
                getAllTasks(_selectedDate);
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF5F33E1),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  void getAllTasks(DateTime date) async {
    isLoading = true;
    final result = await HomeFirebase.getTasks(date);
    isLoading = false;

    switch (result) {
      case Success<List<TaskModel>>():
        tasks = result.value;
        setState(() {});
        break;

      case ErrorState<List<TaskModel>>():
        AppDialog.showError(context: context, message: result.error);
        break;
    }
  }
}

class EmptyHomeScreen extends StatelessWidget {
  const EmptyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.homeEmpty),
        SizedBox(height: 5),
        Text(
          "What do you want to do today?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color(0xff404147),
          ),
        ),
        Text(
          "Tap + to add your tasks",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff404147),
          ),
        ),
      ],
    );
  }
}

class DataHomeScreen extends StatelessWidget {
  const DataHomeScreen({super.key, required this.tasks});
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => Card(
          color: Color(0xff5F33E1),
          child: ListTile(
            leading: Text(
              tasks[index].priority.toString(),
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              tasks[index].date.toString(),
              style: TextStyle(color: Colors.white),
            ),
            title: Text(
              tasks[index].title ?? "",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              tasks[index].description ?? "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        itemCount: tasks.length,
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
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: Colors.black,
      selectedTextColor: Colors.white,
      height: 100,
      onDateChange: onDateChange,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
