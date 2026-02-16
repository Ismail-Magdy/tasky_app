import 'package:flutter/material.dart';

class BuildInfoWidget extends StatelessWidget {
  const BuildInfoWidget({
    super.key,
    required this.image,
    required this.title,
    required this.value,
  });
  final String image;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image, width: 25),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
