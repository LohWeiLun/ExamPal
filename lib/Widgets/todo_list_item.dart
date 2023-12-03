import 'package:flutter/material.dart';

class TodoListItem extends StatelessWidget {
  final String text;
  final String id;
  final int index;
  late bool isChecked;
  final VoidCallback onPress;
  final VoidCallback? onDelete; // Add this line to make onDelete optional

  TodoListItem({
    required this.text,
    required this.isChecked,
    required this.onPress,
    required this.id,
    required this.index,
    this.onDelete, // Add this line to make onDelete optional
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color(0xFF031956),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                isChecked
                    ? GestureDetector(
                  onTap: onPress,
                  child: Container(
                    padding: const EdgeInsets.all(4.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: const Color(0xFF8E13BA),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: onPress,
                  child: const Icon(
                    Icons.circle_outlined,
                    color: Color(0xFF8E13BA),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (onDelete != null) // Display delete icon only if onDelete is provided
              GestureDetector(
                onTap: onDelete!,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white, // You can customize the delete icon color
                ),
              ),
          ],
        ),
      ),
    );
  }
}
