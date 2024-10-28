import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    super.key,
    required this.note,
    required this.index,
  });

  final Note note;
  final int index;

  // Define light colors
  static final List<Color> _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100,
  ];

  // Define dark colors
  static final List<Color> _darkColors = [
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.deepOrangeAccent,
    Colors.pinkAccent,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode
        ? _darkColors[index % _darkColors.length]
        : _lightColors[index % _lightColors.length];

    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.isImportant)
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    'Important',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note.description,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }


  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
