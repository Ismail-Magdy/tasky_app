import 'package:flutter/material.dart';

import '../utils/app_assets.dart';

class AlertDialogTaskPriority extends StatefulWidget {
  const AlertDialogTaskPriority({super.key, required this.getPriority});
  final void Function(int) getPriority;

  @override
  State<AlertDialogTaskPriority> createState() =>
      _AlertDialogTaskPriorityState();
}

class _AlertDialogTaskPriorityState extends State<AlertDialogTaskPriority> {
  final List<int> priorities = List.generate(10, (index) => index + 1);
  int selectedPriority = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: .min,
        children: const [
          Text(
            "Task Priority",
            style: TextStyle(
              color: Colors.black,
              fontWeight: .bold,
              fontSize: 16,
            ),
          ),
          Divider(),
        ],
      ),
      content: Wrap(
        children: priorities
            .map<_ItemTaskPriority>(
              (index) => _ItemTaskPriority(
                index,
                selectedPriority == index,
                onTap: () {
                  selectedPriority = index;
                  widget.getPriority(selectedPriority);
                  setState(() {});
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ItemTaskPriority extends StatelessWidget {
  const _ItemTaskPriority(this.index, this.isSelected, {this.onTap});

  final int index;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        padding: const .symmetric(vertical: 7, horizontal: 20),
        margin: EdgeInsets.only(right: 3, bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff5F33E1) : null,
          borderRadius: .circular(10),
          border: .all(color: isSelected ? Color(0xff5F33E1) : Colors.grey),
        ),
        child: Column(
          spacing: 7,
          children: [
            Image.asset(
              AppAssets.flagIcon,
              height: 24,
              width: 24,
              color: isSelected ? Colors.white : null,
            ),
            Text(
              index.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: .bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
